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
boolean truckArrivedY; 
boolean enganchado; 
boolean terminarEnganche = false; 
int drainRatio = 2; 

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
    harvesterProps.put("direction", 1); 
    
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
    if(futureYPos < 0) {
      return true; 
    }
    
    // For completing the trace before the row change
    fill(brownColor); 
    rect(harvesterProps.get("x") + harvesterProps.get("velX"), harvesterProps.get("y"), harvesterWidth, harvesterHeight);
    // For completing the trace after the row change
    rect(harvesterProps.get("x") + harvesterProps.get("velX"), harvesterProps.get("y") - harvesterHeight, harvesterWidth, harvesterHeight);
    
    // Change direction
    if(harvesterProps.get("direction") == 1) {
      harvesterProps.put("direction", 0);
    } else {
    harvesterProps.put("direction", 1);
  }
     
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
  
  
  if(!enganchado) {
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



void paintTruckAfterMove() {
  fill(blackColor); 
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);

  fill(whiteColor); 
  rect(truckProps.get("x"), truckProps.get("y"), truckWidth, truckHeight, 5); 
}

void paintTruckBeforeMove() {
  //Paint the wheels
  fill(brownColor); 
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y") + truckHeight, truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  ellipse(truckProps.get("x") + truckWidth - truckWheelDiameter, truckProps.get("y"), truckWheelDiameter, truckWheelDiameter);
  
  // Paint the body
  rect(truckProps.get("x"), truckProps.get("y"), truckWidth, truckHeight, 5); 
}



void moveTruck() {
  int newXPos = truckProps.get("x") + truckProps.get("velX");
  int newYPos = truckProps.get("y") + truckProps.get("velY");
  
  truckProps.put("x", newXPos); 
  truckProps.put("y", newYPos);  
}



void verificarLlegadaY(){
  if(truckProps.get("y") <= truckProps.get("yRoute")){
    truckProps.put("velY", 0); 
  } else {
    truckProps.put("velY", -2); 
  }
}

void verificarLlegadaX(){
  int y = truckProps.get("y"); 
  int yRoute = truckProps.get("yRoute"); 
  
  
  if(y >= yRoute + 2) {
    return; 
  }
 
  if(truckProps.get("xRoute") != 0) {
    if(truckProps.get("x") <= truckProps.get("xRoute")) {
      truckProps.put("velX", 4); 
    } else {
      truckProps.put("velX", 0); 
      enganchado = true; 
      terminarEnganche = false; 
    }
  } else {
    truckProps.put("xRoute", harvesterProps.get("x")); 
  }
}




void followHarvester() {
  if(harvesterProps.get("load") == 0 || truckProps.get("load") == truckCapacity) {
    truckProps.put("load", 0); // ;KLDAJSFKL;AJS;LKFAJL;KFJAL;KFDJA;LK FDJA;LF JAS;LKFJDSA;LKFJDAS;LK JFDS;ALK FSDA K;FSAD;JFK;DLASJF;KLASDJ F;LKAJS FLK;AJDS ;LFKDJLAK;SJFKL;ASDJFLK;SDAJLK;FSDJAL;KFJDASKL;JFDAS;LK
    enganchado = false; 
    terminarEnganche = true; 
    return; 
  } 
  
  if(harvesterProps.get("velX") == 0 ) {
    if(harvesterProps.get("direction") == 1) {
      harvesterProps.put("velX", 5); 
    } else {
      harvesterProps.put("velX", -5); 
    }
    
  }
  int actualHarvesterLoad = harvesterProps.get("load"); 
  int actualTruckLoad = truckProps.get("load"); 
  
  harvesterProps.put("load", actualHarvesterLoad - (drainRatio * Math.abs(harvesterProps.get("velX")))); 
  truckProps.put("load", actualTruckLoad + (drainRatio * Math.abs(harvesterProps.get("velX")))); 
  
  
  paintTruckBeforeMove();  
  truckProps.put("x", harvesterProps.get("x")); 
  truckProps.put("y", harvesterProps.get("y") + harvesterHeight + 15); 
  paintTruckAfterMove(); 
  
    //Draw the capacity
    float harvesterLoadWidthPercentage =(float) harvesterProps.get("load") / harvesterCapacity; 
    float truckLoadWidthPercentage = (float) truckProps.get("load") / truckCapacity; 
    float harvesterLoadWidthFloat = harvesterWidth * harvesterLoadWidthPercentage; 
    float truckLoadWidthFloat = truckWidth * truckLoadWidthPercentage; 
    int harvesterLoadWidth = (int) harvesterLoadWidthFloat;  
    int truckLoadWidth = (int) truckLoadWidthFloat;
    
    
  
  
    // Draw load 
    fill(purpleColor); 
    if(harvesterProps.get("velX") > 0) {
      rect(harvesterProps.get("x"), harvesterProps.get("y"), harvesterLoadWidth, harvesterHeight);
      rect(truckProps.get("x"), truckProps.get("y"), truckLoadWidth, truckHeight, 5);
    } else {
      rect(harvesterProps.get("x") + harvesterWidth - harvesterLoadWidth, harvesterProps.get("y"), harvesterLoadWidth, harvesterHeight);
      rect(truckProps.get("x") + truckWidth - truckLoadWidth, truckProps.get("y"), truckLoadWidth, truckHeight, 5);
    }
    
  // Draw wheels 
  // They are drawn here so that they are in front of the load counter.
    fill(blackColor); // Black color
    ellipse(harvesterProps.get("x") + harvesterWheelDiameter, harvesterProps.get("y") + harvesterHeight, harvesterWheelDiameter, harvesterWheelDiameter);
    ellipse(harvesterProps.get("x") + harvesterWidth - harvesterWheelDiameter, harvesterProps.get("y") + harvesterHeight, harvesterWheelDiameter, harvesterWheelDiameter);
}

void transportLoad() {
  int finalX = (roadWidth / 2) - (truckWidth / 2); 
  int finalY = height - truckHeight - 20; 
  if (truckProps.get("x") >= finalX) {
    truckProps.put("velX", -2); 
  } else {
    truckProps.put("velX", 0); 
  }
  if (truckProps.get("y") <= finalY) {
    truckProps.put("velY", 2); 
  } else {
    truckProps.put("velY", 0); 
  }
  
  
  
  if(truckProps.get("x") <= finalX && truckProps.get("y") >= finalY) {
    truckProps.put("velX", 0); 
    truckProps.put("velY", 0);
    terminarEnganche = false; 
    
    
  }

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
    
    calculateHarvesterFinalPosition();   
  } 
  
  println(enganchado, terminarEnganche); 
  if(!enganchado && !terminarEnganche) {
    
    verificarLlegadaY(); 
    verificarLlegadaX();
    paintTruckBeforeMove(); 
    moveTruck(); 
    paintTruckAfterMove(); 
  } else {
  if(!terminarEnganche) {
    followHarvester(); 
  } else {
    transportLoad(); 
    paintTruckBeforeMove(); 
    moveTruck(); 
    paintTruckAfterMove(); 
  }
  }
    
 
  

  
}
