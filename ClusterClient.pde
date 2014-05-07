/**
 * ---------------------------------------------
 * ClusterClient.pde
 * Description: Client connection for handling cluster events
 *  This uses Java sockets instead of Processing.net so we can do our own
 *  exception handling
 *
 * Class:
 * System: Processing 2.0b6, SUSE 12.1, Windows 7 x64
 * Author: Arthur Nishimoto
 * Version: 1.0
 * (C) 2014 - Arthur Nishimoto
 *
 * Version Notes:
 * 1/31/14 - Initial version
 * ---------------------------------------------
 */

//import java.net.*; // Socket
//import java.io.*; // InputStreamReader


class ClusterClient
{
  Socket clientSocket;
  DatagramSocket udpSocket;
  
  String masterNodeIP = "127.0.0.1";
  int masterNodePort = 7171;
  
  InputStream inStream;
  OutputStream outStream;
  int xOffset;
  int yOffset;
  
  public ClusterClient()
  {
  }
  
  public void connectToMaster(String masterNodeIP, int masterNodePort)
  {
    try {
      // Establish connection with master
      clientSocket = new Socket(masterNodeIP, masterNodePort);
      
      println("Connected to master node '"+ masterNodeIP + "' port: " + masterNodePort);
      
      inStream = clientSocket.getInputStream();
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
    
    try
    {
      udpSocket = new DatagramSocket(masterUDPPort);
      println("Listening for UDP data from master node on port: " + masterUDPPort);
    }
    catch( SocketException e )
    {
      println(e);
    }
    
    Runnable udp = new Runnable() {
      public void run() {
        while(true)
        {
          listenForUDP();
        }
      }
    };
    Thread udpListenerThread;
    udpListenerThread = new Thread( udp );
  
    udpListenerThread.start();
  }
  
  synchronized void listenForUDP()
  {
    try
    {
      DatagramPacket packet;
      byte[] incomingData = new byte[512];
      packet = new DatagramPacket(incomingData, incomingData.length);
      udpSocket.receive(packet);
      
      String str = new String(incomingData).trim();
      String[] str2 = str.split(",");
      
      /*
      if( str2[0].contains("MediaBrowserDragPos") )
      {
        int ID = Integer.valueOf(str2[1]);
        float xPos = Float.valueOf(str2[2]);
        float yPos = Float.valueOf(str2[3]);
        
        uiManager.dragMediabrowserThumbnailWindow( ID, xPos, yPos);
      }
      */
    }
    catch( IOException e )
    {
      println(e);
    }
  }
  void listenForData()
  {
    try {
      while( inStream.available() > 0 ) {
        println("Incoming TCP data!");

        byte[] incomingData = new byte[512];
        inStream.read(incomingData);
        
        String str = new String(incomingData).trim();
        
        if(str.contains("IPAD_CONNECTED")){
            paintColors[0] = 0;
            paintColors[1] = 0;
            paintColors[2] = 0;
            paintColors[3] = 0;
            tool = 0;
            connectionEstablished = true;
        }
        else if(str.contains("SAVE_IMAGE"))
        {
          saveImage();
        }
        else
        {
          StringTokenizer data = new StringTokenizer(str); 
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
        println(str);
      }
    } catch ( IOException e ){
    }
  }
  
  void cleanup(){
    try{
      clientSocket.close();
      inStream.close();
    } catch ( IOException e ){
      } catch ( NullPointerException e ){
    }
  }

  public void setOffset( int xOffset, int yOffset )
  {
    this.xOffset = xOffset;
    this.yOffset = yOffset;
  }// CTOR
  
  public void pushOffset()
  {
    pushMatrix();
    translate( -xOffset, -yOffset );
  }
  
  public void popOffset()
  {
    popMatrix();
  }
}// class
