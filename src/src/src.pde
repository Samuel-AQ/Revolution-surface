PShape customShape;
color red;
boolean isDrawing;
ArrayList<Point> vertices;
int touchLineCounter, frameSpeed;

void setup() {
  size(500, 500, P3D);
  customShape = createShape();
  red = color(255, 0, 0);
  isDrawing = true;
  vertices = new ArrayList<Point>();
  touchLineCounter = 0;
  frameSpeed = 1;
}

void draw() {
  frameRate(frameSpeed);
  drawField();
  if (!isDrawing) setShape();
}

void setShape() {
  drawUserFigure();
  //customShape.vertex(0, 0, 0);
  //customShape.vertex(0, 100, 0);
  //customShape.vertex(100, 100, 0);
  //customShape.vertex(100, 0, 0);
}

void drawField() {
  drawBackground();

  if (isDrawing) {
    int xMiddle = width / 2;
    line(xMiddle, 0, xMiddle, height);
    stroke(red);
    drawUserFigure();
  }
}

void drawBackground() {
  color black = color(0);
  background(black);
}

void drawUserFigure() {
  if (isDrawing) {
    for (int i = 0; i < vertices.size(); i++) {
      Point point = vertices.get(i);
      if (i == 0){
        line(point.x, point.y, point.x, point.y);
      }else{
        Point previousPoint = vertices.get(i-1);
        line(point.x, point.y, previousPoint.x, previousPoint.y);
      }
      stroke(red);
    }
  } else {
    customShape.beginShape(TRIANGLE_STRIP);
    customShape.stroke(red);
    customShape.fill(128);
    for (int i = 0; i < vertices.size(); i++) {
      Point point = vertices.get(i);
      customShape.vertex(point.x, point.y, 0);
    }
    customShape.endShape();
    shape(customShape);
    rotateX(PI/8);
  }
}


void mouseDragged() {
  System.out.println(touchLineCounter);
  if (isDrawing) {
    boolean mouseIsInArea = mouseX >= width / 2;
    boolean mouseHitsMiddle = mouseX == width / 2;

    if (mouseHitsMiddle) touchLineCounter++;
    if (mouseIsInArea && touchLineCounter == 1) {
      //int[] point = {mouseX, mouseY, pmouseX, pmouseY};
      vertices.add(new Point(mouseX, mouseY));
    }
    if(touchLineCounter == 2){
      isDrawing = false;
      frameSpeed = 60;
    }
  }
}
