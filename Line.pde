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
  public boolean crosses(Line other) {
    float x1 = this.a.position.x;
    float x2 = this.b.position.x;
    float x3 = other.a.position.x;
    float x4 = other.b.position.x;
    float y1 = this.a.position.y;
    float y2 = this.b.position.y;
    float y3 = other.a.position.y;
    float y4 = other.b.position.y;
    float t1 = ((x1-x3)/(x4-x3) - (y1-y3)/(y4-y3)) / ((y2-y1)/(y4-y3) - (x2-x1)/(x4-x3));
    float t2 = ((y3-y1)/(y2-y1) - (x3-x1)/(x2-x1)) / ((x4-x3)/(x2-x1) - (y4-y3)/(y2-y1));
    
    return t1 > 0 && t1 < 1f && t2 > 0 && t2 < 1f;
  }
}