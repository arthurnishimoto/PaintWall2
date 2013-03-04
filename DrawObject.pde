class DrawObject {

  private int theX;
  private int theY;
  private int theXwidth;
  private int theYwidth;
  
  private int prevXCoordinate;
  private int prevYCoordinate;
  
  private int redValue;
  private int greenValue;
  private int blueValue;
  private int alphaValue;
  private int tool;
  private int drawMode;
  
  public DrawObject(int toolNum, int x, int y, int prevxcoordinate, int prevycoordinate) {
    this.tool = toolNum;
    this.theX = x;
    this.theY = y;
    this.prevXCoordinate = prevxcoordinate;
    this.prevYCoordinate = prevycoordinate;
  }
  public DrawObject(int x, int y, int xWidth, int yWidth, int redColor, int greenColor, int blueColor, int alphaVal, int toolNum, int drawType) {
    this.tool = toolNum;
    this.theX = x;
    this.theY = y;
    this.theXwidth = xWidth;
    this.theYwidth = yWidth;
    this.redValue = redColor;
    this.greenValue = greenColor;
    this.blueValue = blueColor;
    this.alphaValue = alphaVal;
    if(drawType == ELLIPSE) {
      this.drawMode = 1;
    }
    else {
      this.drawMode = 2;
    }
  }
  
  public String toString() {
    if(this.tool == 1) {
      return(this.tool+"#"+this.theX+"#"+this.theY+"#"+this.theXwidth+"#"+this.theYwidth+"#"+this.redValue+"#"+this.greenValue+"#"+this.blueValue+"#"+this.alphaValue+"#"+this.drawMode);
    }
    else {
      return(this.tool+"#"+this.theX+"#"+this.theY+"#"+this.prevXCoordinate+"#"+this.prevYCoordinate+"#0#0#0#0#0");
    }
  
  }
}
