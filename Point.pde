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