import java.util.HashMap;
import java.util.Map;
Map<String, Integer> truckProps = new HashMap<>(); 

int truckWidth = 100;    // Width of the truck
int truckHeight = 50;    // Height of the truck
int truckCapacity = 2000; 
int cabinWidth = 40;     // Width of the cabin
int cabinHeight = 20;    // Height of the cabin
int wheelDiameter = 20;  // Diameter of the wheels

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
 
    // Initialize position and velocity of the truck
    truckProps.put("x", roadWidth); 
    truckProps.put("y", height - truckHeight); 
    truckProps.put("velX", 5); 
    truckProps.put("velY", 0); 
    truckProps.put("load", 0); 
    
    
    // Set background color
    background(cropsColor);
    // Create the road
    fill(grayColor); 
    rect(0, 0, roadWidth, height); 
    
}



void paintBeforeMove() {
  
  // Paint the truck
  fill(brownColor); 
  rect(truckProps.get("x"), truckProps.get("y"), truckWidth, truckHeight);
  
  // Paint the wheels
  ellipse(truckProps.get("x") + wheelDiameter,truckProps.get("y") + truckHeight, wheelDiameter, wheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - wheelDiameter, truckProps.get("y") + truckHeight, wheelDiameter, wheelDiameter);
  
  fill(cropsColor); 
  
  // Paint the cabin
  if(truckProps.get("velX") > 0) {
      rect(truckProps.get("x") + truckWidth - cabinWidth, truckProps.get("y") - cabinHeight, cabinWidth, cabinHeight);
    } else {
      rect(truckProps.get("x"), truckProps.get("y") - cabinHeight, cabinWidth, cabinHeight);
    }
  
  
}

void move() {
  
  
  int newXPos = truckProps.get("x") + truckProps.get("velX"); 
  int newYPos = truckProps.get("y") + truckProps.get("velY"); 
  
  truckProps.put("x", newXPos); 
  truckProps.put("y", newYPos); 
  
}

boolean verifyMove() {
  if(truckProps.get("load") >= truckCapacity) {
    truckProps.put("velY", 0); 
    truckProps.put("velX", 0); 
    return true; 
  }
  
  
  if(truckProps.get("velY") != 0) {
    truckProps.put("velY", 0); 
  }
  
  int futureXPos =  truckProps.get("x") + truckProps.get("velX"); 
  int futureYPos = truckProps.get("y") - truckHeight; 
  int velX = truckProps.get("velX"); 
  
  if(futureXPos + truckWidth >= width || futureXPos <= roadWidth) {
    // If it has finished
    println(futureYPos); 
    if(futureYPos < 0) {
      return true; 
    }
    
    // For completing the trace before the row change
    fill(brownColor); 
    rect(truckProps.get("x") + truckProps.get("velX"), truckProps.get("y"), truckWidth, truckHeight);
    // For completing the trace after the row change
    rect(truckProps.get("x") + truckProps.get("velX"), truckProps.get("y") - truckHeight, truckWidth, truckHeight);
    
    // Change direction
    truckProps.put("velX", -velX); 
    truckProps.put("velY", -truckHeight);
  }
  
  return false; 
  
}

void paintAfterMove() {
    // Draw truck body
    fill(whiteColor); 
    rect(truckProps.get("x"), truckProps.get("y"), truckWidth, truckHeight);
    
    // Draw cabin
    fill(blueColor); 
    if(truckProps.get("velX") > 0) {
      rect(truckProps.get("x") + truckWidth - cabinWidth, truckProps.get("y") - cabinHeight, cabinWidth, cabinHeight);
    } else {
      rect(truckProps.get("x"), truckProps.get("y") - cabinHeight, cabinWidth, cabinHeight);
    }
    
    
  
}

void recolectOnMove() {
  // Update the data 
  int actualLoad = truckProps.get("load"); 
  truckProps.put("load", actualLoad + Math.abs(1 * truckProps.get("velX"))); 
  
  //Draw the capacity
  float loadWidthPercentage =(float) truckProps.get("load") / truckCapacity; 
  float loadWidthFloat = truckWidth * loadWidthPercentage; 
  int loadWidth = (int) loadWidthFloat;  

   println(truckProps.get("load") / truckCapacity); 
 
  // Draw load 
  fill(purpleColor); 
  if(truckProps.get("velX") > 0) {
    rect(truckProps.get("x"), truckProps.get("y"), loadWidth, truckHeight);
  } else {
    rect(truckProps.get("x") + truckWidth - loadWidth, truckProps.get("y"), loadWidth, truckHeight);
  }
  
  // Draw wheels 
  // They are drawn here so that they are in front of the load counter.
    fill(blackColor); // Black color
    ellipse(truckProps.get("x") + wheelDiameter, truckProps.get("y") + truckHeight, wheelDiameter, wheelDiameter);
    ellipse(truckProps.get("x") + truckWidth - wheelDiameter, truckProps.get("y") + truckHeight, wheelDiameter, wheelDiameter);
  
  
  
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
