int paintColor = 255;
int paintColors[] = new int[4];
int tool;
int prevxCoordinate, prevyCoordinate, prevtheXWidth, prevtheYWidth;

boolean newBackground = false;
PImage newBackgroundImage = null;
DrawObject newObject;

Hashtable prevTouches = new Hashtable();

/**************************************************
 * Description needed
 */
void drawStuff() {
  if(enableTracker) {
    /* // Replaced with OmicronAPI TouchListener
    ArrayList newUp = touchTracker.getTouchesUp();         
    ArrayList newDown = touchTracker.getTouchesDown();
    ArrayList newMove = touchTracker.getMovedTouches();
    if( !newDown.isEmpty()) {
      for(int i = 0; i < newDown.size(); i++) {
        Touches curTouch = ((Touches) newDown.get(i));          
        sendTouch(curTouch);
      }
    }// if down
    if( !newMove.isEmpty()) {
      for(int i = 0; i < newMove.size(); i++) {
        Touches curTouch = ((Touches) newMove.get(i));  
        sendTouch(curTouch);
      }
    }// if move
    if( !newUp.isEmpty()) {
      for(int i = 0; i < newUp.size(); i++) {
        Touches curTouch = ((Touches) newUp.get(i));
        sendTouch(curTouch);
      }
    }// if up
    */
  }
  else {
      if(mousePressed) {    
        drawTouches(0, 0, mouseX, mouseY,  10, 10);
      }
  }
}
/*
void sendTouch(Touches curTouch)
{
 
  int xPos;
  int yPos;
  int xWidth;
  int yWidth;
  
  float nodeXPos = curTouch.getXPos();
  float nodeXWidth = curTouch.getXWidth();
  
  if( !cluster ){
    xPos = (int)(curTouch.getXPos() * appWidth)+ TOUCH_X_OFFSET;
    yPos = (int)(appHeight - curTouch.getYPos() * appHeight)+ TOUCH_Y_OFFSET;
    xWidth = (int)(curTouch.getXWidth() * appWidth);
    yWidth = (int)(curTouch.getYWidth() * appHeight);
  } else {
    if( thisNodeID == 1 ){
      nodeXPos = nodeXPos * nNodes;
    } else if( thisNodeID == nNodes ){
      nodeXPos = (nodeXPos * nNodes) - ( (float)thisNodeID / (float)nNodes );
    }
    nodeXWidth = nodeXWidth * nNodes;
    
    xPos = (int)( nodeXPos * appWidth) + TOUCH_X_OFFSET;
    yPos = (int)(appHeight - curTouch.getYPos() * appHeight) + TOUCH_Y_OFFSET;
    xWidth = (int)(nodeXWidth * appWidth);
    yWidth = (int)(curTouch.getYWidth() * appHeight);
  }
  
  drawTouches((int)curTouch.getGesture(), (int)curTouch.getFinger(), xPos, yPos, xWidth, yWidth);
}
*/

/**************************************************
 * Description needed
 */
void drawTouches(int gesture, int id, int xCoordinate, int yCoordinate, int theXWidth, int theYWidth)
{
  //println("DrawTouches " + gesture + " " + id + " " +xCoordinate + " " + yCoordinate + " " + theXWidth + " " + theYWidth );
  // Used to draw touches while waiting for ipad to connect
  if(!connectionEstablished && showWaiting ){
    color col = getColor( id );
    theXWidth += 5;
    theYWidth += 5;
    for (int a = 40; a >= 1; a--) {
      fill( col, 255*(0.025*a));
      stroke( col, 0);
      ellipse( xCoordinate, yCoordinate, theXWidth*(1-(a/40.0)), theYWidth*(1-(a/40.0)));
    }
  } 
  else{
    if(tool == 1) {
      newObject = new DrawObject(tool, xCoordinate, yCoordinate, theXWidth, theYWidth, paintColors[0], paintColors[1], paintColors[2], paintColors[3], TOUCH_MODE);
      if(TOUCH_MODE == ELLIPSE) {
        theXWidth += 5;
        theYWidth += 5;
        for (int a = 40; a >= 1; a--) {
          fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]*(0.025*a));
          stroke( paintColors[0], paintColors[1], paintColors[2], 0);
          ellipse( xCoordinate, yCoordinate, theXWidth*(1-(a/40.0)), theYWidth*(1-(a/40.0)));
        }
      }
      else if(TOUCH_MODE == SPHERE)
      {
        lights();
        fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
        stroke( paintColors[0], paintColors[1], paintColors[2], 0);
        translate(xCoordinate, yCoordinate);
        sphere(theXWidth);
      }
    }
    else if(tool == 2) {
      newObject = new DrawObject(tool, xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
      stroke( paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
      strokeWeight(5);
      if( gesture == 0 ){ // down
        //if( sqrt( sq(abs( xCoordinate - prevxCoordinate )) + sq(abs( yCoordinate - prevyCoordinate )) ) < 100 )
        //line(xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
        int[] prev = {xCoordinate, yCoordinate};
        prevTouches.put( id, prev );
      } 
      else if( gesture == 1 ){ // move
        if( prevTouches.containsKey( id ) ){
          int[] prev = (int[])prevTouches.get(id);
          prevxCoordinate = prev[0];
          prevyCoordinate = prev[1];
          line(xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
          prev[0] = xCoordinate;
          prev[1] = yCoordinate;
          prevTouches.put( id, prev );
        }
      }
      else if( gesture == 2 ) { // up
        prevTouches.remove( id );
      }
    }
    prevxCoordinate = xCoordinate;
    prevyCoordinate = yCoordinate;
    prevtheXWidth = theXWidth;
    prevtheYWidth = theYWidth;
    if (saveTouches) {
      writeToFile(newObject.toString());
    }
    strokeWeight(1);
  }
}


color getColor(int finger){
  int colorNum = finger % 20;
color shapeColor = #000000;
  switch (colorNum){
  case 0: 
    shapeColor = #D2691E; break;  //chocolate
  case 1: 
    shapeColor = #FC0FC0; break;  //Shocking pink
  case 2:
    shapeColor = #014421; break;  //Forest green (traditional)
  case 3: 
    shapeColor = #FF4500; break;  //Orange Red
  case 4: 
    shapeColor = #2E8B57; break;  //Sea Green        
  case 5: 
    shapeColor = #B8860B; break;  //Dark Golden Rod
  case 6: 
    shapeColor = #696969; break;  //Dim Gray
  case 7: 
    shapeColor = #7CFC00; break;  //Lawngreen
  case 8: 
    shapeColor = #4B0082; break;  //Indigo
  case 9: 
    shapeColor = #6B8E23; break;  //Olive Drab
  case 10: 
    shapeColor = #5D8AA8; break;  //Air Force Blue
  case 11: 
    shapeColor = #F8F8FF; break;  //Ghost White
  case 12: 
    shapeColor = #0000FF; break;  //Ao
  case 13: 
    shapeColor = #00FFFF; break;  //Aqua
  case 14: 
    shapeColor = #7B1113; break;  //UP Maroon
  case 15: 
    shapeColor = #6D351A; break;  //Auburn
  case 16: 
    shapeColor = #FDEE00; break;  //Aureolin
  case 17: 
    shapeColor = #FF0000; break;  //Red
  case 18:
    shapeColor = #0F4D92; break; //Yale Blue
  case 19:
    shapeColor = #C5B358; break; //Vegas gold
  }

  return shapeColor;
}
