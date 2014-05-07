class EventServer
{
  int nodeListenPort = 7171;
  int udpPort = 8101;
  
  Hashtable clients;
  ServerSocket listenerSocket;
  
  public EventServer( int port, int uPort )
  {
    clients = new Hashtable();
    
    nodeListenPort = port;
    udpPort = uPort;
    
    try{
      listenerSocket = new ServerSocket(nodeListenPort);

      println("EventServer: Server started at " + InetAddress.getLocalHost().getHostAddress() + " port: "+ nodeListenPort);
    } catch( IOException e ) {
      println("EventServer: Failed to start server");
    }
    
  }
  
  public synchronized void sendTCPEvent( Event event ){
    //println("Sending to clients: '"+message+"'");
    Enumeration e = clients.elements();
    while( e.hasMoreElements() ){
      EventClient client = (EventClient)e.nextElement();
      client.sendTCPEvent(event);
    }
  }
  
  public synchronized void sendTCPString( String s )
  {
    //println("Sending to clients (TCP): '"+s+"'");
    Enumeration e = clients.elements();
    while( e.hasMoreElements() ){
      EventClient client = (EventClient)e.nextElement();
      client.sendTCPString(s);
    }
  }
  
  public synchronized void sendUDPEvent( Event event ){
    Enumeration e = clients.elements();
    while( e.hasMoreElements() ){
      EventClient client = (EventClient)e.nextElement();
      client.sendUDPEvent(event);
    }
  }
  
  public synchronized void sendUDPString( String s ){
    //println("Sending to clients (UDP): '"+s+"'");
    Enumeration e = clients.elements();
    while( e.hasMoreElements() ){
      EventClient client = (EventClient)e.nextElement();
      client.sendUDPString(s);
    }
  }
  
  public synchronized void sendByteArray( byte[] data ){
    //println("Sending to clients: '"+message+"'");
    Enumeration e = clients.elements();
    while( e.hasMoreElements() ){
      EventClient client = (EventClient)e.nextElement();
      client.sendTCPByteArray(data);
    }
  }
  
  private synchronized void addClient( EventClient newNode ){
    // Add node to list
    if( clients.containsKey( newNode.clientAddress ) ){
      println("EventServer: Client " + newNode.clientAddress + " already exists");
    } else {
      println("EventServer: Client " + newNode.clientAddress + " added");
    }
    clients.put( newNode.clientAddress, newNode ); // Adds/updates nodes
  }
  
  public void listenForClients(){
    Runnable clients = new Runnable() {
      public void run() {
        while(true)
        {
          Socket nodeSocket;
          try{
            nodeSocket = listenerSocket.accept();
            int nodePort = nodeSocket.getPort();
            String nodeAddress = nodeSocket.getInetAddress().getHostAddress();
            println("EventServer: Client "+ nodeAddress + ":"+nodePort+" connecting...");
            addClient( new EventClient( nodeSocket, udpPort ) );
          } catch( IOException e ) {
            println("EventServer: Failed to accept client");
          }
        }
      }
    };
    Thread clientListenerThread;
    clientListenerThread = new Thread( clients );
  
    clientListenerThread.start();    
  }
}// class

class EventClient{
  Socket clientSocket;
  String clientAddress;
  int clientPort;
  
  DatagramSocket udpSocket;
  int udpPort;
  
  OutputStream outStream;
  ByteArrayOutputStream byteArrayStream;
  
  public EventClient( Socket socket, int dataPort )
  {
    clientSocket = socket;
    clientPort = clientSocket.getPort();
    clientAddress = clientSocket.getInetAddress().getHostAddress();
    println("EventClient: New client '" + clientAddress + "' port: " + clientPort );
    
    try
    {
      udpSocket = new DatagramSocket();
    }
    catch( SocketException e )
    {
      println(e);
    }
    
    udpPort = dataPort;
    byteArrayStream = new ByteArrayOutputStream();
  }
  
  public void sendTCPEvent( Event e )
  {
    //sendTCPByteArray( eventToBinaryPacket( e ) );
  }
  
  public void sendTCPString( String s )
  {
    // Pad string and append new line ending
    //println( s.length() );
    while( s.length() < 511 )
    {
      s += " ";
    }
    s += "\n";
    
    byte[] b = s.getBytes();
    sendTCPByteArray( b );
    
    //String str = new String(b);
    //println("Sending string: '" + str + "'");
  }
  
  public void sendTCPByteArray( byte[] data )
  {
    try
    {
      outStream = clientSocket.getOutputStream();
      
      byteArrayStream.reset();
      byteArrayStream.write( data, 0, data.length );
      byteArrayStream.writeTo(outStream);
    }
    catch( IOException e )
    {
      println(e);
    }
  }
  
  public void sendUDPEvent( Event e )
  {
    /*
    try
    {
      DatagramPacket packet;
      byte[] buf = eventToBinaryPacket( e );
      packet = new DatagramPacket(buf, buf.length, clientSocket.getInetAddress(), udpPort);
      udpSocket.send(packet);
      //println("sending UDP to " + clientSocket.getInetAddress() + " port: " +udpPort);
    }
    catch( IOException ioe )
    {
      println(ioe);
    }
    */
  }
  
  public void sendUDPString( String s )
  {
    // Pad string and append new line ending
    //println( s.length() );
    while( s.length() < 511 )
    {
      s += " ";
    }
    s += "\n";
    
    byte[] buf = s.getBytes();
    DatagramPacket packet;
    packet = new DatagramPacket(buf, buf.length, clientSocket.getInetAddress(), udpPort);
    
    try
    {
      udpSocket.send(packet);
    }
    catch( IOException ioe )
    {
      println(ioe);
    }
  }
}// class
