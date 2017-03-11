#include <Servo.h>


#define DROITE       'd'
#define GAUCHE       'g'
#define HAUT         'h'
#define BAS          'b'
#define HAUT_DROITE  'p'
#define HAUT_GAUCHE  'a'
#define BAS_DROITE   'n'
#define BAS_GAUCHE   'w'
#define CENTER       'c'
#define SERVO_Y      9
#define SERVO_X      8
#define MILIEU       90
#define MIN_X        10
#define MAX_X        170
#define MIN_Y        40
#define MAX_Y        150
#define SPEED        20
#define SLEEP        300

char message;

Servo servo_x;
Servo servo_y;

int pos_x;
int pos_y;

void setup() {
  
  message = ' ';  
  pinMode(LED_BUILTIN, OUTPUT);
  pos_x = MILIEU;
  pos_y = MILIEU;
  init_servo();
  Serial.begin(9600);
  Serial.print("Lancement du programme !");
  delay(1000);
}

void loop() {
  if (Serial.available())  {
    message = Serial.read();  // on soustrait le caractère 0, qui vaut 48 en ASCII
   
    switch (message) 
    {
      case GAUCHE:
        //Tourner à gauche
        Serial.println("GAUCHE");
        turn(SPEED, GAUCHE, servo_x);
      break;
      case DROITE:
        //Tourner à droite
        Serial.println("DROITE");
        turn(-SPEED, DROITE, servo_x);
      break;
      case HAUT:
        //Tourner vers le haut
        Serial.println("HAUT");
        turn(SPEED, HAUT, servo_y);
      break;
      case BAS:
        //Tourner vers le BAS
        Serial.println("BAS");
        turn(-SPEED, BAS, servo_y);
      break;
      case HAUT_GAUCHE:
        //Tourner à gauche
        Serial.println("HAUT-GAUCHE");
        turnDiag(SPEED, HAUT_GAUCHE, servo_x, servo_y);
      break;
      case HAUT_DROITE:
        //Tourner à droite
        Serial.println("HAUT-DROITE");
        turnDiag(SPEED, HAUT_DROITE, servo_x, servo_y);
      break;
      case BAS_DROITE:
        //Tourner vers le haut
        Serial.println("BAS-DROITE");
        turnDiag(SPEED, BAS_DROITE, servo_x, servo_y);
      break;
      case BAS_GAUCHE:
        //Tourner vers le BAS
        Serial.println("BAS-GAUCHE");
        turnDiag(SPEED, BAS_GAUCHE, servo_x, servo_y);
      break;
      case CENTER:
        //Tourner vers le CENTER
        Serial.println("CENTER");
        center();
      break;
    }
  }
  delay(100);
}

void turn(int value,char Direction, Servo servo)
{
  switch(Direction)
  {
    case GAUCHE:
      if (pos_x + value <=  MAX_X){
        Serial.println("GO GAUCHE");
        pos_x+=value;
        Serial.println(pos_x);
        servo.attach(SERVO_X);
        servo.write(pos_x);
        delay(200);
        servo.detach();
      } else {
        Serial.println("Limite GAUCHE atteinte.");
      }
        break;
    case DROITE:    
      if (pos_x + value >=  MIN_X){
        Serial.println("GO DROITE");
        pos_x+=value;
        Serial.println(pos_x);
        servo.attach(SERVO_X);
        servo.write(pos_x);
        delay(200);
        servo.detach();
      } else {
        Serial.println("Limite DROITE atteinte.");
      }
        break;
    case HAUT:
      if (pos_y + value <=  MAX_Y){
        Serial.println("GO HAUT");
        pos_y+=value;
        Serial.println(pos_y);
        servo.attach(SERVO_Y);
        servo.write(pos_y);
        delay(200);
        servo.detach();
      } else {
        Serial.println("Limite HAUT atteinte.");
      }
        break;
    case BAS:    
      if (pos_y + value >=  MIN_Y){
        Serial.println("GO BAS");
        pos_y+=value;
        Serial.println(pos_y);
        servo.attach(SERVO_Y);
        servo.write(pos_y);
        delay(200);
        servo.detach();    
      } else {
        Serial.println("Limite BAS atteinte.");
      }
        break;
  }  
}

