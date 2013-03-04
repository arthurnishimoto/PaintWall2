/**************************************************
 * Information on how to connect to touch server
 * and some addtional parameters
 */

//Names of machines you might use
ArrayList touchList = new ArrayList();
String trackerIP = ""; // Should use config

//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

boolean enableTracker = false; // Set by config
boolean USING_OMICRON_LEGACY = false;
TouchListener touchListener;
OmicronAPI omicronManager;

void startTouchConnection() {
       touchListener = new TouchListener();
   
   if(enableTracker) {
     if( USING_OMICRON_LEGACY )
      {
        println("Connecting to Legacy Tracker: '"+trackerIP+"' Data port: "+dataPort+" Message port: "+msgPort+".");
        omicronManager.connectToLegacyTracker( dataPort, msgPort, trackerIP );
      }
      else
      {
        println("Connecting to Tracker: '"+trackerIP+"' Data port: "+dataPort+" Message port: "+msgPort+".");
        omicronManager.connectToTracker( dataPort, msgPort, trackerIP );
      }
      omicronManager.setTouchListener( touchListener );
      println("Connected to Tracker");
   }
}

