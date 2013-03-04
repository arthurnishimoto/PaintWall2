private FileWriter fstream;
private BufferedWriter out;

void prepareFile() {
  try {
    fstream = new FileWriter(sketchPath("tempTouches.txt"));
    out = new BufferedWriter(fstream);
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());}
}

void writeToFile(String newString) {
  try {
    out.write(newString+"\n");
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());}
}

void finishFile() {
  try {
    out.close();
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());}
}

void recreate() {
  /*
  clearScreen();
  FileReader infstream;
  BufferedReader in;
  try {
    infstream = new FileReader(sketchPath("tempTouches.txt"));
    in = new BufferedReader(infstream);
  
    while(true) {
      String inFromFile = in.readLine();
      if(inFromFile == null) {
        break;
      }
      else {
        StringTokenizer dataIn = new StringTokenizer(inFromFile);
        ArrayList<Integer> theData = new ArrayList<Integer>();
        
        while(dataIn.hasMoreTokens()) {
          theData.add(parseInt(dataIn.nextToken()));
        }
        if(theData.get(1) == 1) {
          
        }
        else {
          
        }
      }
      
    }
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());} 
  */
}

void recreateTouches(String NEW_TOUCH_MODE, int xCoordinate, int yCoordinate, int theXWidth, int theYWidth, int newPaintColors[])
{
  if(TOUCH_MODE == ELLIPSE) {
    for (int a = 1; a <= 40; a++) {
      fill( newPaintColors[0], newPaintColors[1], newPaintColors[2], newPaintColors[3]*(1-(0.025*a)));
      stroke( newPaintColors[0], newPaintColors[1], newPaintColors[2], 0);
      ellipse( xCoordinate, yCoordinate, theXWidth+(a*1), theYWidth+(a*1));
    }
    
    //Actual touch
    fill( newPaintColors[0], newPaintColors[1], newPaintColors[2], newPaintColors[3]);
    stroke( newPaintColors[0], newPaintColors[1], newPaintColors[2], 0);
    ellipse( xCoordinate, yCoordinate, theXWidth, theYWidth);
  }
  else if(TOUCH_MODE == SPHERE)
  {
    lights();
    fill( newPaintColors[0], newPaintColors[1], newPaintColors[2], newPaintColors[3]);
    stroke( newPaintColors[0], newPaintColors[1], newPaintColors[2], 0);
    translate(xCoordinate, yCoordinate);
    sphere(theXWidth);
  } 
}

void recreateTouches(int xCoordinate, int yCoordinate, int prevXCoord, int prevYCoord) {
    stroke(0);
    line(xCoordinate, yCoordinate, prevXCoord, prevYCoord);
}
