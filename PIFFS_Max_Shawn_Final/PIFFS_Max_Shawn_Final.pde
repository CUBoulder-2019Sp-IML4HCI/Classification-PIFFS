//Authors: Shawn Polson & Max Funck
//The Pilot Fatigue Finding System (PIFFS)
//Detects wakefullness, drowsiness, and sleep using face-tracking input
//and outputs alerts to keep pilots attentive. 

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import processing.sound.*;
import ddf.minim.*;


//Declare global variables
Minim minim;
OscP5 oscP5;
NetAddress dest;

PFont currentFont, myFont, myBigFont;
int currentX= 0;
int currentY= 50;
int currentR= 255;
int currentB= 255;
int currentG= 255;
int currentSize= 20;

String currentMessage = "Welcome to the Flight Deck, please activate your Face Tracking...";
PImage Output1_img;
PImage Output2_img;
PImage Output3_img;
PImage currentImg;
AudioPlayer Output1_Sound;
AudioPlayer Output2_Sound;
AudioPlayer Output3_Sound;
AudioPlayer currentSound;

int numDrowsyDetections = 0; //Note: Wekinator sends 6 input signals a second
int drowsyThreshold = 12; //12 ~= 2 seconds of drowsiness 
int numSleepDetections = 0; //Note: Wekinator sends 6 input signals a second
int sleepThreshold = 18; //18 ~= 3 seconds of sleeping
int state = 1; //Tracks which image/sound combination is currently active


void setup() {
  size(680,430);
  background(0,0,0);
  smooth();
  minim = new Minim(this);
  
  //Set up images and sounds  
  Output1_img = loadImage("Output1_Img_sized.jpg");
  Output2_img = loadImage("Output2_Img_sized.jpg");
  Output3_img = loadImage("Output3_Img_sized.jpg"); 
  Output1_Sound = minim.loadFile("Output1_Sound.mp3");
  Output2_Sound = minim.loadFile("Output2_Sound.mp3");
  Output3_Sound = minim.loadFile("Output3_Sound.mp3");
  
  currentImg = Output1_img;
  currentSound = Output1_Sound;
  
  //Initialize OSC communication
  oscP5 = new OscP5(this,12000); //listen for OSC messages on port 12000 (Wekinator default)
  dest = new NetAddress("127.0.0.1",6448); //send messages back to Wekinator on port 6448, localhost (this machine) (default)
  
  //Set up fonts
  currentFont = createFont("Times", 20);
  drawText();
  //myFont = createFont("Arial", 14);
  //myBigFont = createFont("Arial", 60);
}

void draw() {
  frameRate(60);
  image(currentImg, 0,0);
  drawText();
}

//This is called automatically when OSC message is received
//Note: Wekinator sends 6 messages a second from the face tracking input
void oscEvent(OscMessage theOscMessage) {
 //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("f")) {
      float suggestion = theOscMessage.get(0).floatValue();
      println("received: " + suggestion + "  numDrowsyDetections: " + numDrowsyDetections + "  numSleepDetections: " + numSleepDetections + "  state: " + state);
      int nextState = determineState((int)suggestion);
      changeImgAndSound(nextState);
    }
  }
}

//Swap images and sounds based on classification
void changeImgAndSound(int nextState) {
    if (nextState == 1) {
      state = 1;
      currentSound.pause();
      currentImg = Output1_img;
      currentMessage = "All engines running!";
      currentSound = Output1_Sound;
      currentSound.play();
      currentX= 20;
      currentY= 20;
      currentR= 92;
      currentG= 239;
      currentB= 48;
      currentFont = createFont("Times", 20);
    }
    else if (nextState == 2) {
      state = 2;
      currentSound.pause();
      currentImg = Output2_img;
      currentMessage = "You look like you need a coffee?!";
      currentSound = Output2_Sound;
      currentSound.play();
      currentX= 270;
      currentY= 200;
      currentR= 145;
      currentG= 120;
      currentB= 90;
      currentFont = createFont("Times", 30);
    }
    else if (nextState == 3) {
      state = 3;
      currentSound.pause();
      currentImg = Output3_img;
      currentMessage = "FATIGUE WARNING: \n WAKE UP!";
      currentSound = Output3_Sound;
      currentSound.play();
      currentX= 40;
      currentY= 65;
      currentR= 255;
      currentG= 0;
      currentB= 0;
      currentFont = createFont("Times", 60);
    }
}

int determineState(int suggestion) {
    int nextState = suggestion;
    
    switch(state) { 
        case 1: //Pilot is awake
            if (suggestion == 2) { //Don't flip to the drowsy state until threshold is met
                numDrowsyDetections++;
                if (numDrowsyDetections >= drowsyThreshold) {
                    nextState = 2;  
                } else {
                    nextState = 1; 
                }
            }
            else if (suggestion == 3) { //Don't flip to the asleep state until threshold is met
                numSleepDetections++;
                if (numSleepDetections >= sleepThreshold) {
                    nextState = 3;  
                } else {
                    nextState = 1; 
                }
            }
            break; 
        case 2: //Pilot is drowsy
            numDrowsyDetections = 0;
            if (suggestion == 3) { //Don't flip to the asleep state until threshold is met
                numSleepDetections++;
                if (numSleepDetections >= sleepThreshold) {
                    nextState = 3;  
                } else {
                    nextState = 2; 
                }
            }
            break;
        case 3: //Pilot is asleep
            numDrowsyDetections = 0;
            numSleepDetections = 0;
            break;
        default:
            println("Default reached for some reason.");
            break;
    }
    
    return nextState;  
}

//Write text to screen.
void drawText() { 
    textFont(currentFont);
    text(currentMessage, currentX, currentY);
    fill(currentR, currentG, currentB);
    textSize(currentSize);
    //text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    //textFont(myBigFont);
    //text(currentMessage, 190, 180);
}
