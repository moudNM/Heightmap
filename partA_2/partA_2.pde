/*
Student Name: Nur Muhammad Bin Khameed
 SRN: 160269044
 CO3355 Advanced Graphics and Animation CW1
 Part A, Question 2
 
 Instructions:
 Press 'w' key for top view or 's' for front view (elevated)
 
 Press Up key to increase number of peaks by 1
 Press Down key to decrease number of peaks by 1
 */

import peasy.*;

//Set heightMap size, number of peaks
int heightMapSize = 30;
int noOfPeaks = 30;
float heightMap[][]= new float[heightMapSize][heightMapSize];

//processing does not have array of arrays, 
//instead use custom peak class that holds 2 values
ArrayList<peak> peaks = new ArrayList<peak>();

float spacing = 20.0; // Use this variable to set the spacing between heightmap elements
PeasyCam cam;
float startXY;
PShape shape;
int camPos; //camera modes

void setup()
{
  size(640, 480, P3D);  

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);
  startXY = (heightMap.length * spacing)/2;    // This is to recentre the heightmap
  
  //Generate HeightMap
  generateHeightMap(noOfPeaks);
}


void draw()
{
  background(255);
  //controls camera position
  cameraPosition(camPos);

  //This will draw the shape
  shape = createShape();
  shape.beginShape(QUAD);
  for (int x=1; x<heightMap.length; x++) {
    for (int y=1; y<heightMap[x].length; y++) {

      //This will ensure that the sides touch each other, resulting in a quad mesh
      shape.vertex(spacing*(x), -heightMap[x-1][y-1], -spacing*(y));
      shape.vertex(spacing*(x)+spacing, -heightMap[x][y-1], -spacing*(y));
      shape.vertex(spacing*(x)+spacing, -heightMap[x][y], -spacing*(y)-spacing);
      shape.vertex(spacing*(x), -heightMap[x-1][y], -spacing*(y)-spacing);
    }
  }
  shape.endShape();
  shape(shape);
}

//generate random integer
int randomInt(int max) {
  float i = random(max);
  return int(i);
}

//generate random float
float randomFloat() {
  float f = random(0.0, 20.0);
  return f;
}

//generate random float for peak
float randomFloatPeak() {
  float f = random(60.0, 90.0);
  return f;
}

//generate height map with peaks
void generateHeightMap(int noOfPeaks) {

  //Set random values for height map
  for (int x=0; x<this.heightMap.length; x++) {
    for (int y=0; y<this.heightMap[x].length; y++) {
      this.heightMap[x][y] = randomFloat();
    }
  }

  //keep adding a random peak until it satisfies amount
  while (this.peaks.size()<noOfPeaks) {
    createPeak();
  }
}

//creates a peak
void createPeak() {
  int randomX = randomInt(heightMapSize);
  int randomY = randomInt(heightMapSize);

  boolean peakExists = false;

  //check if peak exists for heightmap[randomX,randomY]
  for (peak p : this.peaks) {
    if (p.is(randomX, randomY)) {
      peakExists = true;
      break;
    }
  }

  //if peak does not exist, create peak
  if (!peakExists) {
    this.heightMap[randomX][randomY] = randomFloatPeak();
    this.peaks.add(new peak(randomX, randomY));
  }
}

//removes a peak
void decreasePeak() {

  int noOfPeaks = this.peaks.size();

  if (noOfPeaks>0) {
    //get random element in arraylist
    int randomPos = randomInt(noOfPeaks);
    peak p = this.peaks.get(randomPos);

    //remove the peak
    this.heightMap[p.x][p.y] = randomFloat();
    this.peaks.remove(randomPos);
  }
}

//adds a peak
void increasePeak() {
  if (noOfPeaks<(heightMap.length *heightMap[0].length)) {
    createPeak();
  }
}

//up to add, down to decrease by 1 peak
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      increasePeak();
    } else if (keyCode == DOWN) {
      decreasePeak();
    }
  }
  //this lets user switch between top view and elevated front view
  if (key == 's') {
    cam = new PeasyCam(this, 100);
    camPos = 0;
  } else if (key == 'w') {
    cam = new PeasyCam(this, 100);
    camPos = 1;
  }
}

//custom class to monitor number of peaks
class peak {
  int x, y;
  peak(int x, int y) {
    this.x = x;
    this.y = y;
  }

  boolean is(int x, int y) {
    if (this.x == x && this.y == y) {
      return true;
    }  
    return false;
  }
}

//switches the view
void cameraPosition(int camPos) {
  switch(camPos) {
  case 0:
    rotateX(-PI/4);
    translate(-startXY, 3*startXY/2, -startXY/2);
    break;
  case 1:
    rotateX(-PI/2);
    translate(-startXY, startXY*2, startXY);
    break;
  }
}
