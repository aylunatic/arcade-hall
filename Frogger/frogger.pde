int canvasWidth = 700;
int canvasHeight = 700;
Frog frog;

void setup() {
  size(700, 700);
  background(0xAFE5FF);

  frog = new Frog(canvasWidth/2, canvasHeight/2);
}

void draw() {
    frog.drawFrog();
}

class Frog {
  int posX;
  int posY;
  int bodyWidth = 250;
  int bodyHeight = 200;
  Eye leftEye, rightEye;
  
  
  Frog(int x, int y) {
    posX = x;
    posY = y;
    leftEye = new Eye((width/2) - bodyWidth/4, (height/2) - bodyHeight/2, 105);
    rightEye = new Eye((width/2) + bodyWidth/4, (height/2) - bodyHeight/2, 105);
  }
  
  void drawFrog() {
    fill(#52D170); //Körperfarbe
    stroke(0,0,0,0); // keine Umrandungen
    ellipse((width/2), (height/2), bodyWidth, bodyHeight); // Kopf
    // Positionen der Augen aktualisieren und anzeigen
    leftEye.update(mouseX, mouseY);
    rightEye.update(mouseX, mouseY);
    leftEye.display();
    rightEye.display();
  }
  
  void updateEyes() {
  
  }
}

class Eye {
  int x, y;
  int size;
  float angle = 0.0;
  
  Eye(int tx, int ty, int ts) {
    x = tx;
    y = ty;
    size = ts;
 }

  void update(int mx, int my) {
    angle = atan2(my-y, mx-x);
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    fill(255);
    ellipse(0, 0, size, size);
    rotate(angle);
    fill(0);
    ellipse(size/4, 0, size/2, size/2);
    popMatrix();
  }
}