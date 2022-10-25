//Project 3: Pong
//Lena Lanza 3/13/22
//Directory ID: lmlanza
//Unviersity ID: 118448534
//I pledge on my honor that I have not given or received any unauthorized assistance on this assignment/examination.
String gamePhase;
Ball ball;
Paddle L;
Paddle R;
int player1lives; 
int player2lives;

void setup() {
  size(800, 600);
  noStroke();
  fill(255, 102);
 //Initating to start the game
  gamePhase = "START";
 //How fast the ball will bounce
  frameRate(80);
  ball = new Ball();
 //Paddle L (player 1) ; Paddle R (player 2)
  L = new Paddle(false);
  R = new Paddle(true);
}

void draw() {
  background(0);
  // Game phases of pong game
  if (gamePhase == "START") {
    gameStart();
   } else if (gamePhase == "PLAY") {
    gamePlay();
  } else if (gamePhase == "GAME OVER") {
    gameGameover();
  }
 }
void gameStart() {
 //Start Screen
  fill(255);
  PFont f = createFont("Georgia", 64);
  String s = "START GAME\n Press 't' or 'T' to Play";
  textAlign(CENTER);
  textFont(f);
  textSize(54);
  text(s, width/2, height/2);
  //Initiating game
  if (key =='t'||key=='T') {
    gamePhase="PLAY";
    player1lives = 5;
    player2lives = 5;
 }
}
void gamePlay(){
  background(0);
  //Class Ball voids
  ball.drawBalls();
  ball.boundaries();
  ball.paddleOne(L);
  ball.paddleTwo(R);
  ball.outcome();
  //Class Paddle voids
  L.drawPaddles();
  L.outcome();
  R.drawPaddles();
  R.outcome();
  //Pong Scoreboard
  scoreBoard();
  //Clears game appearance in the background
  if ((player2lives == 0) ||player1lives == 0){
    gamePhase = "GAME OVER";
  }
}
class Paddle {
  float x;
  float y = height/2;
  float w = 20;
  float h = 100;
  float dx;
  float dy;
  
  void drawPaddles() {
    fill(255);
   //Paddle 1 (Left)
     rectMode(CENTER);
     rect(x, y, w, h);
   //Paddle 2 (Right)
     rectMode(CENTER);
     rect(x, y, w, h);
  }
  void motion(float stopmotion) {
  //When the desgniated keys are released the speed of the paddles will stop until pressed again
    dx = stopmotion;
    dy = stopmotion;
 }
  void outcome() {
   //Limits both paddles from over stepping the top and bottom boundaries
     y = constrain(y, 70, 527);
   //Velocity of both paddles (there is no x = x + dx because it will move diagonally instead of up and down)
     y = y + dy;
  }

  Paddle(boolean right) {
    if (right) { //Paddle player 1 x-axis position
      x = -w + (width);
    } else { //Paddle player 2 x-axis position
      x = w;
    }
  }
} 
class Ball {
  int numsBalls = 20;
  float X[] = new float[numsBalls];
  float Y[] = new float[numsBalls];
  float x = width/2;
  float y = height/2;
  float w = 20;
  float h = 20;
  float dx;
  float dy;
  float p;
  Ball() {
    reset();
  }
  void drawBalls() {
    //Balls being created, moving to the right
      for (int i= numsBalls-1; i>0; i=i-1) {
        X[i]=X[i-1];
        Y[i]=Y[i-1] ;
      }
        X[0] = x;
        Y[0] = y;
   //As the main ball moves there are other balls with smaller radius' being added on, creating a trail
      for (int i=0; i< numsBalls; i++) {
       //Draw balls
        noStroke();
        fill(255, 150-i*3);
        ellipse(X[i], Y[i], w-i, h-i);
      }
    }
    
