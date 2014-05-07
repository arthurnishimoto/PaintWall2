void keyPressed() {
  int frameX = frame.getX();
  int frameY = frame.getY();
  
  if( keyCode == UP ){
    frameY--;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  if( keyCode == DOWN ){
    frameY++;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  if( keyCode == LEFT ){
    frameX--;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  if( keyCode == RIGHT ){
    frameX++;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  
  if(key == 'q' || key == 'Q') {
    quitApplication();
  }
  else if(key == 'c' || key == 'C') {
    clearScreen();
  }
  else if(key == 's' || key == 'S') {
    saveImage();
    if( clusterEnabled && isMaster )
      clusterServer.sendTCPString("SAVE_IMAGE");
  }
  else if(key == 'm' || key == 'M') {
    if(TOUCH_MODE == SPHERE ) {
      TOUCH_MODE = ELLIPSE;
    }
    else {
      TOUCH_MODE = SPHERE;
    }
  }
}

void clearScreen() {
   background(backgroundColor);
}

void saveImage() {
  saveFrame("data/Images/screenshot-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-"+millis()+".tif");
}

void quitApplication() {
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
  exit();
}
