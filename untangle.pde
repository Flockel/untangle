static final float RADIUS = 24;

class Point {
  final PVector position;
  Circle circle;
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
  public void addPoint(Point point) {
    point.circle = this;
    points.add(point);
  }
}

class Line {
  final Point a, b;
  Line(Point a, Point b) {
    this.a = a;
    this.b = b;
  }
  public int hashCode() {
    return a.hashCode() + b.hashCode();
  }
  public boolean equals(Object ob) {
    if (!(ob instanceof Line)) {
      return false;
    }
    Line other = (Line) ob;
    return (this.a == other.a && this.b == other.b)
        || (this.a == other.b && this.b == other.a);
  }
}

ArrayList<Circle> circles = new ArrayList<Circle>();
Point hoverPoint = null;
Point selectedPoint = null;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  
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
    int circleSize = (int) (random(4) + 3);
    if (circleSize > allPoints.size() - 4) {
      circleSize = allPoints.size();
    }
    Circle newCircle = new Circle();
    for (int i = 0; i < circleSize; i++) {
      Point transferPoint = allPoints.remove((int) random(allPoints.size()));
      newCircle.addPoint(transferPoint);
    }
    circles.add(newCircle);
    println("New: " + newCircle);
  }
  
  noLoop();
}

void draw() {
  background(230);
  
  stroke(3);
  noFill();
  for (Circle circle : circles) {
    for (int i = 0; i < circle.points.size(); i++) {
      Point a = circle.points.get(i);
      Point b = circle.points.get((i+1)%circle.points.size());
      fill(0);
      line(a.position.x, a.position.y, b.position.x, b.position.y);
    }
    endShape(CLOSE);
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
      if (point == selectedPoint) {
        fill(255);
        ellipse(point.position.x, point.position.y, RADIUS/2, RADIUS/2);
      }
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

void mouseClicked() {
  if (mouseButton != LEFT) {
    return;
  }
  if (hoverPoint != null) {
    if (selectedPoint == null) {
      selectedPoint = hoverPoint;
    } else {
      swapCircles(selectedPoint, hoverPoint);
      selectedPoint = null;
    }
  } else if (selectedPoint != null) {
    selectedPoint = null;
  }
  redraw();
}

void swapCircles(Point a, Point b) {
  Circle circleA = a.circle;
  Circle circleB = b.circle;
  int indexA = circleA.points.indexOf(a);
  int indexB = circleB.points.indexOf(b);
  circleA.points.set(indexA, b);
  circleB.points.set(indexB, a);
  a.circle = circleB;
  b.circle = circleA;
}