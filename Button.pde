public abstract class Button {
  final String label;
  final float x, y;
  final int textColor;
  boolean hovered;
  boolean pushed;
  
  public Button(String label, float x, float y, int textColor) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.textColor = textColor;
  }
  
  public void draw() {
    textSize(32);
    textAlign(LEFT, TOP);

    if (hovered && !pushed) {
      fill(C_WHITE);
    } else if (pushed) {
      fill(C_BLACK);
    } else {
      fill(textColor);
    }

    text(label, x, y);
  }
  
  int ups = 0;
  public boolean update(boolean mousePress) {
    boolean nextHovered = mouseX >= x && mouseX <= x + textWidth(label)
        && mouseY >= y && mouseY <= y + 32;
    
    boolean nextPushed = mousePress;

    if (hovered && pushed && !nextPushed) {
      clicked();
    }

    boolean stateChanged = hovered != nextHovered || pushed != nextPushed;
    hovered = nextHovered;
    pushed = nextPushed;
    return stateChanged;
  }
  
  public abstract void clicked();
}