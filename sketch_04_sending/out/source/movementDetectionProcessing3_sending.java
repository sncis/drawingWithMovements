import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.video.*; 
import oscP5.*; 
import netP5.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class movementDetectionProcessing3_sending extends PApplet {





OscP5 oscP5;
NetAddress myAddress;

Capture video; // Capture = Einfang -> new video
PImage prev; // -> PImage datatype to stroe iimages 
float threshold = 25; //schwelle

float motionX = 0; // var to store the detectet motion on x var
float motionY = 0; // var to store the detected motion on y var

//float lerpX = 0; //lerp function calculate a number between two numbers at a specific increment
//float lerpY = 0;
int messageCount = 0;


public void setup() {
  
  video = new Capture(this, width, height);
  video.start();
  prev = createImage(640, 360, RGB); // create an image out of the previous frame
  // Start off tracking for red
  oscP5 = new OscP5(this, 13000);
  myAddress = new NetAddress("127.0.0.1", 1050);
}


//captureEvent is running when a new camera frame is available with the read() 
//function you capture/read the frame
public void captureEvent(Capture video) { 
  //copy the previous image in prev var
  prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
  //update the pives in prev
  prev.updatePixels();
  //read the new frame
  video.read();
}

public void draw() {
  
  video.loadPixels(); // load the pixels from current video
  prev.loadPixels(); // load the pixels from prev video
  image(video, 0, 0); //draw image to the display window at point 0,0

  threshold = 100;

  int count = 0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      int currentColor = video.pixels[loc];
      float r1 = red(currentColor); //extract the red(color) from the given pixel
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      int prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2);  //calculating the difference between all the red,green,blue pixels
     
      if (d > threshold*threshold) {
        avgX += x;
        avgY += y;
        count++;
        pixels[loc] = color(255);
      } else {
        pixels[loc] = color(0);
      }
    }
  }
  updatePixels();

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number 
  //depending on how accurate you require the tracking to be.
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
  }
  
 
  //lerpX = lerp(lerpX, motionX, .1); 
  //lerpY = lerp(lerpY, motionY, .1); 
  
  OscMessage message = new OscMessage("/test");
  message.add(motionX);
  message.add(motionY);
  message.add(messageCount);
  oscP5.send(message, myAddress);
  
  println("motionsX:" + motionX);
  println("motionsY:" + motionY);
  println("messageCount:" + messageCount);
  messageCount ++;

}

public float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
  public void settings() {  size(640, 360); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "movementDetectionProcessing3_sending" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
