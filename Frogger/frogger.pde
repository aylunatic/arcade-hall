/* ==========================================================================================================
  ||                                                  FROGGY                                               ||
  ||               ----------------------------------------------------------------------                  ||
  ||                                    Ein Spiel von @aylunatic und @JoHoop                               ||
  ||                                                (c) 2021                                               ||
  ===========================================================================================================*/

/*-------------------------------------------  Globale Variablen  -----------------------------------------*/

int GAME_STATE = 0; // In welchem Zustand (Startscreen, Spiel, Endscreen) befindet das Spiel sich gerade?
int MAX_HITS = 10; // Wie viel Hunger hat der Frosch? (Anzahl der Fligen die zum gewinnen des Frosches gefuttert werden müssen)
boolean transition = false; // Gibt an ob der Bildschirm sich grade zum nächsten Bildschirm bewegt
// Timer 
  int winkTimer1; // Zeit bis zum nächsten Blinzeln
  int winkTimer2; // Dauer des Blinzelns
// Punkte und Siegerliste
  int points = 0;
  int hitCtr = 0;
  int[] highscoreFly = new int[10];
  float[] highscoreFrog = new float[10];
// Bilder und andere Assets
  PImage title_font;
  PImage title_frog;
  PImage title_fly;
  PImage lilly;
  PImage leaf;

// Globale Attribute die zum Frosch gehören
Frog frog;
// Globale Attribute die zur Fliege gehören
Fly fly;
  int flyVX = 0; // horizontale Beschleunigung
  int flyVY = 0; // vertikale Beschleunigung
  int flySpeed = 5; // Zuwachs der Beschleunigung


/*---------------------------------------------  Programmablauf  ---------------------------------------------*/
// Methode, welche von Processing automatisch und einmalig direkt nach dem Start des Spiels ausgeführt wird
void setup() {
  size(1000, 1000); // Leinwandgröße
  background(0xAFE5FF); // Hintergrundfarbe
  imageMode(CENTER);
  leaf = loadImage("Froggy_seerose_blatt.png");
  lilly = loadImage("Froggy_seerose_bluete.png");
  winkTimer1 = int(random(10000/frameRate, 17500/frameRate)); // Zeit bis zum ersten Blinzeln
  // Hier werden die Variablen zu tatsächlichen Objekten instantiiert
  frog = new Frog(width/2, height/2); 
  fly = new Fly();
}

// Methode, welche von Processing automatisch bei jedem Frame neu ausgeführt wird. Hier übersichtlich, da die Methoden der anderen Klassen die eigentliche Logik enthalten
void draw() {
  if(GAME_STATE < 0 && !transition) {
      drawStartscreen();
  } else if(GAME_STATE == 0 && !transition) {
      background(0xAFE5FF); // Background immer neu setzen, sonst sie man vorherige Positionen von Maus/Fliege
      hitted();// Überprüft ob die FLiege gefuttert wurde und leitet die notwendigen Schritte ein
      textSize(45); // Textgröße
      text("Points: "+points, 10, 45); // Punktestand anzeigen
      image(leaf, frog.posX, frog.posY+frog.bodyHeight);
      frog.draw(); // Grafik des Frosches (Augen) neu zeichnen
      image(lilly, frog.posX, frog.posY+frog.bodyHeight);
      frog.updateTongue(); // Prüfen, ob die Zunge herausgestreckt wurde
      fly.draw(); // Fliege bewegen und neuzeichnen
  } else if(GAME_STATE > 0 && !transition) {
      drawEndscreen();
  }
}

// Methode, welche von Processing automatisch aufgerufen wird, wenn eine Taste gedrückt wird
void keyPressed() {
  if(keyCode == LEFT) {
    flyVX -= flySpeed;
  }
  if(keyCode == RIGHT) {
    flyVX += flySpeed;
  }
  if(keyCode == UP) {
    flyVY -= flySpeed;
  }
  if(keyCode == DOWN) {
    flyVY += flySpeed;
  }
  /* Da die Beschleunigung der Fliege immer größer wird und sie sich somit schneller bewegt, kann es leicht pasieren
     dass sie aus dem sichtbaren Bereich herausfliegt, und der Spieler den Weg zurück ins Bild nicht mehr findet.
     Damit trotzdem die Möglichkeit besteht den Frosch auszutricksen, wird nur "auf Wunsch" durch drücken der SHIFT-Taste 
     neu gespawned und nicht direkt bei verlassen des Bildschirmes.*/
  if (keyCode == SHIFT && fly.outOfSight()) { // NUR wenn die Fliege nicht mehr zu sehen ist, kann sie an einer zufälligen Stelle neu gespawned werden
    fly = new Fly(); // Dies geht durch Zuweisen auf ein neues Objekt, da die Position im Konstruktor Fly() zurfällig gesetzt wird
  }
}
// Methode, welche von Processing automatischaufgerufen wird, wenn eine Taste losgelassen wird
void keyReleased() {
  // Diese Abfragen dienen einer flüssigere Steuerung
  if(keyCode == LEFT && flyVX < 0) {
    flyVX = 0;
  }
  if(keyCode == RIGHT && flyVX > 0) {
    flyVX = 0;
  }
  if(keyCode == UP && flyVY  < 0) {
    flyVY = 0;
  }
  if(keyCode == DOWN && flyVY > 0) {
    flyVY = 0;
  } 
}

