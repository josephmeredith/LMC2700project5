import java.util.ArrayList;

int canvasWidth = 1500;
int canvasHeight = 1000;
int gridWidth = 1000;
int gridHeight = 1000;
int difficulty = 200;
Timer startTimer;
PImage logo;
boolean modeCopy = false;
float score = 0;
float maxScore = gridWidth;
int filledBlockCount = 0;
float scoreDivision = 0;
boolean erased = false;
boolean playerSelect = false;

// Variables for welcome screen
int s = second();
int count = 0;
boolean welcomeScreen = true;

// Stored colors for each player
color player1color = #ba2644;
color player2color = #00bcb5;
color player3color = #b6c399;

// For testing purposes
color player4color = #9932CC;

color blockColor = player1color; // Current drawing color 

int player = 1;
int [][] filled = new int[gridWidth/difficulty][gridHeight/difficulty];
int [][] copyFilled = new int[gridWidth/difficulty][gridHeight/difficulty];



void settings() {
   size(canvasWidth, canvasHeight); 
}

void setup() {
  background(255);
  startTimer = new Timer(120);
  logo = loadImage("logo.jpg");
  logo.resize(300, 300);
}

void draw() {
  if (welcomeScreen) {
    Welcome();
  } else {
  System.out.println("Mouse X: " + mouseX + "Mouse Y: " + mouseY);
    if (modeCopy) {
      copyMode();
    } else {
      makerMode();
    }
  }
}

void makerMode(){
  // clears the background only once
  while (count < 1) {
    background(255);
    count++;
  }
  
  for (int i = 0; i < gridWidth; i += difficulty) {
      line(i, 0, i, gridHeight);
      line(0, i, gridWidth, i);
    }
    
  line(gridWidth, 0, gridWidth, gridHeight);
  image(logo, 1100, 50);
  textSize(30);
  fill(255);
  rect(1040, 930, 400, 100);
  fill(0);
  
  int mouseConstrainX = difficulty * Math.round(mouseX/difficulty);
  int mouseConstrainY = difficulty * Math.round(mouseY/difficulty);
  
  //control if spot has already been filled
  try {
  if (mousePressed && filled[mouseConstrainX/difficulty][mouseConstrainY/difficulty] == 0 ) {
    fill(blockColor);
    rect(mouseConstrainX, mouseConstrainY, difficulty, difficulty);
    filled[mouseConstrainX/difficulty][mouseConstrainY/difficulty] = player;
    
    //perhaps later with the 4th player we can compare their array to this array and calculate points based on that
  }
  } catch (Exception e) {
    // Prevents the game from crashing if clicked outside window
    System.out.println("Array is out of bounds");
  }
}

//this is a mode for player 4.
void copyMode() {
  if (!erased) { 
   background(255);
   erased = true;
   playerSelect = true;
  }
  if (playerSelect) {
    fill(player1color);
    rect(1100, 400, 100, 100);
    fill(player2color);
    rect(1100, 550, 100, 100); 
    fill(player3color);
    rect(1100, 700, 100, 100); 
    playerSelect = false;
  }  

  for (int i = 0; i < gridWidth; i += difficulty) {
      line(i, 0, i, gridHeight);
      line(0, i, gridWidth, i);
            
    }
  line(gridWidth, 0, gridWidth, gridHeight);
  image(logo, 1100, 50);
  startTimer.countDown();
  textSize(30);
  fill(255);
  rect(1040, 930, 400, 100);
  fill(#4c072c);
  text("Time Left: " + nf(startTimer.getTime(), 0, 2) + " seconds", 1050, 980);
  
  int mouseConstrainX = difficulty * Math.round(mouseX/difficulty);
  int mouseConstrainY = difficulty * Math.round(mouseY/difficulty);
  
  //control if spot has already been filled
  try {
  if (mousePressed && copyFilled[mouseConstrainX/difficulty][mouseConstrainY/difficulty] == 0 ) {
    fill(blockColor);
    rect(mouseConstrainX, mouseConstrainY, difficulty, difficulty);
    //currently only responing to reds, need to add way to have player 4 change colors
    copyFilled[mouseConstrainX/difficulty][mouseConstrainY/difficulty] = player;
    int X = mouseConstrainX/difficulty;
    int Y = mouseConstrainY/difficulty;
    scoreUpdate(X, Y);
  }
  } catch (Exception e){
    // Prevents the game from crashing if clicked outside window
    System.out.println("Array is out of bounds");
  }
}


void scoreUpdate(int x, int y){
  //if colors are the same
  if (copyFilled[x][y] == filled[x][y]) {
      score += scoreDivision;
    }
    //if they put a color where where should only be white space
  if ((copyFilled[x][y] != 0) && (filled[x][y]== 0))  {
      score -= scoreDivision;
    }
    //if they guess a wrong color but correct position
  if ((copyFilled[x][y] != 0) && (filled[x][y]!= 0) && !(copyFilled[x][y] == filled[x][y])){
    score += scoreDivision/2;
  }
  fill(255);
  rect(1040, 830, 400, 100);
  fill(0);
  text("Score: " + (int)score + " / " + (int)maxScore, 1050, 880);
  fill(#4c072c);
  textSize(60);
  text("Score: " + score, 1080, 900);  
}

void keyPressed() {
  if(key == ' ');
  player++;
  if (player == 2) {
    blockColor = player2color;
  }
  if (key == 'w')
  Welcome();
  if (key == 'g')
  GameOver();
  if (key == 'p')
  P4Turn();
  else if (player == 3) {
    blockColor = player3color;
  }
  else if (player > 3) {
    player = 1;
    blockColor = player1color;
    modeCopy = true;
    for (int i = 0; i < gridWidth/difficulty; i++) {
      for (int j = 0; j < gridHeight/difficulty; j++) {
        if (filled[i][j] != 0) {
          filledBlockCount ++;
        }
    }
  }
  //allow score to increase depending on amount of filled
  scoreDivision = maxScore/filledBlockCount;
  
 }
  
}

void mouseClicked() {
  if (welcomeScreen && mouseX >= width/2 - 250 && mouseY >= height - 150 
    && mouseX <= width/2 + 250 && mouseY <= height - 70) {
    welcomeScreen = false;
  }
   if (mouseX >= 1100 && mouseY >= 400 
     && mouseX <= 1200 && mouseY <= 500) {
    player = 1;
    blockColor = player1color;
   }
   else if (mouseX >= 1100 && mouseY >= 550 
     && mouseX <= 1200 && mouseY <= 650) {
     player = 2;
     blockColor = player2color;
   }
   else if (mouseX >= 1100 && mouseY >= 700
     && mouseX <= 1200 && mouseY <= 800) {
       player = 3;
       blockColor = player3color;
   }
}
