static final float RADIUS = 24;

class Point {
  final PVector position;
  Point(PVector position) {
    this.position = position.copy();
  }
  public String toString() {
    return "Point [position=" + position + "]";
  }
}

class Circle {
  ArrayList<Point> points = new ArrayList<Point>();
  public String toString() {
    return "Circle [size=" + points.size() + "]";
  }
}

ArrayList<Circle> circles = new ArrayList<Circle>();
Point hoverPoint = null;

void setup() {
  size(1000, 1000, P2D);
  
  ArrayList<Point> allPoints = new ArrayList<Point>();
  while (allPoints.size() < 20) {
    PVector newVec = new PVector(random(800)+100, random(800)+100);
    for (Point point : allPoints) {
      if (newVec.dist(point.position) < 100) {
        newVec = null;
        break;
      }
    }
    if (newVec != null) {
      allPoints.add(new Point(newVec));
    }
  }
  while (!allPoints.isEmpty()) {
    int circleSize = (int) (random(3) + 3);
    if (circleSize > allPoints.size() - 2) {
      circleSize = allPoints.size();
    }
    Circle newCircle = new Circle();
    for (int i = 0; i < circleSize; i++) {
      Point transferPoint = allPoints.remove((int) random(allPoints.size()));
      newCircle.points.add(transferPoint);
    }
    circles.add(newCircle);
  }
  
  noLoop();
}

void draw() {
  background(255);
  
  stroke(3);
  for (Circle circle : circles) {
    for (int i = 0; i < circle.points.size(); i++) {
      Point a = circle.points.get(i);
      Point b = circle.points.get((i+1)%circle.points.size());
      fill(0);
      line(a.position.x, a.position.y, b.position.x, b.position.y);
    }
  }
  noStroke();
  for (Circle circle : circles) {
    for (Point point : circle.points) {
      if (point == hoverPoint) {
        fill(200);
      } else {
        fill(100);
      }
      ellipse(point.position.x, point.position.y, RADIUS*2, RADIUS*2);
    }
  }
}

void mouseMoved() {
  PVector mousePos = new PVector(mouseX, mouseY);
  for (Circle circle : circles) {
    for (Point point : circle.points) {
      if (mousePos.dist(point.position) < RADIUS) {
        hoverPoint = point;
        redraw();
        return;
      }
    }
  }
  if (hoverPoint != null) {
    hoverPoint = null;
    redraw();
  }
}