/* ----------------------------------------  Spiellogik  --------------------------------------------------*/
void drawStartscreen() {

}

void drawEndscreen() {

}

void findHighscore() {
  //Einfügen des Wertes in die Highscore-Liste
  for(int i = 0; i < highscoreFly; i++) {
    // Wenn der derzeitge Rekord erreicht wird, diesen mit dem erreichten Ergebnis ersetzen falls besser
    if(i == highscoreFly.length -1) {
      if(highscoreFly[i] <= score) highscoreFly[i] = score;
    } 
    // Wenn der Wert größer als der an Index i ist aber kleiner als der nächste an dieser Stelle einfügen
    else if(highscoreFly[i] <= score && highScoreFly[i+1] > score) highscoreFly[i] = score;
}

boolean isHit() {
  return (mousePressed &&
          mouseX >= fly.posX - fly.size/2 && mouseX <= fly.posX + fly.size/2 &&
          mouseY >= fly.posY - fly.size/2 && mouseY <= fly.posY + fly.size/2);
}

void hitted() {
  if (isHit()) {
    points -= 10000/frameRate;
    fly = new Fly();
  } else if(hitCtr >= MAX_HITS) {
    findHighscore();
    GAME_STATE = 1;
    transition = true;
  }
  else points += 100/frameRate; 
}

/*-----------------------------------------------  Klassen  -----------------------------------------------*/

// Klasse für die Hauptfigur des Spiels
class Frog {
  // Position des Frosches
  int posX; 
  int posY; 
  // Größe der verschiedenen Teile des Frosches
  int headWidth = 250;
  int headHeight = 175;
  int eyeSize = 100;
  int bodyWidth = headWidth - (headWidth/4);
  int bodyHeight = headHeight + (headHeight/5);
  Eye leftEye, rightEye; // Die beiden Augen-Objekte
  
  // Konstruktor, welchem die x- und y- Koordinaten des Frosches übergeben werden
  Frog(int x, int y) {
    // Setzen der Klassenattribute posX und posY auf die in setup() übergebenen Parameter x und y
    posX = x;
    posY = y;
    // positioniert die Augen relativ zum Kopf
    leftEye = new Eye(posX - headWidth/4, posY - headHeight, eyeSize); // linkes Auge
    rightEye = new Eye(posX + headWidth/4, posY - headHeight, eyeSize); // rechtes Auge
  }
  
  // Zeichnet den Frosch (mitsamt der Kulleraugen) auf das Canvas. Wird aufgerufen in draw().
  void draw() {
    fill(#72db62); // Grün für den Körper
    stroke(0,0,0,0); // keine Umrandungen
    ellipse(posX, posY - headHeight/2, headWidth, headHeight); // Kopf
    ellipse(posX, posY + bodyHeight/3, bodyWidth, bodyHeight); // Körper
    fill(#337734);
    ellipse(posX, posY - headHeight/4, eyeSize/2, eyeSize/3); //Mund
    fill(203, 226, 152, 96); // helleres Grün
    ellipse(posX, posY + bodyHeight/3, bodyWidth - bodyWidth/3, bodyHeight - bodyHeight/3); // Bauch
    updateEyes();// Positionen der Augen aktualisieren und anzeigen
    strokeWeight(4); // Strichdicke wieder auf Standard, da dieser in den Augen verändert wird
  }
  
  // Bewegt die Augen und lässt sie in zufälligen Abständen blinzeln. Wird aufgerugen in Frog#draw
  void updateEyes() {
    if(winkTimer1 > 0) { // Wenn die Bedingung erfüllt ist, sind noch Frames übrig in denen das Auge offen sein soll
      leftEye.updateAngle(fly.posX, fly.posY); // Winkel der linken Pupille zur Maus berechnen
      rightEye.updateAngle(fly.posX, fly.posY); // Winkel der rechten Pupille zur Maus berechnen
      stroke(#72db62);
      strokeWeight(10);
      leftEye.display(); // linkes Auge neu zeichnen
      stroke(#72db62);
      strokeWeight(10);
      rightEye.display(); // rechtes Auge neu zeichnen
      winkTimer1--; // dekrementieren, denn blinzeln ist wichtig damit die Augen befeuchtet werden
    }
    else if(winkTimer2 > 0) { // Wenn die Zeit des offenen Auges abgelaufen ist, geschlossen anzeigen und Zeit runterzählen
      // Grüne Kreise für geschlossene Augen beim Blinzeln
      fill(#72db62);
      circle(posX - headWidth/4, posY - headHeight, eyeSize); // Linkes Auge
      circle(posX + headWidth/4, posY - headHeight, eyeSize); // Rechtes Auge
      // Lidstriche für die Augen wenn die geschlossen sind
      strokeWeight(10);
      stroke(#337734);
      line((posX-headWidth/4)-eyeSize/2+8, posY - headHeight +eyeSize/20,
           (posX-headWidth/4)+eyeSize/2-8, posY - headHeight +eyeSize/20);
      line((posX+headWidth/4)-eyeSize/2+8, posY - headHeight +eyeSize/20, 
           (posX+headWidth/4)+eyeSize/2-8, posY - headHeight +eyeSize/20);
      winkTimer2--; // Dekrementieren damit die Augen nicht ewig zu sind
    } else { // Wenn beide auf 0 sind, Auge wieder geöffnet anzeigen und neue Zeitintervalle für das nächste Blinzeln bestimmen
      leftEye.updateAngle(mouseX, mouseY); // Winkel der linken Pupille zur Maus berechnen
      rightEye.updateAngle(mouseX, mouseY); // Winkel der rechten Pupille zur Maus berechnen
      stroke(#72db62);
      strokeWeight(10);
      leftEye.display(); // linkes Auge neu zeichnen
      stroke(#72db62);
      strokeWeight(10);
      rightEye.display(); // rechtes Auge neu zeichnen
      winkTimer1 = int(random(17500/frameRate, 25000/frameRate)); // neue zufällige Zeitspanne bis zum nächsten Blinzeln
      winkTimer2 = int(random(1000/frameRate, 1250/frameRate)); // neue Zufällige Dauer des nächsten Blinzelns
    }
  }

  // zeichnet die Zunge auf das Canvas, wird aufgerufen in draw()
  void updateTongue() {
    if (mousePressed) {
      fill(#E32C56);
      stroke(0,0,0,0);
      ellipse(mouseX, mouseY, 25, 30);
      stroke(#E32C56);
      strokeWeight(20);
      line(posX, posY - headHeight/4 + eyeSize/3 - 25 , mouseX, mouseY);
    }
  }
}

// taken from https://processing.org/examples/arctangent.html with adaptions from @JoHoop 
class Eye {
  int x, y;
  int size;
  float angle = 0.0;
  
  Eye(int tx, int ty, int ts) {
    x = tx;
    y = ty;
    size = ts;
 }

 void updatePosition(int x, int y) {
   this.x = x;
   this.y = y;
 }

  void updateAngle(int mx, int my) {
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
    float distance = sqrt((sq(distanceX) + sq(distanceY)));
    if (distance < (size/4)) {
      ellipse(distance, 0, size/2, size/2);
    } else {
      ellipse(size/4, 0, size/2, size/2);
    }
    popMatrix();
  }
}

class Fly {
  int posX; // x-Koordinate der Fliege
  int posY; // y-Koordinate der Fliege
  int size = 35; // Größe der Fliege
  Eye leftEye, rightEye; // Die beiden Augen-Objekte

  //Konstruktor
  Fly() {
    // weist der neu erstellten Fliege eine zufällige Startposition im mittleren, oberen Drittel des Bildschirmes zu
    posX = int(random((width/10), (width/10)*9));
    posY = int(random((height/10), (height/3)));
    leftEye = new Eye(posX - size/4, posY - size/3, size/2); // linkes Auge
    rightEye = new Eye(posX + size/4, posY - size/3, size/2); // rechtes Auge
  }

  // Zeichnet die Fliege auf das Canvas
  void draw() {
    update();
    strokeWeight(0);
    fill(255);
    ellipse(posX+size/2,posY,size,size/2);
    ellipse(posX-size/2,posY,size,size/2);
    fill(0);
    stroke(0,0,0);
    strokeWeight(5);
    circle(posX, posY, size);
    stroke(0,0,0);
    strokeWeight(3);
    leftEye.display(); // linkes Auge neu zeichnen
    stroke(0,0,0);
    strokeWeight(3);
    rightEye.display(); // rechtes Auge neu zeichnen
    stroke(255);
    strokeWeight(5);
    line(posX,posY+size/3,posX,posY+size);
  }

  // Versetzt die Position der Fliege entsprechend der Geschwindigkeit
  void update() {
    posX += flyVX;
    posY += flyVY;
    leftEye.updatePosition(posX - size/4, posY - size/3);
    rightEye.updatePosition(posX + size/4, posY - size/3);
    leftEye.updateAngle(mouseX, mouseY); // Winkel der linken Pupille zur Maus berechnen
    rightEye.updateAngle(mouseX, mouseY); // Winkel der rechten Pupille zur Maus berechnen
  }

  // Prüft, ob die Fliege den Bildschirmrand verlassen
  boolean outOfSight() {
    if(posX < 0 || posX > width ||  posY < 0 || posY > height) return true;
    else return false;
  }
}
