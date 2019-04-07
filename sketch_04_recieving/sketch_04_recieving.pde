import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myAddress;
float message;
float motionX;
float motionY;
float[] motionXArray = new float[14];
float[] motionYArray = new float[14];

int countX;
int countY;

float prevMotionX = 0;
float prevMotionY= 0;
float ellipseX;
float ellipseY;
int messageCount;

void setup() {
  size(640,360);
  oscP5 = new OscP5(this,1050); 
  background(255);
  noFill();
  smooth(10);
}

void draw() {
    int motionXLength = 12;
    int motionYLength = 12;
   

    for( countX = 0; countX <= motionXLength; countX++){
      for(countY = 0; countY <= motionYLength; countY++){
          motionXArray[countX] = motionX;
          motionYArray[countY] = motionY;
          
          float x1 = motionXArray[0];
          float y1 = motionYArray[0];
          float x2 = motionXArray[1];
          float y2 = motionYArray[1];
          float x3 = motionXArray[2];
          float y3 = motionYArray[2];
          float x4 = motionXArray[3];
          float y4 = motionYArray[3];
          
          float curve2x1 = motionXArray[4];
          float curve2y1 = motionYArray[4];
          float curve2x2 = motionXArray[5];
          float curve2y2 = motionYArray[5];
          float curve2x3 = motionXArray[6];
          float curve2y3 = motionYArray[6];
          float curve2x4 = motionXArray[7];
          float curve2y4 = motionYArray[7];
          
          line(x1,y1,curve2x4, curve2y4);
          
          noFill();
          stroke(0);
      }
    } 
}

void mouseClicked(){
   noLoop();
}


void oscEvent(OscMessage theOscMessage){
 println("# received osc message:" + theOscMessage.addrPattern() + ", typtag: " + theOscMessage.typetag() + ", length: " + theOscMessage.typetag().length() + ": ");
 for (int i=0; i<theOscMessage.typetag ().length(); i++){
  switch(theOscMessage.typetag().charAt(i)){
    case 'i':
       print(theOscMessage.get(i).intValue() + " * ");
       messageCount = theOscMessage.get(0).intValue();

       break;
     case 'f':
       print(theOscMessage.get(i).floatValue() + " * ");
       motionX = theOscMessage.get(0).floatValue();
       motionY = theOscMessage.get(1).floatValue();
 
       break;
     case 's':
       print(theOscMessage.get(i).stringValue() + " * ");
       break;
   }
   print("\n");
   return;
 }
 
 

}
