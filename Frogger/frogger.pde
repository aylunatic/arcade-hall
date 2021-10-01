int canvasWidth = 700;
int canvasHeight = 700;
Frog frog;
Fly fly1, fly2, fly3, fly4;

void setup() {
  size(700, 700);
  background(0xAFE5FF);

  frog = new Frog(canvasWidth/2, canvasHeight/2);
  fly1 = new Fly(20);
}

void draw() {

  
  fly1.update();
}

class Frog {
  int posX;
  int posY;
  
  Frog(int x, int y) {
    posX = x;
    posY = y;
  }
  
  void drawFrog() {
  
  }
  
  void updateEyes() {
  
  }
}
  class Fly{
  int posX;
  int posY;
  int speedX;
  int speedY;
  
  Fly(int newSpeed){
    posX = 0;
    posY = 0;
    speedX = newSpeed;
  }
  void update(){
    this.move();
    fill(25);
    stroke(25);
    
    ellipse(posX, posY, 40, 28);
  }
  
  void move() {
    speedY = int(random(0, 2));
    
    if(posX <= canvasWidth) {
      posX += speedX;
    }
    else posX -= speedX;
    
    if(posY <= canvasHeight) {
      posY += speedY;
    }
    else posY -= speedY;
  }
}