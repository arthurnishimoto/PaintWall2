import omicronAPI.*;

import processing.net.*;

/**
 * ---------------------------------------------
 * PaintWall_2_0.pde
 * Description: Paint Wall App 2.0
 *
 * Class: 
 * System: Processing 2.0.4 (beta), SUSE 11.4
 * Author: Arthur Nishimoto
 * Version: 2.0
 *
 * Version Notes:
 * 3/19/12      - Initial version
 * ---------------------------------------------
 */

private boolean setJavaFrameEnabled = false;
boolean showWaiting = true; // Show wait for iPad screen
boolean saveTouches = false;

// Uses an offscreen buffer to draw a section of the screen to fix flickering
// on the linux primary window
boolean useDrawBuffer = false;

color backgroundColor = color(0); 
color textColor = color(255);
PFont font;

int appWidth = 8160;
int appHeight = 2304;
int TOUCH_X_OFFSET = 0;
int TOUCH_Y_OFFSET = 0;

private int X_OFFSET = 0;
private int Y_OFFSET = 0;

final int ELLIPSE = 0;
final int SPHERE = 1;
int TOUCH_MODE = ELLIPSE;

Thread waitingThread;
Thread masterNodeThread;

float gameTimer, startTime;
private float frameSetDelay = 3; // Delay in seconds before java frame is set
private boolean javaFrameSet = false;

// Clustering
boolean cluster = false; // If false, this application will act as the iPad server.
                        // If true, this application will attempt to connect to the master node.
int nNodes = 1;
int thisNodeID = 1;
String masterNodeIP = "127.0.0.1";
int masterNodePort = 7171;

// Thread safe flags for toggling Processing functions
boolean setClearScreen = false;
boolean setSaveImage = false;

PGraphics drawBuffer;

 // Override of PApplet init()
public void init() {
  super.init();
  
  readConfigFile("config.cfg");
  
  // Creates the OmicronAPI object. This is placed in init() since we want to use fullscreen
  omicronManager = new OmicronAPI(this);
  
  // Removes the title bar for full screen mode (present mode will not work on Cyber-commons wall)
  omicronManager.setFullscreen(true);
}

 void setup(){
   size( appWidth, appHeight, P3D );

   font = loadFont("ArialMT-36.vlw");
   
   startTouchConnection();
  
  // iPad Thread
  if(connectToiPad && !cluster) {
    Runnable loader = new Runnable() {
      public void run() {
        readData();
      }
    };
    waitingThread = new Thread( loader );
    waitingThread.start();
  }
  
  if( cluster ){
    connectToiPad = false;
    Runnable loader = new Runnable() {
      public void run() {
        connectToMasterNode();
      }
    };
    masterNodeThread = new Thread( loader );
    masterNodeThread.start();
  }
  
 }// setup
 
 void draw(){
   gameTimer = ( millis() - startTime ) / 1000.0;
   
   // Sets the window location
  if( setJavaFrameEnabled && gameTimer > frameSetDelay && !javaFrameSet ){
    frame.setLocation( X_OFFSET, Y_OFFSET );
    javaFrameSet = false;
  }
  
     if(connectToiPad) {
        if( !connectionEstablished && showWaiting ) {
          frameRate(16);
          background(backgroundColor);
          fill(textColor);
          textFont(font, 64);
          textAlign(CENTER);
          text("Waiting for iPad to connect...", width/2, height/2);
        } 
        else if( connectionEstablished && showWaiting ) {
          println("Ipad connected");
          frameRate(60);
          background(backgroundColor);
          showWaiting = false;
        } 
        else {
          readData();
        }
     }
     //fill(50);
     //rect( 0, 0, 1360 *  0.5, 768 * 0.5 );
     //fill(255);
     //text("FPS: " + frameRate, 260, 160 );
     
     drawStuff();
     omicronManager.process();
 }
 
 
