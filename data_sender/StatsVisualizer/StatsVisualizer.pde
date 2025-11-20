import oscP5.*;
import netP5.*;

OscP5 oscP5;

float countVal;
float mathMean, mathStd, mathMin, mathMax;
float readMean, readStd, readMin, readMax;
float writeMean, writeStd, writeMin, writeMax;

int lastUpdateFrame = 0;
int localCount = 0;

void setup() {
  size(800, 600);
  frameRate(60);
  oscP5 = new OscP5(this, 5005);
  background(0);
}

void draw() {
  int delta = frameCount - lastUpdateFrame;
  float phase = constrain(delta / 60.0, 0, 1);

  float bgR = map(mathMean, 0, 100, 0, 255);
  float bgG = map(readMean, 0, 100, 0, 255);
  float bgB = map(writeMean, 0, 100, 0, 255);
  background(bgR * phase, bgG * phase, bgB * phase);

  float normCount = constrain(countVal / 100f, 0, 1);

  float maxStd = max(mathStd, max(readStd, writeStd));
  float moveSpeed = map(maxStd, 0, 30, 0.02, 0.25);
  float jitterAmp = map(maxStd, 0, 30, 0, 120);

  float baseSize = map(normCount, 0, 1, 40, 260);

  float t = delta;
  float offsetX = sin(t * moveSpeed) * jitterAmp;
  float offsetY = cos(t * moveSpeed * 0.7) * jitterAmp;

  float cx = width / 2 + offsetX;
  float cy = height / 2 + offsetY;

  noStroke();
  fill(bgR, bgG, bgB, 220);
  ellipse(cx, cy, baseSize, baseSize);

  float mathRadius = map(mathMean, 0, 100, 40, 200);
  float readRadius = map(readMean, 0, 100, 40, 200);
  float writeRadius = map(writeMean, 0, 100, 40, 200);

  float mathSize = map(mathStd, 0, 30, 10, 80);
  float readSize = map(readStd, 0, 30, 10, 80);
  float writeSize = map(writeStd, 0, 30, 10, 80);

  float angBase = t * moveSpeed;

  float angMath = angBase;
  float angRead = angBase * 1.3;
  float angWrite = angBase * 1.7;

  float mx = cx + cos(angMath) * mathRadius;
  float my = cy + sin(angMath) * mathRadius;
  float rx = cx + cos(angRead) * readRadius;
  float ry = cy + sin(angRead) * readRadius;
  float wx = cx + cos(angWrite) * writeRadius;
  float wy = cy + sin(angWrite) * writeRadius;

  fill(255, 80, 80, 230);
  ellipse(mx, my, mathSize, mathSize);

  fill(80, 255, 80, 230);
  ellipse(rx, ry, readSize, readSize);

  fill(80, 80, 255, 230);
  ellipse(wx, wy, writeSize, writeSize);

  float avgMean = (mathMean + readMean + writeMean) / 3.0;
  float barWidth = width * 0.6;
  float barHeight = 20;
  float barX = width * 0.2;
  float barY = height * 0.85;

  float fillFrac = avgMean / 100.0;

  stroke(255);
  noFill();
  rect(barX, barY, barWidth, barHeight);

  noStroke();
  fill(255, 220, 0, 230);
  rect(barX, barY, barWidth * fillFrac, barHeight);

  fill(255);
  textSize(14);
  text("Count: " + int(countVal), 20, 24);
  text("Math mean/std: " + nf(mathMean, 1, 1) + " / " + nf(mathStd, 1, 1), 20, 44);
  text("Reading mean/std: " + nf(readMean, 1, 1) + " / " + nf(readStd, 1, 1), 20, 64);
  text("Writing mean/std: " + nf(writeMean, 1, 1) + " / " + nf(writeStd, 1, 1), 20, 84);
}

void oscEvent(OscMessage msg) {
  String addr = msg.addrPattern();

  if (addr.startsWith("/stats/")) {
    lastUpdateFrame = frameCount;
  }

  if (addr.equals("/stats/math/mean")) {
    mathMean = msg.get(0).floatValue();
    localCount++;
    countVal = localCount;
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
