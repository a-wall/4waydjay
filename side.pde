/*
The Side is one edge of the screen. 
It calculates a centre point and draws the side panel and concentric banding.
*/

class Side
{
  color baseColor, ring1Color, ring2Color, ring3Color;
  int posX, posY, rectWidth, rectHeight, maxRadius;
  PVector centrePoint;
  
  Side(color c, int pox, int poy, int pow, int poh){
    //println("creating side with x/y/w/h " + pox + " " + poy + " " + pow + " " + poh);
    this.baseColor = c;
    ring1Color = color(red(baseColor), green(baseColor), blue(baseColor), 40);
    ring2Color = color(red(baseColor), green(baseColor), blue(baseColor), 80);
    ring3Color = color(red(baseColor), green(baseColor), blue(baseColor), 120);
    maxRadius = 0.5 * max(pow, poh);
    //println("maximum radius for side band is " + maxRadius);
    centrePoint = new PVector(pox + pow * 0.5, poy + poh * 0.5);
    posX = pox;
    posY = poy;
    rectWidth = pow;
    rectHeight = poh;
  }
  
  PVector getPoint(){
    return centrePoint;
  }
  
  color getBaseColor() {
   return baseColor; 
  }
  
  void draw(){
    pushMatrix(); 
    //println("x/y " + point.x + " " + point.y);
    translate(centrePoint.x, centrePoint.y);
    ellipseMode(RADIUS);
    noStroke();
    fill(ring1Color);
    ellipse(0,0,maxRadius,maxRadius); 
    fill(ring2Color);
    ellipse(0,0,maxRadius * 0.6,maxRadius * 0.6); 
    fill(ring3Color);
    ellipse(0,0,maxRadius * 0.3,maxRadius * 0.3);
    rectMode(CENTER);
    fill(baseColor); 
    rect(0, 0, rectWidth, rectHeight);  
    popMatrix();
    
  }
}
