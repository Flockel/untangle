class Circle {
  ArrayList<Point> points = new ArrayList<Point>();
  boolean hasConflicts = false;
  public String toString() {
    return "Circle [size=" + points.size() + "]";
  }
  public void addPoint(Point point) {
    point.circle = this;
    points.add(point);
  }
}