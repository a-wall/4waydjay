/*
PlayBall is the circular marker that is moved around on the screen.
This class is responsible for being moved and drawing the ball.
*/

class PlayBall
{
  int maxRadius, markerRadius;
  int minX, minY, maxX, maxY;
  PVector pos;
  color markerColor, baseColor;
  
  PlayBall(int maxRadius, int minX, int minY, int maxX, int maxY)
  {
    pos = new PVector(0,0);
    this.maxRadius = maxRadius;
    this.minX = minX;
    this.minY = minY;
    this.maxX = maxX;
    this.maxY = maxY;
    setRadius(maxRadius * 0.6);
    setColor(color(204, 153, 0));
  }
  
  void move(int x, int y)
  {
    // stay inside the bounds
    pos.set(min(maxX,max(minX,x)), min(maxY,max(minY,y)));
    //println("ball position changed to " + pos.x + " " + pos.y + " min/max " + minX + " " + maxX + " : " + minY + " " + maxY);
  }
  
  void setRadius(int r)
  {
    markerRadius = min(maxRadius, r);
    
  }
  
  void setColor(color c)
  {
    markerColor = c;
    baseColor = color(red(markerColor),green(markerColor),blue(markerColor), alpha(markerColor) * 0.60);
  }
  
  PVector getPosition(){
    return pos; 
  }
  
  // determines for a given x,y if that position is within the radius of the circle
  Boolean isOver(int x, int y)
  {
    return (dist(pos.x, pos.y, x, y) <= maxRadius);
  }
  
  void draw()
  {
    pushMatrix(); 
    translate(pos.x, pos.y);
    ellipseMode(RADIUS);
    noStroke();
    fill(markerColor);
    ellipse(0,0,markerRadius,markerRadius); 
    fill(baseColor);
    ellipse(0,0,maxRadius,maxRadius); 
    popMatrix();
  }
  
}