void turnDiag(int value,char Direction, Servo servoX, Servo servoY)
{
  switch(Direction)
  {
    case HAUT_GAUCHE:
      if (pos_x - value >=  MIN_X && pos_y + value <=  MAX_Y){
        Serial.println("GO HAUT-GAUCHE");
        pos_x-=value;
        pos_y+=value;
        Serial.println(pos_x);
        Serial.println(pos_y);
        servoX.attach(SERVO_X);
        servoY.attach(SERVO_Y);
        servoX.write(pos_x);
        servoY.write(pos_y);
        delay(200);
        servoX.detach();
        servoY.detach();
      } else {
        Serial.println("Limite HAUT ou GAUCHE atteinte.");
      }
        break;
    case HAUT_DROITE:    
      if (pos_x + value <=  MAX_X &&  pos_y + value <=  MAX_Y){
        Serial.println("GO HAUT-DROITE");
        pos_x+=value;
        pos_y+=value;
        Serial.println(pos_x);
        Serial.println(pos_y);
        servoX.attach(SERVO_X);
        servoY.attach(SERVO_Y);
        servoX.write(pos_x);
        servoY.write(pos_y);
        delay(200);
        servoY.detach();
        servoX.detach();
      } else {
        Serial.println("Limite HAUT-DROITE atteinte.");
      }
        break;
    case BAS_GAUCHE:
      if (pos_y - value >=  MIN_Y && pos_x - value >=  MIN_X){
        Serial.println("GO BAS-GAUCHE");
        pos_y-=value;
        pos_x-=value;
        Serial.println(pos_y);
        Serial.println(pos_x);
        servoX.attach(SERVO_X);
        servoY.attach(SERVO_Y);
        servoY.write(pos_y);
        servoX.write(pos_x);
        delay(200);
        servoX.detach();
        servoY.detach();
      } else {
        Serial.println("Limite BAS-GAUCHE atteinte.");
      }
        break;
    case BAS_DROITE:    
      if (pos_y - value >=  MIN_Y && pos_x + value <=  MAX_X){
        Serial.println("GO BAS-DROITE");
        pos_y-=value;
        pos_x+=value;
        Serial.println(pos_y);
        Serial.println(pos_x);
        servoY.attach(SERVO_Y);
        servoX.attach(SERVO_X);
        servoY.write(pos_y);
        servoX.write(pos_x);
        delay(200);
        servoX.detach();    
        servoY.detach();    
      } else {
        Serial.println("Limite BAS-DROITE atteinte.");
      }
        break;
  }  
}

void center ()
{
  pos_y = MILIEU;
  pos_x = MILIEU;
  servo_x.attach(SERVO_X);
  servo_y.attach(SERVO_Y);
  servo_x.write(MILIEU);
  servo_y.write(MILIEU);
  delay(SLEEP);
  servo_x.detach();
  servo_y.detach();
}

void init_servo ()
{
  servo_x.attach(SERVO_X);
  servo_y.attach(SERVO_Y);
  servo_x.write(MILIEU);
  servo_y.write(MILIEU);
  delay(SLEEP);
  servo_x.write(MILIEU+80);
  delay(SLEEP);
  servo_x.write(MILIEU-80);
  delay(SLEEP);
  servo_x.write(MILIEU);
  delay(SLEEP);
  servo_y.write(MILIEU+80);
  delay(SLEEP);
  servo_y.write(MILIEU-35);
  delay(SLEEP);
  servo_y.write(MILIEU);
  delay(SLEEP);
  servo_x.detach();
  servo_y.detach();
}




