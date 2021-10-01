
int winkTimer1;
int winkTimer2;
Frog frog;
Fly fly;

void setup() {
  size(1000, 1000);
  background(0xAFE5FF);
  winkTimer1 = int(random(10000/frameRate, 17500/frameRate));
  frog = new Frog(width/2, height/2);
}

void draw() {
    background(0xAFE5FF);
    frog.drawFrog();
    frog.updateTongue();
}

class Frog {
  int posX;
  int posY;
  int headWidth = 250;
  int headHeight = 175;
  int eyeSize = 100;
  int bodyWidth = headWidth - (headWidth/4);
  int bodyHeight = headHeight + (headHeight/5);
  Eye leftEye, rightEye;
  
  
  Frog(int x, int y) {
    posX = x;
    posY = y;
    leftEye = new Eye(posX - headWidth/4, posY - headHeight, eyeSize);
    rightEye = new Eye(posX + headWidth/4, posY - headHeight, eyeSize);
  }
  
  void drawFrog() {
    fill(#72db62); //Körperfarbe
    stroke(0,0,0,0); // keine Umrandungen
    ellipse(posX, posY - headHeight/2, headWidth, headHeight); // Kopf
    ellipse(posX, posY + bodyHeight/3, bodyWidth, bodyHeight); // Körper
    fill(203, 226, 152, 96);
    ellipse(posX, posY + bodyHeight/3, bodyWidth - bodyWidth/3, bodyHeight - bodyHeight/3); // Bauch
    updateEyes();// Positionen der Augen aktualisieren und anzeigen
    strokeWeight(4);
  }
  
  void updateEyes() {
    if(winkTimer1 > 0) { // Wenn die Bedingung erfüllt ist, sind noch Frames übrig in denen das Auge offen sein soll
      leftEye.update(mouseX, mouseY);
      rightEye.update(mouseX, mouseY);
      leftEye.display();
      rightEye.display();
      winkTimer1--;
    }
    else if(winkTimer2 > 0) { // Wenn die Zeit des offenen Auges abgelaufen ist, geschlossen anzeigen und Zeit runterzählen
      fill(#72db62);
      circle(posX - headWidth/4, posY - headHeight, eyeSize); // Linkes Auge
      circle(posX + headWidth/4, posY - headHeight, eyeSize); // Rechtes Auge
      winkTimer2--;
    } else { // Wenn beide auf 0 sind, Auge wieder geöffnet anzeigen und neue Zeitintervalle für das nächste Blinzeln bestimmen
      leftEye.update(mouseX, mouseY);
      rightEye.update(mouseX, mouseY);
      leftEye.display();
      rightEye.display();
      winkTimer1 = int(random(17500/frameRate, 25000/frameRate));
      winkTimer2 = int(random(1000/frameRate, 1250/frameRate));
    }
  }

  void updateTongue() {
  if (mousePressed) {
    fill(#E32C56);
    ellipse(mouseX, mouseY, 30, 30);
  }
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
    stroke(#72db62);
    strokeWeight(10);
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

class Fly {
  int posX;
  int posY;
  int vX;
  int vY;

  Fly() {
    posX = int(random((width/10), random(width/10)*2));
    posY = int(random((height/10), random(height/3)));
  }
}