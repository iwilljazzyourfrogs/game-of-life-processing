int[][] grid;

int birthNumber;
int minNeighbors;
int maxNeighbors;

int neighborRadius;

boolean rand = false;
boolean randInRad = true;
boolean fuzz = false;

boolean rendering = true;

void setup() {
  size(600, 600);
  float rad = 0.01;
  float fuzzSize = 0.2;
  
  int[] conway = {3, 2, 3, 1};
  
  int[] preset0 = {3, 1, 5, 1}; //slime mould thing
  int[] preset1 = {1, 1, 9, 1}; //fractal square thing
  int[] preset2 = {2, 1, 9, 1}; //ice crystal thing
  int[] preset3 = {1, 4, 6, 1}; //flickery greeble thing
  int[] preset4 = {1, 9, 9, 1}; //skwer
  int[] preset5 = {4, 1, 5, 1}; //circle maze
  int[] preset6 = {8, 1, 3, 2}; //lines
  int[] preset7 = {3, 4, 8, 1}; //fuzzy
  
  int[] currentPreset = preset2;
  birthNumber = currentPreset[0];
  minNeighbors = currentPreset[1];
  maxNeighbors = currentPreset[2];
  neighborRadius = currentPreset[3];
  
  if (rand) {
    neighborRadius = 1;
    birthNumber = floor(random(1, 10));
    minNeighbors = floor(random(1, 10));
    maxNeighbors = floor(random(minNeighbors, 10));
    println(birthNumber, minNeighbors, maxNeighbors, neighborRadius);
  }
  grid = new int[width][height];
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      if (rad == 0) {
        if (i == width / 2 && j == height / 2) {
          grid[i][j] = 1;
        } else {
          grid[i][j] = 0;
        }
      } else {
        float d = (dist(i, j, width / 2, height / 2) / (dist(0, min(width, height) / 2, width / 2, height / 2)));
        if (fuzz) {
          d += random(-fuzzSize, fuzzSize);
        }
        if (d < rad) {
          if (randInRad) {
            grid[i][j] = floor(random(2));
          } else {
            grid[i][j] = 1;
          }
        } else {
          grid[i][j] = 0;
        }
      }
    }
  }
}

void mousePressed() {
  noLoop();
}

void keyPressed() {
  noLoop();
}

void draw() {
  background(255);
  loadPixels();
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int index = i + j * width;
      if (grid[i][j] == 1) {
        pixels[index] = color(255);
      } else {
        pixels[index] = color(0);
      }
    }
  }
  updatePixels();
  
  int[][] next = new int[width][height];
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      int neighbors = countNeighbors(grid, i, j);
      int state = grid[i][j];
      if (state == 0 && neighbors == birthNumber) {
        next[i][j] = 1;
      } else if (state == 1 && (neighbors < minNeighbors || neighbors > maxNeighbors)) {
        next[i][j] = 0;
      } else {
        next[i][j] = state;
      }
    }
  }
  grid = next;
  if (rendering) {
    saveFrame("frames/frame_####.png");
    fill(0, 255, 0);
    square(0, 0, 20);
    fill(255, 0, 0);
    circle(10, 10, 10);
  }
}

int countNeighbors(int[][] grid, int x, int y) {  
  int count = 0;
  for (int i = -neighborRadius; i <= neighborRadius; i++) {
    for (int j = -neighborRadius; j <= neighborRadius; j++) {
      int newX = (x + i + width) % width;
      int newY = (y + j + height) % height;
      count += grid[newX][newY];
    }
  }
  count -= grid[x][y];
  return count;
}
