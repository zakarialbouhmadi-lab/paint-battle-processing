// --- MenuScreen Class ---
class MenuScreen {
  int numPlayers = 2;
  Button[] playerButtons = new Button[3];
  Button startButton;
  
  // Control selection state
  boolean assigningControls = false;
  int currentPlayerAssigning = 0;
  boolean assigningLeftKey = true;
  char[][] playerControls = new char[4][2]; // [player][0=left, 1=right]
  String errorMessage = ""; // For showing key assignment errors
  int errorMessageTimer = 0; // Timer for showing error message
  
  MenuScreen() {
    // Initialize player count buttons
    playerButtons[0] = new Button(width/2-150, height/2-150, 100, 50, "2 Players");
    playerButtons[1] = new Button(width/2, height/2-150, 100, 50, "3 Players");
    playerButtons[2] = new Button(width/2+150, height/2-150, 100, 50, "4 Players");
    playerButtons[0].selected = true;
    
    // Position start button - Y will be adjusted dynamically
    startButton = new Button(width/2, height-150, 200, 70, "START GAME");
    
    // Default controls
    playerControls[0][0] = 'q'; // Player 1 left
    playerControls[0][1] = 'w'; // Player 1 right
    playerControls[1][0] = 'n'; // Player 2 left
    playerControls[1][1] = 'm'; // Player 2 right
    playerControls[2][0] = '1'; // Player 3 left
    playerControls[2][1] = '2'; // Player 3 right 
    playerControls[3][0] = '7'; // Player 4 left
    playerControls[3][1] = '9'; // Player 4 right
  }
  
  void update() {
    if (assigningControls) return; // Freeze updates during key assignment
    
    // Update player number buttons
    for (int i = 0; i < playerButtons.length; i++) {
      if (playerButtons[i].isClicked()) {
        // Deselect all buttons
        for (int j = 0; j < playerButtons.length; j++) {
          playerButtons[j].selected = false;
        }
        // Select this button
        playerButtons[i].selected = true;
        numPlayers = i + 2; // 2, 3, or 4 players
      }
    }
    
    // Check if start button is clicked
    if (startButton.isClicked()) {
      startGame();
    }
  }
  
  void render() {
    background(50);
    textAlign(CENTER, CENTER);
    textSize(40);
    fill(255);
    text("PAINT BATTLE", width/2, 100);
    
    // Render player buttons
    for (Button b : playerButtons) {
      b.render();
    }
    
    // Display control instructions
    textSize(30);
    text("Player Controls:", width/2, height/2 - 50);
    
    // Player controls
    textSize(18);
    int controlsY = height/2;
    int controlSpacing = 50;
    
    for (int i = 0; i < numPlayers; i++) {
      textSize(18);
      fill(getPlayerColor(i));
      // Show actual key characters or special key names
      String leftKeyDisplay = playerControls[i][0] == '<' ? "←" : 
                             (playerControls[i][0] == '>' ? "→" : 
                             (playerControls[i][0] == '^' ? "↑" : 
                             (playerControls[i][0] == 'v' ? "↓" : 
                             String.valueOf(playerControls[i][0]))));
                             
      String rightKeyDisplay = playerControls[i][1] == '<' ? "←" : 
                              (playerControls[i][1] == '>' ? "→" : 
                              (playerControls[i][1] == '^' ? "↑" : 
                              (playerControls[i][1] == 'v' ? "↓" : 
                              String.valueOf(playerControls[i][1]))));
                              
      String controls = "Player " + (i+1) + ": " + 
                      leftKeyDisplay + " (left), " + 
                      rightKeyDisplay + " (right)";
      
      text(controls, width/2 - 50, controlsY + i * controlSpacing);
      
      // Change button - make it more visible
      rectMode(CENTER);
      if (mouseX > width/2 + 180 - 40 && mouseX < width/2 + 180 + 40 &&
          mouseY > controlsY + i * controlSpacing - 12.5 && mouseY < controlsY + i * controlSpacing + 12.5) {
        fill(220, 220, 100); // Highlight when hovered
      } else {
        fill(200);
      }
      
      float changeX = width/2 + 180;
      float changeY = controlsY + i * controlSpacing;
      rect(changeX, changeY, 80, 25);
      
      fill(0);
      textSize(14);
      text("Change", changeX, changeY);
      rectMode(CORNER);
    }
    
    // Space to pause - after all controls
    fill(255);
    textSize(16);
    text("SPACE to pause game", width/2, controlsY + numPlayers * controlSpacing);
    
    // Display assignment instructions if needed
    if (assigningControls) {
      fill(0, 0, 0, 200);
      rect(0, 0, width, height);
      
      fill(255);
      textSize(24);
      text("Press key for Player " + (currentPlayerAssigning+1) + "'s " + 
           (assigningLeftKey ? "LEFT" : "RIGHT") + " control", 
           width/2, height/2);
    }
    
    // Render start button - position dynamically
    startButton.y = controlsY + numPlayers * controlSpacing + 60;
    startButton.render();
  }
  
  void handleMouseClick() {
    // Check if any of the "Change" buttons were clicked
    int controlsY = height/2;
    int controlSpacing = 50;
    
    for (int i = 0; i < numPlayers; i++) {
      float changeX = width/2 + 180;
      float changeY = controlsY + i * controlSpacing;
      float changeW = 80;
      float changeH = 25;
      
      // Debug info for button positions
      println("Button " + i + " area: x=" + (changeX-changeW/2) + "-" + (changeX+changeW/2) + 
             ", y=" + (changeY-changeH/2) + "-" + (changeY+changeH/2));
      
      if (mouseX > changeX - changeW/2 && mouseX < changeX + changeW/2 &&
          mouseY > changeY - changeH/2 && mouseY < changeY + changeH/2) {
        println("Change button " + i + " clicked!");
        assigningControls = true;
        currentPlayerAssigning = i;
        assigningLeftKey = true;
        return;
      }
    }
  }
  
  void handleKeyAssignment(char key) {
    if (!assigningControls) return;
    
    println("Handling key assignment: " + key + " for player " + (currentPlayerAssigning+1) + 
           ", assigning " + (assigningLeftKey ? "left" : "right") + " control");
    
    // Handle special keys
    char keyToAssign = key;
    if (keyCode == LEFT) keyToAssign = '←';
    else if (keyCode == RIGHT) keyToAssign = '→';
    else if (keyCode == UP) keyToAssign = '↑';
    else if (keyCode == DOWN) keyToAssign = '↓';
    
    if (assigningLeftKey) {
      playerControls[currentPlayerAssigning][0] = keyToAssign;
      assigningLeftKey = false; // Now waiting for right key
      println("Left control set, now press right control");
    } else {
      playerControls[currentPlayerAssigning][1] = keyToAssign;
      // Done assigning keys for this player
      assigningControls = false;
      assigningLeftKey = true;
      println("Controls updated for player " + (currentPlayerAssigning+1));
    }
  }
  
  void startGame() {
    gameScreen = new GameScreen(numPlayers);
    currentState = GameState.PLAYING;
  }
  
  color getPlayerColor(int playerIndex) {
    switch(playerIndex) {
      case 0: return color(0, 255, 0);  // Green
      case 1: return color(20, 80, 255);  // Blue
      case 2: return color(255, 0, 0);  // Red
      case 3: return color(255, 255, 0); // Yellow
      default: return color(255);
    }
  }
}
