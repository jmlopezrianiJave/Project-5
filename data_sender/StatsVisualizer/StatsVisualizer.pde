import oscP5.*;
import netP5.*;

OscP5 oscP5;

float countVal;

float mathMean, mathStd, mathMin, mathMax;
float readMean, readStd, readMin, readMax;
float writeMean, writeStd, writeMin, writeMax;

void setup() {
  size(800, 600);
  frameRate(60);
  oscP5 = new OscP5(this, 5006);
}

void draw() {
  background(0);

  float normCount = constrain(countVal / 100f, 0, 1);

  float rCol = map(mathMean,   0, 100, 0, 255);
  float gCol = map(readMean,   0, 100, 0, 255);
  float bCol = map(writeMean,  0, 100, 0, 255);

  float moveSpeed = map(mathStd + readStd + writeStd, 0, 60, 0.01, 0.3);
  moveSpeed = max(0.01, moveSpeed);

  float maxStd = max(mathStd, max(readStd, writeStd));
  float jitterAmp = map(maxStd, 0, 30, 0, 100);

  float baseSize = map(normCount, 0, 1, 30, 250);

  float offsetX = sin(frameCount * moveSpeed) * jitterAmp;
  float offsetY = cos(frameCount * moveSpeed * 0.7) * jitterAmp;

  float cx = width / 2 + offsetX;
  float cy = height / 2 + offsetY;

  noStroke();
  fill(rCol, gCol, bCol, 200);
  ellipse(cx, cy, baseSize, baseSize);

  float avgMean = (mathMean + readMean + writeMean) / 3.0;

  if (avgMean >= 70) {
    float rectWidth = map(avgMean, 70, 100, 50, 200);
    float rectHeight = map(avgMean, 70, 100, 10, 80);
    float speed2 = map(writeStd, 0, 30, 0.02, 0.2);

    float x = (frameCount * speed2 * 50) % (width + rectWidth) - rectWidth;
    float y = height * 0.2;

    fill(255, 200, 0, 180);
    rect(x, y, rectWidth, rectHeight);
  } else {
    float size2 = map(avgMean, 0, 70, 10, 150);
    float speed2 = map(readStd, 0, 30, 0.01, 0.15);

    float x = width * 0.2;
    float y = height * 0.8 + sin(frameCount * speed2) * 60;

    fill(0, 200, 255, 180);
    ellipse(x, y, size2, size2);
  }

  fill(255);
  textSize(14);
  text("Count: " + int(countVal), 20, 20);
  text("Math mean/std: " + nf(mathMean, 1, 1) + " / " + nf(mathStd, 1, 1), 20, 40);
  text("Reading mean/std: " + nf(readMean, 1, 1) + " / " + nf(readStd, 1, 1), 20, 60);
  text("Writing mean/std: " + nf(writeMean, 1, 1) + " / " + nf(writeStd, 1, 1), 20, 80);
}

void oscEvent(OscMessage msg) {
  String addr = msg.addrPattern();

  if (addr.equals("/stats/count")) {
    countVal = msg.get(0).floatValue();
  } else if (addr.equals("/stats/math/mean")) {
    mathMean = msg.get(0).floatValue();
  } else if (addr.equals("/stats/math/std")) {
    mathStd = msg.get(0).floatValue();
  } else if (addr.equals("/stats/math/min")) {
    mathMin = msg.get(0).floatValue();
  } else if (addr.equals("/stats/math/max")) {
    mathMax = msg.get(0).floatValue();
  } else if (addr.equals("/stats/reading/mean")) {
    readMean = msg.get(0).floatValue();
  } else if (addr.equals("/stats/reading/std")) {
    readStd = msg.get(0).floatValue();
  } else if (addr.equals("/stats/reading/min")) {
    readMin = msg.get(0).floatValue();
  } else if (addr.equals("/stats/reading/max")) {
    readMax = msg.get(0).floatValue();
  } else if (addr.equals("/stats/writing/mean")) {
    writeMean = msg.get(0).floatValue();
  } else if (addr.equals("/stats/writing/std")) {
    writeStd = msg.get(0).floatValue();
  } else if (addr.equals("/stats/writing/min")) {
    writeMin = msg.get(0).floatValue();
  } else if (addr.equals("/stats/writing/max")) {
    writeMax = msg.get(0).floatValue();
  }
}
