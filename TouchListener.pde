int internalID = 0;
int GESTURE_DOWN = 0;
int GESTURE_MOVE = 1;
int GESTURE_UP = 2;

class TouchListener implements OmicronTouchListener{
 
  // Called on a touch down event
  // mousePressed events also call this with an ID of -1 and an xWidth and yWidth of 10.
  public void touchDown(int ID, float xPos, float yPos, float xWidth, float yWidth){
    // This is an optional call if you want the function call in the main applet class.
    // 'OmicronExample' should be replaced with the sketch name i.e. ((SketchName)applet).touchDown( ID, xPos, yPos, xWidth, yWidth );
    // Make sure applet is defined as PApplet and that 'applet = this;' is in setup().
    drawTouches( GESTURE_DOWN, ID, (int)xPos, (int)yPos, (int)xWidth, (int)yWidth );
  }// touchDown
  
  // Called on a touch move event
  // mouseDragged events also call this with an ID of -1 and an xWidth and yWidth of 10.
  public void touchMove(int ID, float xPos, float yPos, float xWidth, float yWidth){
    drawTouches( GESTURE_MOVE, ID, (int)xPos, (int)yPos, (int)xWidth, (int)yWidth );
  }// touchMove
  
  // Called on a touch up event
  // mouseReleased events also call this with an ID of -1 and an xWidth and yWidth of 10.
  public void touchUp(int ID, float xPos, float yPos, float xWidth, float yWidth){
    drawTouches( GESTURE_UP, ID, (int)xPos, (int)yPos, (int)xWidth, (int)yWidth );
    internalID++;
  }// touchUp
  
}// TouchListener
