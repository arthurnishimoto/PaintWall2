/**
 * Parses a config file for touch tracker information.
 * By Arthur Nishimoto
 * 
 * @param config_file Text file containing tracker information.
 */
void readConfigFile(String config_file){
  String[] rawConfig = loadStrings(config_file);

  trackerIP = "localhost";
  if( rawConfig == null ){
    println("No tracker information provided by config.cfg. Connecting to localhost.");
  }
  else {
    String tempStr = "";

    for( int i = 0; i < rawConfig.length; i++ ){
      rawConfig[i].trim(); // Removes leading and trailing white space
      if( rawConfig[i].length() == 0 ) // Ignore blank lines
        continue;

      if( rawConfig[i].contains("//") ) // Removes comments
          rawConfig[i] = rawConfig[i].substring( 0 , rawConfig[i].indexOf("//") );

      if( rawConfig[i].contains("TRACKER_MACHINE") ){
        trackerIP = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        enableTracker = true;
        continue;
      }
      if( rawConfig[i].contains("DATA_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        dataPort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("MSG_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        msgPort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if ( rawConfig[i].contains("DATA_TYPE") ) {
        if( rawConfig[i].contains("LEGACY") )
          USING_OMICRON_LEGACY = true;
        if( rawConfig[i].contains("OMICRON") )
          USING_OMICRON_LEGACY = false;
        continue;
      }
      
      if( rawConfig[i].contains("CLUSTER_ENABLED") && rawConfig[i].contains("true") ){
        clusterEnabled = true;
        println("Config: Cluster mode enabled");
        continue;
      }
      
      if( clusterEnabled && rawConfig[i].contains("MASTER_NODE_IP") )
      {
        try
        {
          String myIP = InetAddress.getLocalHost().getHostAddress();
          String nodeIPStr = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
          masterNodeIP = nodeIPStr;
          if( myIP.contains(nodeIPStr) )
          {
            isMaster = true;
            println("Config: IP '"+myIP+"' set as master node");
          }
        }
        catch( UnknownHostException e )
        {
          println(e);
        }
      }
      
      if( rawConfig[i].contains("MASTER_NODE_PORT") )
      {
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        masterNodePort = Integer.valueOf( tempStr.trim() );
      }
      if( clusterEnabled && rawConfig[i].contains("NODE") && !rawConfig[i].contains("MASTER") ){
        // Parse string
        String nodeIDStr = rawConfig[i].substring( rawConfig[i].indexOf(" ")+1, rawConfig[i].indexOf("=") );
        String nodeIPStr = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        
        String nodeXOffsetStr = rawConfig[i].substring( rawConfig[i].lastIndexOf("=")+1, rawConfig[i].indexOf(",") );
        String nodeYOffsetStr = rawConfig[i].substring( rawConfig[i].lastIndexOf(",")+1, rawConfig[i].length() );

        // Remove leading/trailing whitespace
        nodeIDStr = nodeIDStr.trim();
        nodeIPStr = nodeIPStr.trim();

        try
        {
          String myIP = InetAddress.getLocalHost().getHostAddress();
          //println("Config: My IP '"+myIP+"'");
          if( myIP.contains(nodeIPStr) )
          {
            int xOffset = Integer.valueOf( nodeXOffsetStr.trim() );
            int yOffset = Integer.valueOf( nodeYOffsetStr.trim() );
            println("Config: Configuring '"+nodeIPStr+"' as node '"+nodeIDStr+"'");
            clusterSetByConfig = true;
            cluster_xOffset = xOffset;
            cluster_yOffset = yOffset;
          }
          //nodeIDLookup.put( nodeIPStr, nodeIDStr+","+nodeXOffsetStr+","+nodeYOffsetStr);
          //println("Config: Node ID '"+nodeIDStr+"' IP '"+nodeIPStr+"'");
          //continue;
        }
        catch( UnknownHostException e )
        {
          println(e);
        }
        continue;
      }

      /*
      if( rawConfig[i].contains("MASTER_NODE_IP") ){
        masterNodeIP = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        cluster = true;
        println("Clustering enabled");
        continue;
      }
      if( rawConfig[i].contains("MASTER_NODE_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        masterNodePort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("NODE_ID") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        thisNodeID = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("N_NODES") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        nNodes = Integer.valueOf( tempStr.trim() );
        continue;
      }
      */
      if( rawConfig[i].contains("IPAD_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        iPadPort = Integer.valueOf( tempStr.trim() );
        connectToiPad = true;
        continue;
      }
      if( rawConfig[i].contains("WIDTH") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        appWidth = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("HEIGHT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        appHeight = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("X_OFFSET") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        X_OFFSET = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("Y_OFFSET") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        Y_OFFSET = Integer.valueOf( tempStr.trim() );
        continue;
      }
      
      if( rawConfig[i].contains("AUTO_SET_JAVA_FRAME") && rawConfig[i].contains("true") ){
        setJavaFrameEnabled = true;
        continue;
      }
      if( rawConfig[i].contains("TOUCH_Y_OFFSET") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        TOUCH_Y_OFFSET = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("TOUCH_X_OFFSET") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        TOUCH_Y_OFFSET = Integer.valueOf( tempStr.trim() );
        continue;
      }
    }// for
  }
}// readConfigFile
