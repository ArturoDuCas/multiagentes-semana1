import java.util.HashMap;
import java.util.Map;
Map<String, Integer> harvesterProps = new HashMap<>(); 
Map<String, Integer> truckProps = new HashMap<>(); 

int harvesterWidth = 100;    // Width of the harvester
int harvesterHeight = 50;    // Height of the harvester
int harvesterCapacity = 2000; 
int harvesterCabinWidth = 40;     // Width of the cabin
int harvesterCabinHeight = 20;    // Height of the cabin
int harvesterWheelDiameter = 20;  // Diameter of the wheels

int truckWidth = 50; 
int truckHeight = truckWidth; 
int truckCapacity = 4000; 
int truckWheelDiameter = 10;

boolean moveTruck = false; 

int grainsPerPixel = 1; 


int roadWidth = 100; 
color cropsColor = color(255, 128, 0);
color brownColor = color(139, 69, 19); 
color blackColor = color(0, 0, 0); 
color whiteColor = color(255,255,255); 
color blueColor = color(100, 149, 237); 
color purpleColor = color(97, 75, 195); 
color grayColor = color(158,159,165); 
color yellowColor = color(248,222,34); 

boolean harvesterMustStop; 

int i = 0; 

void setup() {
    size(800, 600);
    noStroke(); // Disable the border of the figures 
 
    // Initialize position and velocity of the harvester
    harvesterProps.put("x", roadWidth); 
    harvesterProps.put("y", height - harvesterHeight); 
    harvesterProps.put("velX", 5); 
    harvesterProps.put("velY", 0); 
    harvesterProps.put("load", 0); 
    harvesterProps.put("finalY", 0); 
    
    // Initialize position and velocity of the truck
    truckProps.put("x", (roadWidth / 2) - (truckWidth / 2));
    truckProps.put("y", height - truckHeight - 20); 
    truckProps.put("velX", 0); 
    truckProps.put("velY", 0); 
    truckProps.put("load", 0); 
    truckProps.put("xRoute", 0);
    truckProps.put("yRoute", 0); 
    
    
    
    // Set background color
    background(cropsColor);
    
}



void paintHarvesterBeforeMove() {
  
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

void moveHarvester() {
  int newXPos = harvesterProps.get("x") + harvesterProps.get("velX"); 
  int newYPos = harvesterProps.get("y") + harvesterProps.get("velY"); 
  
  harvesterProps.put("x", newXPos); 
  harvesterProps.put("y", newYPos); 
  
}

boolean verifyHarvesterMove() {
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

void paintHarvesterAfterMove() {
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

void harvestOnMove() {
  // Update the data 
  int actualLoad = harvesterProps.get("load"); 
  harvesterProps.put("load", actualLoad + Math.abs(grainsPerPixel * harvesterProps.get("velX"))); 
  
  //Draw the capacity
  float loadWidthPercentage =(float) harvesterProps.get("load") / harvesterCapacity; 
  float loadWidthFloat = harvesterWidth * loadWidthPercentage; 
  int loadWidth = (int) loadWidthFloat;  

 
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

void paintTruck() {
 
  //Paint the wheels
  fill(blackColor); 
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  
  // Paint the body
  fill(whiteColor); 
  rect(truckProps.get("x"), truckProps.get("y"), truckWidth, truckHeight, 5); 
  
  
}

void paintRoad() {
  // Paint the ground
  fill(grayColor); 
  rect(0, 0, roadWidth, height); 
}


void calculateHarvesterFinalPosition() {
  int capacityLeft = harvesterCapacity -  harvesterProps.get("load");
  
  // number of renderings required for the harvester to fill up
  int totalRendersLeft = capacityLeft / (grainsPerPixel * abs(harvesterProps.get("velX"))); 
  
  // number of renderings the harvester takes in one row  
  int rendersOnALine = (width - roadWidth - harvesterWidth) / abs(harvesterProps.get("velX")); 
  
  int rendersLeftOnTheLine = 0; 
  boolean toTheLeft = true; 
  if(harvesterProps.get("velX") > 0) { // moving to the right
    rendersLeftOnTheLine = rendersOnALine - (harvesterProps.get("x") - roadWidth) / harvesterProps.get("velX"); 
    toTheLeft = false; 
  } else { // moving to the left 
    rendersLeftOnTheLine = rendersOnALine - abs((width - roadWidth - harvesterProps.get("x")) / harvesterProps.get("velX")); 
  }

  int rowsLeft = 0; 
  int finalX = 0; 
  if(totalRendersLeft > rendersLeftOnTheLine) {
    int rendersLeftWhenFinishingTheLine = totalRendersLeft - rendersLeftOnTheLine; 
    rowsLeft = rendersLeftWhenFinishingTheLine / rendersOnALine + 1;  
  } else { 
    if(toTheLeft) { 
      finalX = harvesterProps.get("x") - (totalRendersLeft * abs(harvesterProps.get("velX"))); 
    }
  }
  
  int actualRow = (height - harvesterProps.get("y")) / harvesterHeight; 
  int finalY = height - ((actualRow + rowsLeft - 1) * harvesterHeight); 
   
  
  fill(whiteColor); 
  rect(finalX, finalY, 10, 10); 
  
  harvesterProps.put("finalY", finalY + harvesterHeight); 
  truckProps.put("xRoute", finalX);
  truckProps.put("yRoute", finalY );   
  
}

void paintTruckBeforeMove(){
  
  println("Entro paint bofore move"); 
  
  fill(blackColor);
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  
    
  // Paint the body
  fill(whiteColor); 
  rect(truckProps.get("x"), truckProps.get("y"), truckWidth, truckHeight, 5); 
  

}


void moveTruckFunction(){
  
  println("Entra a funcion moveTrunkfunction");
  truckProps.put("velY", -1);

  int newXPos = truckProps.get("x") + truckProps.get("velX");
  int newYPos = truckProps.get("y") + truckProps.get("velY");
  
  truckProps.put("x", newXPos); 
  truckProps.put("y", newYPos); 
  
}

void draw() {
  // Paint the road on every Iteration
  paintRoad(); 
  
  
  harvesterMustStop = verifyHarvesterMove(); 
  
  if (!harvesterMustStop) {
    paintHarvesterBeforeMove();
    moveHarvester(); 
    paintHarvesterAfterMove(); 
    
    harvestOnMove();
    
    i = i + 1; 
    calculateHarvesterFinalPosition(); 
    
    if( truckProps.get("y") == harvesterProps.get("finalY")){
      truckProps.put("velY", 0);
      
    }else{
      paintTruck(); 
      moveTruckFunction();
    }
  }
   
}
