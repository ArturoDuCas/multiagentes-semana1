import java.util.HashMap;
import java.util.Map;
Map<String, Integer> harvesterProps = new HashMap<>(); 

int harvesterWidth = 100;    // Width of the harvester
int harvesterHeight = 50;    // Height of the harvester
int harvesterCapacity = 2000; 
int harvesterCabinWidth = 40;     // Width of the cabin
int harvesterCabinHeight = 20;    // Height of the cabin
int harvesterWheelDiameter = 20;  // Diameter of the wheels

int roadWidth = 100; 
color cropsColor = color(255, 128, 0);
color brownColor = color(139, 69, 19); 
color blackColor = color(0, 0, 0); 
color whiteColor = color(255,255,255); 
color blueColor = color(100, 149, 237); 
color purpleColor = color(97, 75, 195); 
color grayColor = color(158,159,165); 
color yellowColor = color(248,222,34); 

boolean needToStop; 



void setup() {
    size(1000, 600);
    noStroke(); // Disable the border of the figures 
 
    // Initialize position and velocity of the harvester
    harvesterProps.put("x", roadWidth); 
    harvesterProps.put("y", height - harvesterHeight); 
    harvesterProps.put("velX", 5); 
    harvesterProps.put("velY", 0); 
    harvesterProps.put("load", 0); 
    
    
    // Set background color
    background(cropsColor);
    // Create the road
    fill(grayColor); 
    rect(0, 0, roadWidth, height); 
    
}



void paintBeforeMove() {
  
  // Paint the harvester
  fill(brownColor); 
  rect(harvesterProps.get("x"), harvesterProps.get("y"), harvesterWidth, harvesterHeight);
  
  // Paint the wheels
  ellipse(harvesterProps.get("x") + harvesterWheelDiameter,harvesterProps.get("y") + harvesterHeight, harvesterWheelDiameter, harvesterWheelDiameter);
  ellipse(harvesterProps.get("x") + harvesterWidth - harvesterWheelDiameter, harvesterProps.get("y") + harvesterHeight, harvesterWheelDiameter, harvesterWheelDiameter);
  
  fill(cropsColor); 
  
  // Paint the cabin
  if(harvesterProps.get("velX") > 0) {
      rect(harvesterProps.get("x") + harvesterWidth - harvesterCabinWidth, harvesterProps.get("y") - harvesterCabinHeight, harvesterCabinWidth, harvesterCabinHeight);
    } else {
      rect(harvesterProps.get("x"), harvesterProps.get("y") - harvesterCabinHeight, harvesterCabinWidth, harvesterCabinHeight);
    }
  
  
}

void move() {
  
  
  int newXPos = harvesterProps.get("x") + harvesterProps.get("velX"); 
  int newYPos = harvesterProps.get("y") + harvesterProps.get("velY"); 
  
  harvesterProps.put("x", newXPos); 
  harvesterProps.put("y", newYPos); 
  
}

boolean verifyMove() {
  if(harvesterProps.get("load") >= harvesterCapacity) {
    harvesterProps.put("velY", 0); 
    harvesterProps.put("velX", 0); 
    return true; 
  }
  
  
  if(harvesterProps.get("velY") != 0) {
    harvesterProps.put("velY", 0); 
  }
  
  int futureXPos =  harvesterProps.get("x") + harvesterProps.get("velX"); 
  int futureYPos = harvesterProps.get("y") - harvesterHeight; 
  int velX = harvesterProps.get("velX"); 
  
  if(futureXPos + harvesterWidth >= width || futureXPos <= roadWidth) {
    // If it has finished
    println(futureYPos); 
    if(futureYPos < 0) {
      return true; 
    }
    
    // For completing the trace before the row change
    fill(brownColor); 
    rect(harvesterProps.get("x") + harvesterProps.get("velX"), harvesterProps.get("y"), harvesterWidth, harvesterHeight);
    // For completing the trace after the row change
    rect(harvesterProps.get("x") + harvesterProps.get("velX"), harvesterProps.get("y") - harvesterHeight, harvesterWidth, harvesterHeight);
    
    // Change direction
    harvesterProps.put("velX", -velX); 
    harvesterProps.put("velY", -harvesterHeight);
  }
  
  return false; 
  
}

void paintAfterMove() {
    // Draw harvester body
    fill(whiteColor); 
    rect(harvesterProps.get("x"), harvesterProps.get("y"), harvesterWidth, harvesterHeight);
    
    // Draw cabin
    fill(blueColor); 
    if(harvesterProps.get("velX") > 0) {
      rect(harvesterProps.get("x") + harvesterWidth - harvesterCabinWidth, harvesterProps.get("y") - harvesterCabinHeight, harvesterCabinWidth, harvesterCabinHeight);
    } else {
      rect(harvesterProps.get("x"), harvesterProps.get("y") - harvesterCabinHeight, harvesterCabinWidth, harvesterCabinHeight);
    }
    
    
  
}

void recolectOnMove() {
  // Update the data 
  int actualLoad = harvesterProps.get("load"); 
  harvesterProps.put("load", actualLoad + Math.abs(1 * harvesterProps.get("velX"))); 
  
  //Draw the capacity
  float loadWidthPercentage =(float) harvesterProps.get("load") / harvesterCapacity; 
  float loadWidthFloat = harvesterWidth * loadWidthPercentage; 
  int loadWidth = (int) loadWidthFloat;  

   println(harvesterProps.get("load") / harvesterCapacity); 
 
  // Draw load 
  fill(purpleColor); 
  if(harvesterProps.get("velX") > 0) {
    rect(harvesterProps.get("x"), harvesterProps.get("y"), loadWidth, harvesterHeight);
  } else {
    rect(harvesterProps.get("x") + harvesterWidth - loadWidth, harvesterProps.get("y"), loadWidth, harvesterHeight);
  }
  
  // Draw wheels 
  // They are drawn here so that they are in front of the load counter.
    fill(blackColor); // Black color
    ellipse(harvesterProps.get("x") + harvesterWheelDiameter, harvesterProps.get("y") + harvesterHeight, harvesterWheelDiameter, harvesterWheelDiameter);
    ellipse(harvesterProps.get("x") + harvesterWidth - harvesterWheelDiameter, harvesterProps.get("y") + harvesterHeight, harvesterWheelDiameter, harvesterWheelDiameter);
  
  
  
}


void draw() {
  needToStop = verifyMove(); 
  
  if (!needToStop) {
    paintBeforeMove();
    move(); 
    paintAfterMove(); 
    
    recolectOnMove();
  } 
  
  
   
}
