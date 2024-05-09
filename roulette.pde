/* tunable vars */
int r_len = 36;
int fr = 10;
double slow_factor = 0.001;
double starting_angle = 5;

/* global vars */
double da = 0;
double das;
boolean rolling = false;
int buttonWidth = 200;
int buttonHeight = 100;

/* temp vars */
int rollDuration = 50;

public class Pos {
  public double x, y;
  public Pos(double x, double y) {
  this.x = x;
  this.y = y;
  }
  public void set(double x, double y) {
  this.x = x;
  this.y = y;
  }
}

Pos[] circle_coords(double m_x, double m_y, double r, int r_len, double ao) {
  Pos[] ans = new Pos[r_len];
  double angleIncrement = 2 * Math.PI / r_len;
  for (int i = 0; i < r_len; i++) {
    double angle = i * angleIncrement + ao; 
    double x = m_x + r * Math.cos(angle);
    double y = m_y + r * Math.sin(angle);
    ans[i] = new Pos(x, y);
  }
  return ans;
}


void pcircle(Pos m, double r) {
circle((float) m.x, (float) m.y, (float) r);
}

void pline(Pos p1, Pos p2) {
line((float) p1.x, (float) p1.y, (float) p2.x, (float) p2.y);
}

void cc() {
background(255);
}

void setup() {
  size(1000, 1000);
  frameRate(fr);
  cc();
  das = 360.0 / fr;
  strokeWeight(3);
}

int getLineColor(int index) {
  return (index % 2 == 0) ? color(255, 0, 0) : color(0, 0, 255);
}

void draw() {
  cc();
  if (rolling) {
    rollRoulette();
  } else {
      drawButton();
    drawRoulette(starting_angle);
  }
}


void rollRoulette() {
  double angleIncrement = das * (360.0 / fr);
  double totalAngle = angleIncrement * frameCount + starting_angle;
  drawRoulette(totalAngle);
  if (frameCount >= rollDuration) {
    rolling = false;
    frameCount = 0;
  }
  frameCount++;
}

void drawRoulette(double angle) {
  Pos[] l1 = circle_coords(500, 500, 100, r_len, angle);
  Pos[] l2 = circle_coords(500, 500, 150, r_len, angle);
  
  for (int c = 0; c < r_len; c++) {
    stroke(color(0, 0, 0));
    pline(l1[c], l2[c]);
    if (c != r_len - 1) {
      stroke(getLineColor(c));
      pline(l1[c], l1[c + 1]);
      pline(l2[c], l2[c + 1]);
    } else {
      stroke(getLineColor(c));
      pline(l1[0], l1[c]);
      pline(l2[0], l2[c]);
    }
  }
    drawTriangle();
}


void mousePressed() {
  if (mouseX > (width - buttonWidth) / 2 && mouseX < (width + buttonWidth) / 2 &&
      mouseY > height - buttonHeight && mouseY < height) {
    rolling = true;
    println("Rolling Roulette...");
  }
}


void drawButton() {
  fill(200);
  rect((width - buttonWidth) / 2, height - buttonHeight, buttonWidth, buttonHeight);
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Roll Roulette", width / 2, height - buttonHeight / 2);
}

 void drawTriangle() {
 triangle(490, 340, 510, 340, 500, 360);
 }
