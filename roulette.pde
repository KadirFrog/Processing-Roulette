/* imports */
import java.util.Random;
import java.util.Arrays;
import java.util.List;

/* tunable vars */
int r_len = 36;
int fr = 10;
double slow_factor = 0.001;
double starting_angle = 5;

/* global vars */
boolean rolld = false;
int g;
double da = 0;
double das;
boolean rolling = false;
int buttonWidth = 200;
int buttonHeight = 100;
Random random = new Random();
int min = 100;
int max = 200;
int rollDuration = 50;
public final List<Integer> BLACK_NUMBERS = Arrays.asList(
    2, 4, 6, 8, 10, 11, 13, 15, 17,
    20, 22, 24, 26, 28, 29, 31, 33, 35
);
public final List<Integer> RED_NUMBERS = Arrays.asList(
    1, 3, 5, 7, 9, 12, 14, 16, 18,
    19, 21, 23, 25, 27, 30, 32, 34, 36
);
int r_b, r_r;

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

int getLineColor(int index, int gamble) {
  if (rolling) {
  return ((index) % 2 == 0) ? color(255, 0, 0) : color(0, 0, 255);
  }
  return ((index + gamble) % 2 == 0) ? color(255, 0, 0) : color(0, 0, 255);
}

void draw() {
  cc();
  
  rollDuration = random.nextInt(max - min + 1) + min;
  if (rolling) {
    rolld = true;
    g = random.nextInt(1 - 0 + 1) + 0;
    r_b = BLACK_NUMBERS.get(random.nextInt(BLACK_NUMBERS.size()));
    r_r = RED_NUMBERS.get(random.nextInt(RED_NUMBERS.size()));
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
      stroke(getLineColor(c, g));
      pline(l1[c], l1[c + 1]);
      pline(l2[c], l2[c + 1]);
    } else {
      stroke(getLineColor(c, g));
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
  }
}


void drawButton() {
  fill(200);
  rect((width - buttonWidth) / 2, height - buttonHeight, buttonWidth, buttonHeight);
  fill(0);
  textSize(20);
  textAlign(CENTER, CENTER);
  String text = "Roll Roulette";
  if (rolld) {
  text = ((g == 1) ? "Blue wins: " + r_b : "Red wins: " + r_r);
  }
  text(text, width / 2, height - buttonHeight / 2);
}

 void drawTriangle() {
 triangle(490, 340, 510, 340, 500, 360);
 }