  void paddleOne(Paddle player1) {
  //Ball collision with Player 1 Paddle
   if (x - w/2 < player1.x + player1.w/2) { //Ball hits the side of paddle 1
    if (y + h/2 > player1.y - player1.h/2){ //Ball hits the top of paddle 1
     if (y - h/2 < player1.y + player1.h/2){ //Ball hits the bottom of paddle 1
      if (player1.x < x){
       p = map(player1.h/2 - player1.y  + y, 0, player1.h, 0, radians(100));
       //Assures the ball will bounce freely on the canvas
        dy= sin(p) * -4;
        dx= cos(p) *  4;
       //Bounces off paddle 1 without attaching to it
        x = w/2 + player1.x + player1.w/2;
      }
     }
    }
   }
  }
 void paddleTwo(Paddle player2) {
  //Ball collision with player 2 Paddle
   if (x + w/2 > player2.x - player2.w/2) { //Ball hits the side of paddle 2
    if (y + h/2 > player2.y - player2.h/2){ //Ball hits the top of paddle 2
     if (y - h/2 < player2.y + player2.h/2){ //Ball hits the bottom of paddle 2
      if (player2.x > x) {
       p = map(player2.h/2 - player2.y  + y, 0, player2.h, radians(200), radians(100));
       //Assures the ball will bounce freely on the canvas
       dy= sin(p) * -4;
       dx= cos(p) *  4;
       //Bounces off paddle 2 without attaching to it
        x = -w/2 + player2.x - player2.w/2;
      }
     }
    }
   }
  }  
  void reset() {
   //Resets x speed of ball to either 4 or -4
     if (random(1) < 0.5) {
        dx = 4; 
       }
     if (random(1) < 0.5) {
        dx = -4 ;
      }
   //Resets y speed of ball
     if (random(1) < 0.5) {
       dy = random(-10, -3);
     }
     if (random(1) < 0.5) {
       dy = random(3, 10) ;
      }
 }
 
  void boundaries() {
   //Bottom boundary of Canvas
     if (y + 19 > height - h ) {
       dy = -dy;
      }
   //Top Boundary of Canvas
     if (y < h + 18) {
       dy = -dy;
      }
   //Right Side of Canvas
     if (x - w/2 > width) {
       player2lives = player2lives - 1;
       x = 760;
       y = height/2;
       dx = 0;
       dy = 0;
     }
   //Left Side of Canvas
     if (x + w/2 < 0) {
       player1lives = player1lives -1;
       x = 40;
       y = height/2;
       dx = 0;
       dy = 0;
     }
   }
  void outcome() {
    //Velocity of ball
      x = x + dx;
      y = y + dy;
    //Player 1 Loses
     if (player1lives == 0) {
        gameGameover();
      }
    //Player 2 Loses
     if (player2lives == 0) {
        gameGameover();
      }
    } 
  }
void scoreBoard() {
  stroke(255);
  //Player 1 Score Displayed
   line(0, 19, 800, 19); //Top Line Barrier
   textAlign(LEFT);
   fill(255);
   textSize(18);
   text("PLAYER ONE LIVES:", 18, 16);
   text(player1lives, 198, 14);
  //Player 2 Score Displayed
   line(0, 578, 800, 578); //Bottom Line Barrier
   text("PLAYER TWO LIVES:", 590, 594);
   text(player2lives, 772, 591);
}

void keyPressed() {
  if (key == 'w') { //Player 1's paddle moving up
    L.motion(-7);
  } else if (key == 's') { //Player 1's paddle moving down
    L.motion(7);
  }

  if (key == 'i') { //Player 2's paddle moving up
    R.motion(-7);
  } else if (key == 'k') { //Player 2's paddle moving down
    R.motion(7);
  }
  if (key == 'c'){
    ball.reset();
  }
}
void keyReleased() {
 //Player 1's paddle stops when key is released
   L.motion(0); 
 //Player 2's paddle stops when key is released
   R.motion(0); 
}
void gameGameover() {
  //"Player 1 Won" is displayed
  if (player1lives == 0) {
    fill(255);
    textAlign(CENTER);
    PFont f = createFont("Georgia", 64);
    textFont(f);
    textSize(45);
    text("Game Over\nPlayer 2 Won!\n Press 'n' to try again", width/2, height/2);
  }
  //Game Over, restarting game
  if ((player1lives == 0) && (key =='n')) {
    gamePhase="START";
  }
  //"Player 2 Won" is displayed
  if (player2lives == 0) {
    fill(255);
    textAlign(CENTER);
    PFont f = createFont("Georgia", 64);
    textFont(f);
    textSize(54);
    text("Game Over\nPlayer 1 Won!\n Press 'n' to try again", width/2, height/2);
  }
 //Game Over, restarting game
  if ((player2lives == 0) && (key =='n')) {
   gamePhase="START";
  }
 //If n is pressed then the game is moved to the start phase
  if(key =='n'){
    fill(0);
    rect(0,0,width,height);
    gamePhase="START";
  }
}
