PImage eyeImg;

int numStars = 200;
float[][] stars;
float offset = 0; 

ArrayList<Monster> monsters = new ArrayList<Monster>();
int numMonsters = 8;
boolean monstersSpawned = false;

void setup() {
  fullScreen();
  noStroke();
  generateStars();
  eyeImg = loadImage("eye.png"); 
for (int i = 0; i < numMonsters; i++) {
    float mx = random(width);
    float my = -random(height); 
    float msize = random(80, 150); 
    monsters.add(new Monster(mx, my, msize));
  }
}

void draw() {
  background(0);

  // Draw sky gradient that darkens from top to bottom based on offset
  for (int y = 0; y < height; y++) {
    float altitude = offset + (height - y); // Reversed so top gets darker first
    float inter = map(altitude, 0, height * 1.5, 0, 1); // Controls darkness gradient
    
    color c1 = color(0, 100, 200);   // base sky blue
    color c2 = color(255, 100, 150); // base pink sunset

    color from = lerpColor(c1, color(10), inter);
    color to = lerpColor(c2, color(0), inter);
    color rowColor = lerpColor(from, to, float(y) / height);
    
    stroke(rowColor);
    line(0, y, width, y);
  }

  drawStars();
  updateStars();
  offset += 0.5; // simulate upward motion

  // Spawn monsters once sky is dark enough
  

  // Update, draw, and recycle monsters
  for (Monster m : monsters) {
    m.update();
    m.display();

    // Recycle monster if it moves off screen
    if (m.y > height + 50) {
      m.x = random(width);
      m.baseY = -random(100, 300); // respawn above screen
      m.size = random(30, 60);
    }
  }
}

// Generate random star positions
void generateStars() {
  stars = new float[numStars][2];
  for (int i = 0; i < numStars; i++) {
    stars[i][0] = random(width);
    stars[i][1] = random(height * 2); // stars appear gradually as you move up
  }
}

void drawStars() {
  for (int i = 0; i < numStars; i++) {
    float x = stars[i][0];
    float y = stars[i][1] + offset;

    if (y >= 0 && y < height) {
      float altitude = offset + (height - y);
      float inter = map(altitude, 0, height * 2, 0, 1);
      float darkness = constrain(inter, 0, 1);

      if (darkness > 0.2) {
        float alpha = map(darkness, 0.2, 1.0, 50, 255);
        float size = map(darkness, 0.2, 1.0, 2, 4); 
        alpha = constrain(alpha, 50, 255);

        fill(255, alpha);
        noStroke();
        ellipse(x, y, size, size);
      }
    }

    // Recycle star if it has scrolled off bottom
    if (y >= height * 2) {
      stars[i][0] = random(width);
      stars[i][1] = -offset - random(height); // place back above screen
    }
  }
}

void updateStars() {
  for (int i = 0; i < numStars; i++) {
    stars[i][1] += 0.5; // make stars fall

    if (stars[i][1] + offset > height * 2) {
      // reset star to top
      stars[i][0] = random(width);
      stars[i][1] = -offset; // places star just above visible range
    }
  }
}

class Monster {
  float x, y;
  float size;
  float baseY;
  float offset;
  float fallSpeed;

  Monster(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.baseY = y;
    this.size = size;
    this.offset = random(TWO_PI);
    this.fallSpeed = random(0.3, 0.8);
  }

  void update() {
    baseY += fallSpeed;
    y = baseY + sin(offset + frameCount * 0.05) * 10; // wavy float
  }

  void display() {
    imageMode(CENTER);
    image(eyeImg, x, y, size * 1.5, size);
  }
}
