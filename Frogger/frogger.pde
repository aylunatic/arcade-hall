int canvasWidth = 700;
int canvasHeight = 700;

int winkTimer1;
int winkTimer2;
Frog frog;

void setup() {
  size(700, 700);
  background(0xAFE5FF);
  winkTimer1 = int(random(750, 1250));
  winkTimer2 = int(random(125, 250));
  frog = new Frog(canvasWidth/2, canvasHeight/2);

}

void draw() {
    frog.drawFrog();
}

class Frog {
  int posX;
  int posY;
  int bodyWidth = 300;
  int bodyHeight = 200;
  Eye leftEye, rightEye;
  
  
  Frog(int x, int y) {
    posX = x;
    posY = y;
    leftEye = new Eye((width/2) - bodyWidth/4, (height/2) - bodyHeight/2, 110);
    rightEye = new Eye((width/2) + bodyWidth/4, (height/2) - bodyHeight/2, 110);
  }
  
  void drawFrog() {
    fill(#72db62); //Körperfarbe
    stroke(0,0,0,0); // keine Umrandungen
    ellipse((width/2), (height/2), bodyWidth, bodyHeight); // Kopf
    updateEyes();// Positionen der Augen aktualisieren und anzeigen
    strokeWeight(4);

  }
  
  void updateEyes() {
    leftEye.update(mouseX, mouseY);
    rightEye.update(mouseX, mouseY);
    stroke(#72db62);
    strokeWeight(10);
    leftEye.display();
    stroke(#72db62);
    strokeWeight(10);
    rightEye.display();
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
    stroke(0);
    strokeWeight(0);
    int distanceX = mouseX - x;
    int distanceY = mouseY - y;
    float distance = sqrt((pow(distanceX,2) + pow(distanceY,2)));
    if (distance < (size/4)) {
      ellipse(distance, 0, size/2, size/2);
    } else {
      ellipse(size/4, 0, size/2, size/2);
    }
    popMatrix();
  }
}