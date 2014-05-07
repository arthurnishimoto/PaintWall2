/**************************************************
 * Imports
 */


//Variables:
boolean connectToiPad = false;
boolean connectionEstablished = false;
ServerSocket myServer;
Socket mySocket;
BufferedReader inFromClient;
String dataFromClient;
int iPadPort = 13337;
Socket socketToMaster;

void readData()
{
  if(connectionEstablished) {
    try {
      inFromClient = new BufferedReader(new InputStreamReader(mySocket.getInputStream()));
      if(inFromClient.ready() == true) {
        //Data read in from touch server
        dataFromClient = inFromClient.readLine();
        if(dataFromClient != null) {
          
          if( clusterEnabled && isMaster )
            clusterServer.sendTCPString( dataFromClient );
            
          //println(dataFromClient);
          if(dataFromClient.equals("999 999 999 999 999")) {
            paintColors[0] = 0;
            paintColors[1] = 0;
            paintColors[2] = 0;
            paintColors[3] = 0;
            tool = 0;
            connectionEstablished = false;
            showWaiting = false;
            try { 
              mySocket.close();
            }
            catch(Exception e) {
            }
            try { 
              myServer.close();
            }
            catch(Exception e) {
            }
            myServer = null;
            mySocket = null;
            return;
          }          
          StringTokenizer data = new StringTokenizer(dataFromClient); 
          int arrayLoc = -1;
          while(data.hasMoreTokens()) {
            String temp = data.nextToken();
            int tempInt = parseInt(temp);
            if(arrayLoc == -1) {
              tool = tempInt - 100;
              arrayLoc++;
            }
            else {
              paintColors[arrayLoc] = tempInt - 100;
              arrayLoc++;
            }
          }  
          dataFromClient = null;
        }
      }
    }
    catch(Exception e) {
      print(e);
    }
  }
  else {
    if( clusterEnabled && isMaster ){
      connectClient();
    }
    else
    {
      //connectToMasterNode();
    }
  }
}

void connectClient() {
  //try-catch block for starting the server on WALL.
  try {
    println("Waiting for iPad client");
    myServer = new ServerSocket(iPadPort);
    mySocket = myServer.accept();
    System.out.println( " IPAD CLIENT"+" "+ mySocket.getInetAddress() +":"+mySocket.getPort()+" IS CONNECTED ");
    connectionEstablished = true;
    if( clusterEnabled && isMaster )
      clusterServer.sendTCPString("IPAD_CONNECTED");
  }
  catch(Exception e) {
    println("Server connection had an error!!!:" + e);
  }
}

void connectToMasterNode(){
  BufferedReader incomingReader;
  PrintWriter outStream;
  String incomingMessage;
   
  try {
    // Establish connection with master
    println("Connecting to Master Control Node '"+masterNodeIP+"' port '"+masterNodePort+"'");
    println("Waiting for response...");
    socketToMaster = new Socket(masterNodeIP, masterNodePort);
            
    // Create an incoming message reader
    incomingReader = new BufferedReader(new InputStreamReader(
                                        socketToMaster.getInputStream()));
                                        
    // Create ouput message writer
    outStream = new PrintWriter( socketToMaster.getOutputStream(), true);
  
    // Keep checking for messages
    while ((incomingMessage = incomingReader.readLine()) != null) {
      println("Receiving: '" +incomingMessage+"'");
      
        // Check message
        if( incomingMessage.contains("SET_NODE_ID") ){
          println("Connected to MCN ");
          thisNodeID = Integer.valueOf( incomingMessage.substring( incomingMessage.indexOf("=")+2, incomingMessage.lastIndexOf(" ") ) );
          println("MCN is setting node ID to " + thisNodeID);
          mySocket = socketToMaster;
          outStream.println(thisNodeID);
        }
        else if( incomingMessage.contains("CLEAR_SCREEN") ){
          println("MCN is clearing the screen");
          setClearScreen = true;
        }
        else if( incomingMessage.contains("SAVE_SCREEN") ){
          println("MCN is saving the current image");
          setSaveImage = true;
        }
        else if( incomingMessage.contains("IPAD_OFF") ){
          connectionEstablished = false;
        }
        else if( incomingMessage.contains("IPAD:") ){
          connectionEstablished = true;
          incomingMessage = incomingMessage.substring( incomingMessage.indexOf(":")+1, incomingMessage.lastIndexOf(" ") );
          println("iPad message '"+incomingMessage+"'");
          if(incomingMessage.equals("999 999 999 999 999")) {
            paintColors[0] = 0;
            paintColors[1] = 0;
            paintColors[2] = 0;
            paintColors[3] = 0;
            tool = 0;
            connectionEstablished = false;
            showWaiting = true;
            continue;
          }          
          StringTokenizer data = new StringTokenizer(incomingMessage); 
          int arrayLoc = -1;
          while(data.hasMoreTokens()) {
            String temp = data.nextToken();
            int tempInt = parseInt(temp);
            if(arrayLoc == -1) {
              tool = tempInt - 100;
              arrayLoc++;
            }
            else {
              paintColors[arrayLoc] = tempInt - 100;
              arrayLoc++;
            }
          }  
        }
        else{
          println("MCN sent unknown command '"+incomingMessage+"'");
          println("Currently supported commands are:");
          println("SET_NODE_ID");
          println("RESET_FRAME");
          println("CLEAR_SCREEN");
          println("SAVE_SCREEN");
          println();
        }
    }
    
  } 
  catch (UnknownHostException e) {
    System.err.println("Unknown host: "+ masterNodeIP);
    exit();
  } 
  catch (IOException e) {
    System.err.println("Couldn't get I/O for "
      + masterNodeIP + " on port " + masterNodePort);
    System.err.println(e);
    exit();
  }
}
