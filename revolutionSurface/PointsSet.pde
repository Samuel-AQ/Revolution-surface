public class PointsSet{
  ArrayList<Point> points, neighbords;
  
  public PointsSet(){
    points = new ArrayList<Point>();
    neighbords = new ArrayList<Point>();
  }
  
  protected void addPoint(Point point){
    points.add(point);
  }
  
  protected void updatePoints(){
    points = new ArrayList<Point>(neighbords);
  }
  
  protected void createNeighbords(double angle){
    neighbords = new ArrayList<Point>();
    // The angle in radians is better for the 3D draw
    angle = Math.toRadians(angle);
    for(int i = 0; i < points.size(); i++){
      Point point = points.get(i);
      float newX = (float)(point.x * Math.cos(angle) - point.z * Math.sin(angle));
      float newZ = (float)(point.x  * Math.sin(angle) + point.z * Math.cos(angle));
      neighbords.add(new Point(newX, point.y, newZ));
    }
  }
  
  protected int getSize(){
    return points.size();
  }
  
  protected Point getPoint(int position){
    return points.get(position);
  }
  
  protected Point getNeighbord(int position){
    return neighbords.get(position);
  }
}
