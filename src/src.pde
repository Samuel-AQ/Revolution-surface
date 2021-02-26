//TODO:
//- Center figure
//- Fix width
//- readme

PShape customShape;
color red;
boolean isDrawing, showInfo, applicationIsRunning;
PointsSet pointsSet;
int touchLineCounter;
double angle;
float xRotation, yRotation;
Point viewAngle;

void setup() {
  size(1000, 1000, P3D);
  customShape = createShape();
  red = color(255, 0, 0);
  isDrawing = true;
  showInfo = true;
  applicationIsRunning = false;
  pointsSet = new PointsSet();
  touchLineCounter = 0;
  angle = 5;
  xRotation = 0;
  yRotation = 0;
  viewAngle = new Point(0, 0, 0);
}

void draw() {
  drawBackground();
  if (!showInfo) {
    drawUserFigure();
    if (isDrawing) {
      int xMiddle = width / 2;
      line(xMiddle, 0, xMiddle, height);
      stroke(red);
    }
  } else {
    showInfoScreen();
  }
}

void drawBackground() {
  color black = color(0);
  background(black);
}

void drawUserFigure() {
  if (isDrawing) {
    for (int i = 0; i < pointsSet.getSize(); i++) {
      drawLine(i);
    }
  } else {
    double angleLimit  = 360;
    translate(viewAngle.x, viewAngle.y, viewAngle.z);
    rotateX(xRotation);
    rotateY(yRotation);
    customShape.beginShape(TRIANGLE_STRIP);
    customShape.fill(255);
    customShape.stroke(red);
    for (double initialAngle = angle; initialAngle < angleLimit; initialAngle += angle) {
      pointsSet.createNeighbords(angle);
      joinPointsAndNeighbords();
      pointsSet.updatePoints();
      initialAngle += angle;
    }
    customShape.endShape();
    shape(customShape);
  }
}

void showInfoScreen() {
  String title = "Manual";
  String info = "- To reset de application press 'r'\n" + 
    "- To view this information again or go to the application, press 'i'\n" + 
    "- To adjust the zoom use the mouse wheel\n" + 
    "- To move de figure click en drag the mouse cursor\n" +
    "- To rotate the figure use de arrow buttons of the keyboard";
  String howTo = "How to draw";
  String howToInfo = "Click in the middle line and start to set points drawing the figure\n" +
    "you want the program to create in 3D clicking in the right side.\n" + 
    "When you are done drawing, click again in the middle line\n" +
    "to inform the application that the draw has been completed.\n" + 
    "The application will give you the 3D shape you were searching for.";
  color white = color(255);
  fill(white);
  textSize(50);
  text(title, width / 2 - 300, height / 2 - 300);
  text(howTo, width / 2 - 300, height / 2 + 100);
  textSize(20);
  text(info, width / 2 - 300, height / 2 - 200);
  text(howToInfo, width / 2 - 300, height / 2 + 200);
}

void drawLine(int position) {
  Point point = pointsSet.getPoint(position);
  fill(red);
  stroke(red);
  if (position == 0) {
    circle(point.x, point.y, 10);
    line(point.x, point.y, point.x, point.y);
  } else {
    Point previousPoint = pointsSet.getPoint(position - 1);
    circle(point.x, point.y, 10);
    line(previousPoint.x, previousPoint.y, point.x, point.y);
  }
}

void joinPointsAndNeighbords() {
  Point lastPoint = pointsSet.getPoint(pointsSet.getSize() - 1);

  for (int i = 0; i < pointsSet.getSize(); i++) {
    Point point = pointsSet.getPoint(i);
    Point neighbord = pointsSet.getNeighbord(i);
    customShape.vertex(point.x, point.y, point.z);
    customShape.vertex(neighbord.x, neighbord.y, neighbord.z);
  }

  customShape.vertex(lastPoint.x, lastPoint.y, lastPoint.z);
}

void mouseClicked() {
  if (isDrawing) {
    boolean mouseIsInArea = mouseX >= width / 2;
    boolean mouseHitsMiddle = mouseX == width / 2;
    if (mouseHitsMiddle) touchLineCounter++;
    if (mouseIsInArea && touchLineCounter == 1) {
      pointsSet.addPoint(new Point(mouseX, mouseY, 0));
    }
    if (touchLineCounter == 2) {
      pointsSet.addPoint(new Point(mouseX, mouseY, 0));
      drawLine(pointsSet.getSize() - 1);
      isDrawing = false;
    }
  }
}

void mouseDragged() {
  if (!isDrawing) {
    viewAngle = new Point(mouseX, mouseY, viewAngle.z);
  }
}

void mouseWheel(MouseEvent event) {
  if (!isDrawing) {
    viewAngle = new Point(viewAngle.x, viewAngle.y, viewAngle.z - event.getCount() * 50);
  }
}

void keyPressed() {
  // To reset the draw values
  if (keyCode == 'r' || keyCode == 'R') {
    if (applicationIsRunning) {
      setup();
      showInfo = false;
    }
  }
  // To show information about how to use the application and to return to the drawing
  if (keyCode == 'i' || keyCode == 'I') {
    showInfo = !showInfo;
    applicationIsRunning = true;
  }
  // To rotate the figure
  if (keyCode == UP) {
    xRotation += 0.1;
  }
  if (keyCode == DOWN) {
    xRotation -= 0.1;
  }
  if (keyCode == LEFT) {
    yRotation += 0.1;
  }
  if (keyCode == RIGHT) {
    yRotation -= 0.1;
  }
}
