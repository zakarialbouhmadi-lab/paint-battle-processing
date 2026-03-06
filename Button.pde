// --- Button Class ---
class Button {
  float x, y, w, h;
  String label;
  boolean selected = false;
  
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void render() {
    if (selected) {
      fill(200, 200, 100);
    } else if (isHovered()) {
      fill(180);
    } else {
      fill(120);
    }
    
    rectMode(CENTER);
    rect(x, y, w, h);
    
    fill(0);
    textAlign(CENTER, CENTER);
    textSize(h * 0.4);
    text(label, x, y);
    rectMode(CORNER);
  }
  
  boolean isHovered() {
    return mouseX > x - w/2 && mouseX < x + w/2 && 
           mouseY > y - h/2 && mouseY < y + h/2;
  }
  
  boolean isClicked() {
    return isHovered() && mousePressed && mouseButton == LEFT;
  }
}
