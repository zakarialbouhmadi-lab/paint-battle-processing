// --- Board Class ---
class Board {
  PGraphics canvas;
  
  Board(int w, int h, color colour) {
    canvas = createGraphics(w, h, P2D);
    canvas.beginDraw();
    canvas.background(colour);
    canvas.endDraw();
  }
     
  void render() {
    image(canvas, 0, 0);
  }
}
