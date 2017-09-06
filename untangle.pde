class Point {
  final PVector position;
  Point(PVector position) {
    this.position = position.copy();
  }
  public String toString() {
    return "Point [position=" + position + "]";
  }
}

ArrayList<Point> points = new ArrayList<Point>(30);
Point hoverPoint = null;

void setup() {
  size(1000, 1000, P2D);
  noStroke();
  
  int tries = 0;
  while (points.size() < 20) {
    PVector newVec = new PVector(random(800)+100, random(800)+100);
    for (Point point : points) {
      if (newVec.dist(point.position) < 100) {
        newVec = null;
        break;
      }
    }
    if (newVec != null) {
      points.add(new Point(newVec));
    }
    tries += 1;
  }
  println("tried " + tries + " times");
  
  noLoop();
}

void draw() {
  background(255);
  
  for (Point point : points) {
    if (point == hoverPoint) {
      fill(200);
    } else {
      fill(50);
    }
    ellipse(point.position.x, point.position.y, 50, 50);
  }
}

void mouseMoved() {
  PVector mousePos = new PVector(mouseX, mouseY);
  for (Point point : points) {
    if (mousePos.dist(point.position) < 25) {
      hoverPoint = point;
      redraw();
      return;
    }
  }
  if (hoverPoint != null) {
    hoverPoint = null;
    redraw();
  }
}