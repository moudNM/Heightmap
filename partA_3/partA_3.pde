/*
Student Name: Nur Muhammad Bin Khameed
 SRN: 160269044
 CO3355 Advanced Graphics and Animation CW1
 Part A, Question 3
 
 Instructions:
 Press 'w' key for top view or 's' for front view (elevated)
 
 Change the scale factor variable to increase/decrease level of detail
 */

import peasy.*;

//heightMap size, number of peaks
int heightMapSizeX;
int heightMapSizeY;
float heightMap[][];

float spacing = 20.0; // Use this variable to set the spacing between heightmap elements
PeasyCam cam;
float startXY,startXY2;
PShape shape;
int camPos; //camera modes

void setup()
{
  size(960, 720, P3D);  

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(50);
  cam.setMaximumDistance(500);

  //Generate HeightMap (default heightmap size is 1/40 of x and y pixel size of image
  // i.e. heightMap[imagewidth/40][imageheight/40];
  generateHeightMap("GreyscaleImage.jpg");
  
  //Generate HeightMap with scale factor
  // i.e. heightMap[factor*imagewidth/40][factor*imageheight/40];
  //generateHeightMap("GreyscaleImage.jpg",1.5); 
  
  print(heightMap.length,heightMap[0].length);
  
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

void generateHeightMap(String img) {
  generateHeightMap(img,1.0);
}

//generate heightmap based on image pixel values
void generateHeightMap(String img, float scale) {

  PImage myImage = loadImage(img);

  heightMapSizeX = myImage.width/40;
  heightMapSizeX = int(heightMapSizeX*scale);
  heightMapSizeY = myImage.height/40;
  heightMapSizeY = int(heightMapSizeY*scale);
  
  heightMap = new float[heightMapSizeX][heightMapSizeY];
  startXY = (heightMap.length * spacing)/2;    // This is to recentre the heightmap
  startXY2 = (heightMap[0].length * spacing)/2;    // This is to recentre the heightmap

  float widthSampleSize = float(myImage.width) / float(this.heightMap.length);
  float heightSampleSize = float(myImage.height)/ float(this.heightMap[0].length);

  //Set values for height map based on pixel color
  for (int x=0; x<this.heightMap.length; x++) {
    for (int y=0; y<this.heightMap[x].length; y++) {
      color c = myImage.get(int(widthSampleSize*x), int(heightSampleSize*y));
      //rgb values in grayscale is all the same. So just use any one of them.
      this.heightMap[x][this.heightMap[x].length-1-y] = 1.5*red(c);
    }
  }
}


//this lets user switch between top view and elevated front view
void keyReleased() {
  if (key == 's') {
    cam = new PeasyCam(this, 100);
    camPos = 0;
  } else if (key == 'w') {
    cam = new PeasyCam(this, 100);
    camPos = 1;
  }
}

//switches the view
void cameraPosition(int camPos) {
  switch(camPos) {
  case 0:
    rotateX(-PI/4);
    translate(-startXY, 3*startXY/2, -startXY2);
    break;
  case 1:
    rotateX(-PI/2);
    translate(-startXY, startXY*2, startXY2);
    break;
  }
}
