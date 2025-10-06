// Dice.pde

ArrayList<Die> dice = new ArrayList<Die>();
int total = 0;

void setup() {
  size(800, 600);
  noStroke();
  textAlign(CENTER, CENTER);
  textSize(24);
  createDiceFace();
}

void draw() {
  background(30);
  total = 0;

  // Update and display all dice
  for (Die d : dice) {
    d.updateColor();
    d.show();
    total += d.value;
  }

  fill(255);
 // text("Total: " + total + "   |   Dice: " + dice.size(), width / 2, height - 40);
  text("Click to reset!", width / 2, 40);
}

void mousePressed() {
  // Reroll and reset colors for all dice
  for (Die d : dice) {
    d.resetColor();
    d.roll();
  }
}

// Create spiral dice
void createDiceFace() {
  dice.clear();

  float centerX1 = width / 2 - 150;
  float centerX2 = width / 2 + 150;
  float centerY = height / 2 - 70;
  float angleStep = 0.35;
  float rStep = 6;

  // Two spirals
  for (float a = 1.0; a < TWO_PI * 5; a += angleStep) {
    float r = a * rStep;
    float x1 = centerX1 + cos(a) * r;
    float y1 = centerY + sin(a) * r;
    float x2 = centerX2 + cos(a) * r;
    float y2 = centerY + sin(a) * r;
    dice.add(new Die(x1, y1, 20));
    dice.add(new Die(x2, y2, 20));
  }

  // Bottom curve
  for (float a = PI / 6; a < 5 * PI / 6; a += 0.12) {
    float x = width / 2 + cos(a) * 200;
    float y = height / 2 + sin(a) * 160 + 60;
    dice.add(new Die(x, y, 20));
  }
}

// Die class
class Die {
  float x, y;
  int value;
  float size;
  color currentColor;

  float rPhase, gPhase, bPhase;
  float rSpeed, gSpeed, bSpeed;

  Die(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;

    // Initialize dice value using Math.random()
    value = (int) (Math.floor(Math.random() * 6) + 1);

    // RGB phases
    rPhase = (float)(Math.random() * TWO_PI);
    gPhase = (float)(Math.random() * TWO_PI);
    bPhase = (float)(Math.random() * TWO_PI);

    // RGB speeds
    rSpeed = 0.01 + (float)Math.random() * 0.02;
    gSpeed = 0.01 + (float)Math.random() * 0.02;
    bSpeed = 0.01 + (float)Math.random() * 0.02;

    currentColor = color(255);
  }

  void roll() {
    value = (int) (Math.floor(Math.random() * 6) + 1);
  }

  void resetColor() {
    rPhase = (float)(Math.random() * TWO_PI);
    gPhase = (float)(Math.random() * TWO_PI);
    bPhase = (float)(Math.random() * TWO_PI);
  }

  void updateColor() {
    float r = 128 + 127 * sin(rPhase);
    float g = 128 + 127 * sin(gPhase);
    float b = 128 + 127 * sin(bPhase);

    currentColor = color(constrain(r, 0, 255),
                         constrain(g, 0, 255),
                         constrain(b, 0, 255));

    rPhase += rSpeed;
    gPhase += gSpeed;
    bPhase += bSpeed;
  }

  void show() {
    fill(currentColor);
    stroke(0);
    strokeWeight(1);
    rectMode(CENTER);
    rect(x, y, size, size, 4);

    fill(255); // pips
    float d = size / 4;
    if (value == 1 || value == 3 || value == 5) ellipse(x, y, size/6, size/6);
    if (value >= 2) { 
      ellipse(x - d, y - d, size/6, size/6); 
      ellipse(x + d, y + d, size/6, size/6);
    }
    if (value >= 4) { 
      ellipse(x + d, y - d, size/6, size/6); 
      ellipse(x - d, y + d, size/6, size/6);
    }
    if (value == 6) { 
      ellipse(x - d, y, size/6, size/6); 
      ellipse(x + d, y, size/6, size/6);
    }
  }
}
