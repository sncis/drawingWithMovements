import processing.video.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myAddress;

Capture video; 
PImage prev; 
float threshold = 25; 

float motionX = 0; 
float motionY = 0;

int messageCount = 0;


void setup() {
  size(640, 360);
  video = new Capture(this, width, height);
  video.start();
  prev = createImage(640, 360, RGB);
  oscP5 = new OscP5(this, 13000);
  myAddress = new NetAddress("127.0.0.1", 1050);
}


void captureEvent(Capture video) { 
  prev.copy(video, 0, 0, video.width, video.height, 0, 0, prev.width, prev.height);
  prev.updatePixels();
  video.read();
}

void draw() {
  
  video.loadPixels(); 
  prev.loadPixels();
  image(video, 0, 0); 

  threshold = 100;

  int count =0;
  
  float avgX = 0;
  float avgY = 0;

  loadPixels();
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;

      color currentColor = video.pixels[loc];
      float r1 = red(currentColor); 
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      color prevColor = prev.pixels[loc];
      float r2 = red(prevColor);
      float g2 = green(prevColor);
      float b2 = blue(prevColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); 
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

 
  if (count > 200) { 
    motionX = avgX / count;
    motionY = avgY / count;
  }
  
  OscMessage message = new OscMessage("/test");
  message.add(motionX);
  message.add(motionY);
  message.add(messageCount);
  oscP5.send(message, myAddress);
  messageCount ++;

}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}
