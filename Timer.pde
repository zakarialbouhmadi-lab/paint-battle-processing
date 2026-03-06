// --- Timer Class ---
class Timer {
  final PVector position, dimensions;
  float seconds;
  int tmpTime;
  boolean counting = false, finished = false;
  
  Timer(int seconds, float x, float y, float w, float h) {
    this.seconds = seconds;
    this.position = new PVector(x, y);
    this.dimensions = new PVector(w, h);
  }
  
  void render() {
    noFill();
    rect(position.x, position.y, dimensions.x, dimensions.y);
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(dimensions.y * 0.6);
    text(nf(ceil(seconds), 0), position.x + dimensions.x/2, position.y + dimensions.y/2);
  }
  
  void update() {
    if (seconds <= 0) {
      counting = false;
      finished = true;
      return;
    }
      
    if (counting) {
      int currentTime = millis();
      float elapsedTime = (currentTime - tmpTime) / 1000.0;
      seconds = max(0, seconds - elapsedTime);
      tmpTime = currentTime;
    }
  }
  
  void run() {
    this.tmpTime = millis(); 
    this.counting = true;
  }
  
  void pause() {
    if (!this.counting) {
      this.tmpTime = millis();
    }
    this.counting = !this.counting;
  }
  
  boolean isFinished() {
    return seconds <= 0;
  }
}
