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
#define MIN_Y   30
#define MAX_Y   150
#define SPEED   10

char message;

Servo servo_x;
Servo servo_y;

void setup() {
  
  message = ' ';  
  pinMode(LED_BUILTIN, OUTPUT);
  
  servo_x.attach(SERVO_X);
  servo_y.attach(SERVO_Y);
  servo_x.write(MILIEU);
  servo_y.write(MILIEU);
  delay(300);
  servo_x.detach();
  servo_y.detach();
  
  Serial.begin(9600);
  Serial.print("Lancement du programme !");
  delay(3000);
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
        turn(SPEED, DROITE, servo_x);
      break;
      case HAUT:
        //Tourner vers le haut
        Serial.println("HAUT");
        turn(SPEED, HAUT, servo_y);
      break;
      case BAS:
        //Tourner vers le BAS
        Serial.println("BAS");
        turn(SPEED, BAS, servo_y);
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
      if (servo.read() + value >=  MIN_X){
        servo.attach(SERVO_X);
        servo.write(servo.read()+value);
        delay(200);
        servo.detach();
      }
        break;
    case DROITE:    
      if (servo.read() + value <=  MAX_X){
        servo.attach(SERVO_X);
        servo.write(servo.read()+value);
        delay(200);
        servo.detach();
      }
        break;
    case HAUT:
      if (servo.read() + value <=  MAX_Y){
        servo.attach(SERVO_Y);
        servo.write(servo.read()+value);
        delay(200);
        servo.detach();
      }
        break;
    case BAS:    
      if (servo.read() + value >=  MIN_Y){
        servo.attach(SERVO_Y);
        servo.write(servo.read()+value);
        delay(200);
        servo.detach();    
      }
        break;
  }  
}


