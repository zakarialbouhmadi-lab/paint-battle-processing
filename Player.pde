// --- Player Class ---
class Player {
  PVector position, velocity;
  float diameter;
  color colour;
  float rotationSpeed = 0.1; // Reduced for smoother continuous rotation
  float rotationOffset = 0; // For collision-induced rotation
  
  Player(float x, float y, float diameter, float magnitude, color colour) {
    this.position = new PVector(x, y);
    this.diameter = diameter;
    this.colour = colour;
    this.velocity = new PVector(random(-1, 1), random(-1, 1));
    this.velocity.setMag(magnitude);
  }
  
  void update(PGraphics canvas) {
    // Only update position with valid canvas
    if (canvas != null) {
      canvas.beginDraw();
      canvas.noStroke();
      canvas.fill(colour);
      canvas.ellipse(position.x, position.y, diameter, diameter);
      canvas.endDraw();
    }
  }
  
  boolean checkWallCollision(PVector newPosition) {
    // Check if the next position would collide with walls
    if (newPosition.x + diameter/2 >= width || newPosition.x - diameter/2 < 0 || 
        newPosition.y + diameter/2 >= height || newPosition.y - diameter/2 < 0) {
      return true;
    }
    return false;
  }
  
  // Check the player's controls and apply rotation if needed
  void checkControls(char leftKey, char rightKey) {
    // Check regular keys
    if (leftKey < 256 && keysPressed[leftKey]) {
      rotateLeft();
    }
    if (rightKey < 256 && keysPressed[rightKey]) {
      rotateRight();
    }
    
    // Check for arrow keys - each player can have arrow keys assigned
    // Check if LEFT arrow is pressed and assigned to this player
    if (arrowsPressed[0]) {
      if (leftKey == '←') rotateLeft();
      if (rightKey == '←') rotateRight();
    }
    
    // Check if RIGHT arrow is pressed and assigned to this player
    if (arrowsPressed[1]) {
      if (leftKey == '→') rotateLeft();
      if (rightKey == '→') rotateRight();
    }
    
    // Check if UP arrow is pressed and assigned to this player
    if (arrowsPressed[2]) {
      if (leftKey == '↑') rotateLeft();
      if (rightKey == '↑') rotateRight();
    }
    
    // Check if DOWN arrow is pressed and assigned to this player
    if (arrowsPressed[3]) {
      if (leftKey == '↓') rotateLeft();
      if (rightKey == '↓') rotateRight();
    }
    
    // Apply any collision-induced rotation and decay it over time
    if (rotationOffset != 0) {
      velocity.rotate(rotationOffset);
      rotationOffset *= 0.8; // Decay effect
      if (abs(rotationOffset) < 0.01) rotationOffset = 0;
    }
  }
  
  void render() {
    fill(colour);
    ellipse(position.x, position.y, diameter, diameter);
    
    // Draw direction indicator
    PVector directionLine = velocity.copy();
    directionLine.setMag(diameter/2);
    PVector lineEnd = PVector.add(directionLine, position);
    line(position.x, position.y, lineEnd.x, lineEnd.y);
  }
  
  void rotateLeft() {
    velocity.rotate(-rotationSpeed);
  }
  
  void rotateRight() {
    velocity.rotate(rotationSpeed);
  }
}
