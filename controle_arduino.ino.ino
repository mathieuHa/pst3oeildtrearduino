#include <Servo.h>


#define DROITE  'd'
#define GAUCHE  'g'
#define HAUT    'h'
#define BAS     'b'
#define SERVO_Y 9
#define SERVO_X 8
#define MILIEU  90
#define MIN_X   30
#define MAX_X   150
#define MIN_Y   40
#define MAX_Y   150
#define SPEED   20
#define SLEEP   300

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

void init_servo ()
{
  servo_x.attach(SERVO_X);
  servo_y.attach(SERVO_Y);
  servo_x.write(MILIEU);
  servo_y.write(MILIEU);
  delay(SLEEP);
  servo_x.write(MILIEU+30);
  delay(SLEEP);
  servo_x.write(MILIEU-30);
  delay(SLEEP);
  servo_x.write(MILIEU);
  delay(SLEEP);
  servo_y.write(MILIEU+30);
  delay(SLEEP);
  servo_y.write(MILIEU-30);
  delay(SLEEP);
  servo_y.write(MILIEU);
  delay(SLEEP);
  servo_x.detach();
  servo_y.detach();
}




