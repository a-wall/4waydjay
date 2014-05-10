/*
4waydj has three main components:
1. The NPlayer which handles the non-graphical aspect of the audio playback.
2. The PlayBall which is dragged around the bounded part of the screen to control the cross-fades.
3. The 4 Sides that are display where each track has the strongest contribution to the overall mix.

How to get started:
Press anywhere (not over the ball) to play and pause.
Drag the ball around to change the mix.

*/

NPlayer player;
PlayBall ball;
PlayBall dragBall;
Side[] sides;

// global settings for the radius of the marker ball and the thickness of the sides
int BALL_RADIUS = 90;
int SIDE_EDGE = 10;

// background colour
color bgColor = color(251,251,251);

void setup()
{
  frameRate(30);
  size(768, 768);
  // the tracks/loops are hardcoded but making the tracks optional is a future enhancement
  String[] trackFiles = new String[]{"paul revere.mp3", "da da da.mp3", "schematica.mp3", "client eastwood.mp3"};
  
  sides = new Side[4];

  //println("generating colours for " + sides.length + " sides");
  // rather than presetting specific colours generate the colours by interpolating between "from" and "to" colours.
  color fromColor = color(204, 102, 0);
  color toColor = color(0, 102, 153);
  color[] sideColors = new color[sides.length];
  for (int i = 0; i < sideColors.length; i++) {
      if (sideColors.length <= 1)
        sideColors[i] = fromColor;
      else
        sideColors[i]  = lerpColor(fromColor, toColor, i * 1.0 / (sideColors.length - 1));
  }
  //println("creating " + sides.length + " sides for width/height/edge " + width + " " + height + " " + SIDE_EDGE);
  // set up the sides of the mixing area
  sides[0] = new Side(sideColors[0], 0, SIDE_EDGE, SIDE_EDGE, height - 2 * SIDE_EDGE);
  sides[1] = new Side(sideColors[1], SIDE_EDGE, 0, width - 2 * SIDE_EDGE, SIDE_EDGE);
  sides[2] = new Side(sideColors[2], width - SIDE_EDGE, SIDE_EDGE, SIDE_EDGE, height - 2 * SIDE_EDGE);
  sides[3] = new Side(sideColors[3], SIDE_EDGE, height - SIDE_EDGE, width - 2 * SIDE_EDGE, SIDE_EDGE);
  
  //println("creating n-player for " + trackFiles.length + " tracks");
  player = new NPlayer(trackFiles);
  //println("size: " + width + " " + height);
  
  // create the PlayBall and position it towards the centre/top of the screen
  ball = new PlayBall(BALL_RADIUS, SIDE_EDGE, SIDE_EDGE, width - SIDE_EDGE, height - SIDE_EDGE);
  ball.move(width/2, height/4);
  setVolumesAndColorBasedOnBallPosition();
  background(bgColor);
}

void draw()
{
  background(bgColor);
  for (int i = 0; i < sides.length; i++) {
    sides[i].draw();
  }
  
  if (player.isPlaying()){
    float power = player.getAveragePower();
    ball.setRadius(map(power, 0, 1, BALL_RADIUS / 10, BALL_RADIUS));
  }
  ball.draw();
}

// the relative gain in the mix of each track and the colour of
// the ball is calculated using the balls position on the screen and proximity to each of the sides
void setVolumesAndColorBasedOnBallPosition()
{
  PVector p = ball.getPosition();
  double[] vols = new double[sides.length];
  double total = 0.0;
  // calculate the proximity of the ball to each side midpoint
  for (int i = 0; i < sides.length; i++) {
    PVector pt = sides[i].getPoint();
    vols[i] = 1 - min(1, dist(pt.x, pt.y, p.x, p.y)/(height * 0.5));
    total = total + vols[i];
  }
  // normalise each track volume so that the total is 1
  // each vol has a range 0-1
  for (int i = 0; i < vols.length; i++) {
    vols[i] = vols[i]/total;
  }
  // set the volumes for each of the tracks
  // a limit of 0.8 on the vol as this helps with making the mixing feel additive
  player.volume(vols, 0.8);
  
  // determine the colour using the base colour of each side
  // the closer the ball is to a side, the more that side's colour is used in the ball's colour
  double r = 0.0, g = 0.0, b = 0.0;
  for (int i = 0; i < sides.length; i++) {
    var sbc = sides[i].getBaseColor();
    r = r + (red(sbc) * vols[i]);
    g = g + (green(sbc) * vols[i]);
    b = b + (blue(sbc) * vols[i]);
  }
  color nc = color(r, g, b);
  ball.setColor(nc);
}

void mousePressed()
{
  // on the left mouse click (or touching the screen)
  if (mouseButton == LEFT) {
    if (ball.isOver(mouseX, mouseY)) { 
      // start the ball drag
      dragBall = ball; 
    } else {
      // play/pause
      if (player.isPlaying())
      {
        //println("stopping playback");
        player.stop();
      }
      else
      {
        //println("cueing and playing");
        //player.cue(0);
        player.play();
      }
      //println("playing is: " + player.isPlaying());
    }
  }
}


void mouseDragged() 
{
  if (dragBall != null) {
    //println("moving ball to " + mouseX + " " + mouseY);
    dragBall.move(mouseX,mouseY);
    // is the ball is not being dragged too quickly then recalculate the volumes and colour
    if (abs(mouseX - pmouseX) < width/10 && abs(mouseY - pmouseY < height/10)){
      setVolumesAndColorBasedOnBallPosition();
    }
  }
}

void mouseReleased() {
  dragBall = null;
}

