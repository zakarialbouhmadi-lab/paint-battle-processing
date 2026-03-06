// Main game states
enum GameState {
  MENU, PLAYING, GAMEOVER
}

// --- Game variables ---
GameState currentState = GameState.MENU;
MenuScreen menuScreen;
GameScreen gameScreen;
// Key tracking (true when key is pressed)
boolean[] keysPressed = new boolean[256]; // For regular keys
boolean[] arrowsPressed = new boolean[4]; // For arrow keys (LEFT, RIGHT, UP, DOWN)

void setup() {
  size(1200, 800, P2D);
  frameRate(30);
  menuScreen = new MenuScreen();
}

void draw() {
  try {
    background(0);
    
    switch(currentState) {
      case MENU:
        menuScreen.update();
        menuScreen.render();
        break;
      case PLAYING:
        gameScreen.update();
        gameScreen.render();
        break;
      case GAMEOVER:
        gameScreen.render(); // Render game over screen
        break;
    }
  } catch(Exception e) {
    println("Error: " + e);
    e.printStackTrace();
  }
}

void keyPressed() {
  // Handle key assignment in menu
  if (currentState == GameState.MENU && menuScreen.assigningControls) {
    println("Assigning key: " + key + ", keyCode: " + keyCode); // Debug info
    menuScreen.handleKeyAssignment(key);
    return;
  }
  
  // Store keypress state for regular keys
  if (key < 256) keysPressed[key] = true;
  
  // Store arrow key states - special handling for arrow keys
  if (keyCode == LEFT) arrowsPressed[0] = true;
  if (keyCode == RIGHT) arrowsPressed[1] = true;
  if (keyCode == UP) arrowsPressed[2] = true;
  if (keyCode == DOWN) arrowsPressed[3] = true;
  
  // Handle gameplay controls
  if (currentState == GameState.PLAYING) {
    // Handle pause with SPACE
    if (key == ' ') {
      if (gameScreen.paused) {
        gameScreen.resumeGame();
      } else {
        gameScreen.pauseGame();
      }
      return;
    }
  }
  // Return to menu from game over screen
  else if (currentState == GameState.GAMEOVER) {
    if (keyCode == ENTER) {
      currentState = GameState.MENU;
    }
  }
}

// Add keyReleased function to track key up events
void keyReleased() {
  if (key < 256) keysPressed[key] = false;
  
  // Update arrow key states
  if (keyCode == LEFT) arrowsPressed[0] = false;
  if (keyCode == RIGHT) arrowsPressed[1] = false;
  if (keyCode == UP) arrowsPressed[2] = false;
  if (keyCode == DOWN) arrowsPressed[3] = false;
}

void mousePressed() {
  if (currentState == GameState.MENU) {
    // Handle buttons in menu screen
    if (!menuScreen.assigningControls) {
      // Handle change buttons directly
      int controlsY = height/2;
      int controlSpacing = 50;
      
      for (int i = 0; i < menuScreen.numPlayers; i++) {
        float changeX = width/2 + 180;
        float changeY = controlsY + i * controlSpacing;
        float changeW = 80;
        float changeH = 25;
        
        if (mouseX > changeX - changeW/2 && mouseX < changeX + changeW/2 &&
            mouseY > changeY - changeH/2 && mouseY < changeY + changeH/2) {
          println("Change button clicked for Player " + (i+1));
          menuScreen.assigningControls = true;
          menuScreen.currentPlayerAssigning = i;
          menuScreen.assigningLeftKey = true;
          return;
        }
      }
    }
  } else if (currentState == GameState.PLAYING && gameScreen.paused) {
    // Handle pause menu clicks in update method
  }
}
