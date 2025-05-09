//Starting
// another
void setup() {
  size(500, 600);
  background(255);
  noStroke();
  
  drawMonopolyMan();
}

void drawMonopolyMan() {
  // Head
  fill(255, 224, 189);
  ellipse(250, 160, 100, 120); // face
  
  // Eyes
  fill(0);
  ellipse(235, 150, 5, 5);
  ellipse(265, 150, 5, 5);
  
  // Mustache
  stroke(0);
  strokeWeight(3);
  noFill();
  arc(235, 170, 30, 15, PI + QUARTER_PI, TWO_PI);
  arc(265, 170, 30, 15, PI, PI + HALF_PI);
  noStroke();
  
  // Hat - brim
  fill(0);
  rect(200, 95, 100, 20);
  // Hat - top
  fill(0, 200, 255);
  rect(215, 60, 70, 35);
  fill(120, 60, 180); // purple band
  rect(215, 90, 70, 10);

  // Bow tie
  fill(255, 0, 0);
  triangle(245, 190, 230, 205, 245, 205);
  triangle(255, 190, 270, 205, 255, 205);
  
  // Body (jacket)
  fill(0);
  rect(200, 220, 30, 100);
  rect(270, 220, 30, 100);
  
  // Shirt
  fill(255);
  rect(230, 220, 40, 100);
  fill(0);
  ellipse(250, 240, 5, 5);
  ellipse(250, 260, 5, 5);
  ellipse(250, 280, 5, 5);
  
  // Pants
  fill(150);
  rect(200, 320, 40, 100);
  rect(260, 320, 40, 100);
  
  // Shoes
  fill(0);
  ellipse(215, 420, 30, 20);
  ellipse(285, 420, 30, 20);
  
  // Cane
  stroke(160, 80, 20);
  strokeWeight(7);
  noFill();
  arc(310, 300, 30, 30, HALF_PI, PI);
}
