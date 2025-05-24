PImage eyeImg, explosionImg;
import processing.serial.*;

Serial myPort;
String incoming;

int sensorValue = 100;
int numStars = 200;
float[][] stars;
float offset = 0;
float hue = 210; //hsb color

ArrayList<Monster> monsters = new ArrayList<Monster>();
ArrayList<Explosion> explosions = new ArrayList<Explosion>();

int numMonsters = 8;

void setup() {
  colorMode(HSB, 360, 100, 100);
  println(Serial.list());  // List all available ports
  myPort = new Serial(this, Serial.list()[4], 9600);  // Choose correct port
  fullScreen();
  noStroke();
  generateStars();

  eyeImg = loadImage("eye.png");
  explosionImg = loadImage("explosion.png");

  for (int i = 0; i < numMonsters; i++) {
    monsters.add(new Monster(random(width), -random(height), random(80, 150)));
  }
}

void draw() {
  drawSkyGradient();
  drawStars();
  updateStars();
  offset += 0.5;

  // Update and display monsters
  for (Monster m : monsters) {
    m.update();
    m.display();

    if (m.y > height + 50) {
      m.reset();
    }
  }

  // Display explosions
  for (int i = explosions.size() - 1; i >= 0; i--) {
    Explosion e = explosions.get(i);
    e.display();
    if (e.isDone()) {
      explosions.remove(i);
    }
  }
}

void generateStars() {
  stars = new float[numStars][2];
  for (int i = 0; i < numStars; i++) {
    stars[i][0] = random(width);
    stars[i][1] = random(height * 2);
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
        fill(255, alpha);
        noStroke();
        ellipse(x, y, size, size);
      }
    }

    if (y >= height * 2) {
      stars[i][0] = random(width);
      stars[i][1] = -offset - random(height);
    }
  }
}

void updateStars() {
  for (int i = 0; i < numStars; i++) {
    stars[i][1] += 0.5;

    if (stars[i][1] + offset > height * 2) {
      stars[i][0] = random(width);
      stars[i][1] = -offset;
    }
  }
}

void drawSkyGradient() {

  if (myPort.available() > 0) {
    String incoming = myPort.readStringUntil('\n');
    if (incoming != null) {
      incoming = trim(incoming);
      if (incoming.length() > 0) {
        sensorValue = int(incoming);
      }
    }
  }

  float maxBrightness = map(sensorValue, 0, 1023, 0, 100);

  for (int y = 0; y < height; y++) {
    float altitude = offset + (height - y);
    float inter = map(altitude, 0, height * 1.5, 0, 1);
    float sat = lerp(30, 100, inter);
    float bright = sensorValue; // Fade to black

    stroke(hue, sat, bright);
    line(0, y, width, y);
  }
}

void mousePressed() {
  for (int i = monsters.size() - 1; i >= 0; i--) {
    Monster m = monsters.get(i);
    if (m.isClicked(mouseX, mouseY)) {
      explosions.add(new Explosion(m.x, m.y, m.size));  // Add explosion
      m.reset(); // Immediately recycle monster
      break;
    }
  }
}

class Monster {
  float x, y, size, baseY, offset, fallSpeed;

  Monster(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.baseY = y;
    this.size = size;
    this.offset = random(10);
    this.fallSpeed = random(0.3, 0.8);
  }

  void update() {
    baseY += fallSpeed;
    y = baseY + sin(offset + frameCount * 0.05) * 10;
  }

  void display() {
    imageMode(CENTER);
    image(eyeImg, x, y, size * 1.5, size);
  }

  void reset() {
    x = random(width);
    baseY = -random(100, 300);
    size = random(80, 150);
    offset = random(10);
    fallSpeed = random(0.3, 0.8);
  }

  boolean isClicked(float mx, float my) {
    float w = size * 1.5;
    float h = size;
    return dist(mx, my, x, y) < max(w, h) / 2;
  }
}

class Explosion {
  float x, y, size;
  int startTime;

  Explosion(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.startTime = millis();
  }

  boolean isDone() {
    return millis() - startTime > 700;
  }

  void display() {
    imageMode(CENTER);
    image(explosionImg, x, y, size*1.5, size*1.5);
  }
}









//done
