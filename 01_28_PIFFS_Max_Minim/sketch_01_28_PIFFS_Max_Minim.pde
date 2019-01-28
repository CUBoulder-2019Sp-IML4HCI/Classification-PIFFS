

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import processing.sound.*;
import ddf.minim.*;

Minim minim;


OscP5 oscP5;
NetAddress dest;

//No need to edit:
PFont currentFont, myFont, myBigFont;
int frameNum = 0;
int lastFive = 0;
int[] lastFiveList = {2,2,2,2,2};
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



void setup() {
  size(680,430);
  background(0,0,0);
  //colorMode(HSB);
  smooth();
  
  //Set up fonts
  myFont = createFont("Arial", 14);
  myBigFont = createFont("Arial", 60);
  
  minim = new Minim(this);
  
  //Set up images  
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
}

void draw() {
  frameRate(60);
  image(currentImg, 0,0);
  drawText();
  
}

//This is called automatically when OSC message is received
void oscEvent(OscMessage theOscMessage) {
 //println("received message");
  if (theOscMessage.checkAddrPattern("/wek/outputs") == true) {
    if(theOscMessage.checkTypetag("f")) {
      float f = theOscMessage.get(0).floatValue();
      println("received1: " + f);
      changeImg((int)f);
      
    }
  }
  
}

void changeImg(int f) {
    if (f == 1) 
    {
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
    else if (f == 2)
    {
      currentSound.pause();
      currentImg = Output2_img;
      currentMessage = "You look like you need a coffee?!";
      currentSound = Output2_Sound;
      currentSound.play();
      currentX= 300;
      currentY= 200;
      currentR= 255;
      currentG= 239;
      currentB= 182;
      currentFont = createFont("Times", 30);
    }
    else if (f == 3)
    {
      currentSound.pause();
      currentImg = Output3_img;
      currentMessage = "FATIGUE WARNING \n WAKE UP!";
      currentSound = Output3_Sound;
      currentSound.play();
      currentX= 40;
      currentY= 0;
      currentR= 0;
      currentG= 0;
      currentB= 0;
      currentFont = createFont("Times", 60);
      
    }

}

//Write instructions to screen.
void drawText() {
//    stroke(0);
    
    textFont(currentFont);
    text(currentMessage, currentX, currentY);
    fill(currentR, currentG, currentB);
    textSize(currentSize);
    //text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
//    textFont(myBigFont);
//    text(currentMessage, 190, 180);
}
