

//Necessary for OSC communication with Wekinator:
import oscP5.*;
import netP5.*;
import processing.sound.*;
import ddf.minim.*;

Minim minim;


OscP5 oscP5;
NetAddress dest;

//No need to edit:
PFont myFont, myBigFont;
int frameNum = 0;
int lastFive = 0;
int[] lastFiveList = {2,2,2,2,2};
PImage Output1_img;
PImage Output2_img;
PImage Output3_img;
PImage currentImg;

AudioPlayer Output1_Sound;
AudioPlayer Output2_Sound;
AudioPlayer Output3_Sound;
AudioPlayer currentSound;

void setup() {
  size(800,500);
  background(0,0,0);
  //colorMode(HSB);
  smooth();
  
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
  myFont = createFont("Helvetica", 20);
  drawText();
}

void draw() {
  frameRate(60);
  image(currentImg, 0,30);
  //currentSound.play();
  
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
      currentSound = Output1_Sound;
      currentSound.play();
      }
    else if (f == 2)
    {
      currentSound.pause();
      currentImg = Output2_img;
      currentSound = Output2_Sound;
      currentSound.play();
    }
    else if (f == 3)
    {
      currentSound.pause();
      currentImg = Output3_img;
      currentSound = Output3_Sound;
      currentSound.play();
    }

}
/*
int getMostFreq(int[] l) {
  int count1, count2, count3,cl;
  count1 = 0;
  count2 = 0;
  count3 = 0;
  
  for (int i=0; i < l.length; i++) {
    cl = l[i];
    if (cl == 1) {
      count1++;
    } else if (cl ==2) {
      count2++;
    } else {
      count3++;
    }
  }
  
  if (count1 > count2 && count1 > count3) {
    return 1;
  } else if (count3 > count1 && count3 > count2) {
    return 3;
  } else {
    return 2;
  }
}

*/

//Write instructions to screen.
void drawText() {
//    stroke(0);
    textFont(myFont);
//    textAlign(LEFT, TOP); 
//    fill(currentTextHue, 255, 255);

    text("PIFFS", 30, 20);
//    text("Listening for OSC message /wek/outputs, port 12000", 10, 30);
    
//    textFont(myBigFont);
//    text(currentMessage, 190, 180);
}
