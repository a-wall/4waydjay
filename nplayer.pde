/*
NPlayer simplifies controlling multiple tracks simultaneously.
The "matchLoopLengths" function is lazily called on the first play to match the loop 
lengths across the individual tracks.
*/

class NPlayer
{
  Maxim maxim;
  AudioPlayer[] players;
  boolean playing = false;
  boolean loopLengthMatched = false;
  double power = 0.5, powerStep = 0.05;
  
  NPlayer(String[] trackFiles)
  {
    int n = trackFiles.length;
    maxim = new Maxim(this);
    players = new AudioPlayer[n];
    double vol = 1/n;
    
    for (int i = 0; i < n; i++) {
      //println("loading track " + trackFiles[i]);
      players[i] = maxim.loadFile(trackFiles[i]);
      players[i].setLooping(true);
      players[i].volume(vol);
      //println("audioplayer created for track " + trackFiles[i] 
      //  + " and setting volume to " + vol);
      //players[i].setAnalysing(true);
    }
    //println(n + " tracks loaded");
  }
  
  Boolean isPlaying(){
    return playing;
  }
  
  // sets the speed on each track so that the loops all match the average loop length
  void matchLoopLengths()
  {
    float totalLength = 0;
    // determine the maximum loop length
    for (int i = 0; i < players.length; i++) {
      //println("track " + i + " is length " + players[i].getLengthMs() + "ms)");
      totalLength = totalLength + players[i].getLengthMs();
    }
    // match the loop length
    var avgLength = totalLength / players.length;
    for (int i = 0; i < players.length; i++) {
      float matchingSpeed = avgLength/players[i].getLengthMs();
      //println("setting speed of track " + i + " to a rate of " + matchingSpeed);
      players[i].speed(matchingSpeed);
    }
  }
  
  void play()
  {
    if (!loopLengthMatched) { matchLoopLengths(); loopLengthMatched = true;}
    for (int i = 0; i < players.length; i++) {
      players[i].cue(0);
      players[i].play();
      //println("avg power of track " + i + " is: " + players[i].getAveragePower());
      //println("length of track " + i + " is: " + players[i].getLengthMs());
    }
    playing = true;
  }
  
  void stop()
  {
    for (int i = 0; i < players.length; i++) {
      players[i].stop();
    }
    playing = false;
  }
  
  void volume(double[] levels, double limit)
  {
    for (int i = 0; i < levels.length; i++) {
      //println("setting track " + i + " volume to: " + levels[i]);
      players[i].volume(min(limit,levels[i]));
    }
  }
  
  // the average power *should* us the webkit analyser but this will require
  // fixes in maxim.js to get work. in the meantime a simple randomwalk is used.
  float getAveragePower(){
    /*
    float power = 0.0;
    for (int i = 0; i < players.length; i++) {
      float[] spectrum = playersowerSpectrum();
      float onepower = 0.0;
      for (int j = 0; j < spectrum.length; j++){
        onepower = onepower + spectrum[j];
      }
      power = power + onepower / spectrum.length;
    } 
    return (power / players.length);
    */
    power = power + random(2 * powerStep) - powerStep;
    power = max(0, min(1,power));
    return power;
  }
}
