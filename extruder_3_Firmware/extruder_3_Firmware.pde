/*

Gnexlab extruder controller v2.1 - August 2011
WebSite: store.gnexlab.com
Developer: Nuri Erginer
Licence: GNU General Public License  see <http://www.gnu.org/licenses/>. 

This program is distributed in the hope that it will be useful, 
but WITHOUT ANY WARRANTY; without even the implied warranty of 
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
GNU General Public License for more details. 

*/

// LCD LIB USED:  LCD5110_Bitmap (C)2011 Henning Karlsen
//                web: http://www.henningkarlsen.com/electronics
//      SCK  - Pin 6
//      MOSI - Pin 5
//      DC   - Pin 4
//      RST  - Pin 3
//      CS   - Pin 2
//

/*
  MAX6675.cpp - Library for reading temperature from a MAX6675.
  Created by Ryan McLaughlin <ryanjmclaughlin@gmail.com>
*/

/*
 *  buttons.cpp
 *  One-shot and hold functions for buttons.
 *  Created by Franky on 29/01/09.
 */



#include <LCD5110_Basic.h>
#include <MAX6675.h>
//#include <Button.h>
#include <buttons.h>
#include <PID_v1.h>

//Buttons
Button UP_button;
Button OK_button;
Button DN_button;

#define UP 1
#define DN 2
#define OK 3
#define Null 0

//LCD
LCD5110 myGLCD(6,5,4,3,2);
extern uint8_t gnexlab_logo[];
extern uint8_t SmallFont[];



//Relay
#define R1 8 //relay 1 connected to digital 8
#define R2 7 //relay 2 connected to digital 7

//Mosfet
#define M1 9  //msofet 1 connected to digital 9
#define M2 10 //mosfet 2 connected to digital 10

//Thermistor
#define T1 A1 //thermistor 1 connected to A1
#define T2 A0 //thermistor 2 connected to A0

//Thermocouple
#define TC 99
int CS0 = 11;              // CS pin on MAX6675
int SO = 12;              // SO pin of MAX6675
int SCK = 13;             // SCK pin of MAX6675
int units = 1;            // Units to readout temp (0 = ËšF, 1 = ËšC)
float error = 0.0;        // Temperature compensation error
//float temperature = 0.0;  // Temperature output variable
MAX6675 thermocouple(CS0,SO,SCK,units,error);



//Temp
double Extruder_Temp = 0;
double Bed_Temp = 0;

double Set_Extruder_Temp = 250;
double Set_Bed_Temp = 120;

//Sensors
int ExtruderSensor =-1;
int BedSensor =-1;

//Outputs
int ExtruderOutput =-1;
int BedOutput =-1;



void setup()
{
//eprom

ReadFromEprom();
//Button
UP_button.setMode(OneShot);
UP_button.assign(A2);
DN_button.setMode(OneShot);
DN_button.assign(A4);
OK_button.setMode(OneShot);
OK_button.assign(A3);


//Relay
 pinMode(R1, OUTPUT);
 pinMode(R2, OUTPUT);
//Thermistor
 pinMode(T1, INPUT);
 pinMode(T2, INPUT);
//Mosfet
 pinMode(M1, OUTPUT);
 pinMode(M2, OUTPUT);

 
 myGLCD.InitLCD();

 myGLCD.drawBitmap(0, 0, gnexlab_logo, 84, 48);
 delay(4000);
myGLCD.clrScr();
myGLCD.setFont(SmallFont);
}

void loop()
{
Main_Menu();
}


unsigned char KeyScan()
{

if(UP_button.check()==ON) return (UP); 
if(DN_button.check()==ON) return (DN); 
if(OK_button.check()==ON) return (OK); 

}


void start() {
//ReadFromEprom();
initPID();
while (1) {
Manage_Temperatures ();
myGLCD.clrScr();
myGLCD.print("Extruder:",0,0);
myGLCD.printNumI(Extruder_Temp,RIGHT,0);
myGLCD.print("Set Temp: ",0,8);
myGLCD.printNumI(Set_Extruder_Temp,RIGHT,8);

myGLCD.print("Bed:",0,24);
myGLCD.printNumI(Bed_Temp,RIGHT,24);
myGLCD.print("Set Temp: ",0,32);
myGLCD.printNumI(Set_Bed_Temp,RIGHT,32);
delay(1000);
}
}



float thermocouple_Read() {
 float temperature = thermocouple.read_temp(5);         // Read the temp 5 times and return the average value to the var

  if(temperature == -1) {                   // If there is an error with the TC, temperature will be -1
    myGLCD.clrScr();
    myGLCD.print("Thermocouple Error!!",CENTER,0);
  } 
  
  return temperature;
}

void Done(){
                                Write2Eprom();
                                myGLCD.clrScr();
                                myGLCD.print("DONE",CENTER,24);
                                myGLCD.invert(true);
				delay(500);
                                myGLCD.invert(false);
                                delay(500);
                                Main_Menu();
}
