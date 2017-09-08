final float RADIUS = 24;

final int C_BLACK = color(20);
final int C_WHITE = color(230);
final int C_GREY = color(200);
final int C_CONFLICT_LINE = color(230, 0, 0);
final int C_NO_CONFLICTS = color(179, 251, 131);

int nodeCount = 12;

ArrayList<Circle> circles;
Point hoverPoint = null;
Point selectedPoint = null;
HashMap<Line, Object> conflictLines;
ArrayList<Button> buttons;
boolean finished;

void setup() {
  size(1000, 1000, P2D);
  smooth(8);
  
  gameInit();
  
  buttons = new ArrayList<Button>();
  buttons.add(new Button("Restart/Next round", 5, 5, color(0, 0, 255)) {
    public void clicked() {
      gameInit();
    }
  });

  noLoop();
}

void gameInit() {
  finished = false;
  hoverPoint = null;
  selectedPoint = null;

  circles = new ArrayList<Circle>();
  conflictLines = new HashMap<Line, Object>();

  ArrayList<Point> allPoints = new ArrayList<Point>();
  while (allPoints.size() < nodeCount) {
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
    int circleSize = (int) (random(5) + 3);
    if (circleSize > allPoints.size() - 4) {
      circleSize = allPoints.size();
    }
    Circle newCircle = new Circle();
    for (int i = 0; i < circleSize; i++) {
      Point transferPoint = allPoints.remove((int) random(allPoints.size()));
      newCircle.addPoint(transferPoint);
    }
    circles.add(newCircle);
  }
  computeConflicts();
  redraw();
}

void draw() {
  background(C_GREY);
  noStroke();
  fill(C_WHITE);
  rect(75, 75, 850, 850);
  
  for (Circle circle : circles) {
    if (circle.hasConflicts) {
      noFill();
      for (int i = 0; i < circle.points.size(); i++) {
        Point a = circle.points.get(i);
        Point b = circle.points.get((i+1)%circle.points.size());
  
        Line testLine = new Line(a, b);
        if (conflictLines.containsKey(testLine)) {
          stroke(C_CONFLICT_LINE);
        } else {
          stroke(C_BLACK);
        }
        line(a.position.x, a.position.y, b.position.x, b.position.y);
      }
    } else {
      fill(C_NO_CONFLICTS);
      stroke(C_BLACK);
      beginShape();
      for (Point point : circle.points) {
        vertex(point.position.x, point.position.y);
      }
      endShape(CLOSE);
    }
  }

  noStroke();
  for (Circle circle : circles) {
    for (Point point : circle.points) {
      if (point == hoverPoint && !finished) {
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
  
  if (finished) {
    fill(200, 255, 255, 180);
    rect(150, 400, 700, 200);
    
    textSize(64);
    textAlign(CENTER, CENTER);
    fill(0);
    text("CONGRATULATIONS", 500, 500);
  }
  
  for (Button button : buttons) {
    button.draw();
  }
}

void mouseMoved() {
  if (!finished) {
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
  for (Button button : buttons) {
    if (button.update(false)) {
      redraw();
    }
  }
}

void mouseDragged() {
  for (Button button : buttons) {
    if (button.update(true)) {
      redraw();
    }
  }
}

void mouseClicked() {
  if (mouseButton != LEFT || finished) {
    return;
  }
  if (hoverPoint != null) {
    if (selectedPoint == null) {
      selectedPoint = hoverPoint;
    } else {
      swapCircles(selectedPoint, hoverPoint);
      computeConflicts();
      selectedPoint = null;
    }
  } else if (selectedPoint != null) {
    selectedPoint = null;
  }
  redraw();
}

void mousePressed() {
    for (Button button : buttons) {
    if (button.update(true)) {
      redraw();
    }
  }
}

void mouseReleased() {
  for (Button button : buttons) {
    if (button.update(false)) {
      redraw();
    }
  }
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

void computeConflicts() {
  conflictLines = new HashMap<Line, Object>();
  
  ArrayList<Line> allLines = new ArrayList<Line>();
  for (Circle circle : circles) {
    circle.hasConflicts = false;
    for (int i = 0; i < circle.points.size(); i++) {
      Point a = circle.points.get(i);
      Point b = circle.points.get((i+1) % circle.points.size());
      Line newLine = new Line(a, b);
      allLines.add(newLine);
    }
  }
  
  for (int i = 0; i < allLines.size(); i++) {
    for (int j = i + 1; j < allLines.size(); j++) {
      Line l1 = allLines.get(i);
      Line l2 = allLines.get(j);
      if (l1.crosses(l2)) {
        conflictLines.put(l1, null);
        conflictLines.put(l2, null);
        l1.a.circle.hasConflicts = true;
        l2.a.circle.hasConflicts = true;
      }
    }
  }
  
  if (conflictLines.isEmpty()) {
    finished = true;
    nodeCount += 3;
  }
}