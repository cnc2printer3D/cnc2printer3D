
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

/**********************************************************************************************
 * Arduino PID Library - Version 1
 * by Brett Beauregard <br3ttb@gmail.com> brettbeauregard.com
 **********************************************************************************************/
double OutputValueExtruder;
double OutputValueBed;

double KP_Extruder = 300;
double KI_Extruder = 0.05;
double KD_Extruder = 300;

double KP_Bed = 300;
double KI_Bed = 0.05;
double KD_Bed = 300;


PID PIDExtruder(&Extruder_Temp, &OutputValueExtruder, &Set_Extruder_Temp,KP_Extruder,KI_Extruder,KD_Extruder, DIRECT);
PID PIDBed(&Bed_Temp, &OutputValueBed, &Set_Bed_Temp,KP_Bed,KI_Bed,KD_Bed, DIRECT);


int WindowSizeExtruder = 5000;
unsigned long windowStartTimeExtruder;

int WindowSizeBed = 5000;
unsigned long windowStartTimeBed;


void read_Temperatures(){

  switch (ExtruderSensor) {
        case T1:
         Extruder_Temp = read_termistor(T1);
        break;
        case T2:
         Extruder_Temp = read_termistor(T2);
        break;
        case TC:
         Extruder_Temp = thermocouple_Read();
        break;
  }
  switch (BedSensor) {
        case T1:
         Bed_Temp = read_termistor(T1);
        break;
        case T2:
         Bed_Temp = read_termistor(T2);
        break;
        case TC:
         Bed_Temp = thermocouple_Read();
        break;
  }

}

void initPIDExtruder(){
 if ((ExtruderOutput==R1) || (ExtruderOutput==R2)){
     windowStartTimeExtruder = millis();
     //tell the PID to range between 0 and the full window size
     PIDExtruder.SetOutputLimits(0, WindowSizeExtruder);
 }
     //turn the PID on
    PIDExtruder.SetMode(AUTOMATIC);
}

void initPIDBed(){
 if ((BedOutput==R1) || (BedOutput==R2)){
     windowStartTimeBed = millis();
     //tell the PID to range between 0 and the full window size
     PIDBed.SetOutputLimits(0, WindowSizeBed);
 }
     //turn the PID on
    PIDBed.SetMode(AUTOMATIC);
}


void Manage_Extruder_Temperature (){
  read_Temperatures();
  PIDExtruder.Compute();
  
  if ((ExtruderOutput==R1) || (ExtruderOutput==R2)){
     /************************************************
      * turn the output pin on/off based on pid output
      ************************************************/
      unsigned long now = millis();
      if(now - windowStartTimeExtruder>WindowSizeExtruder)
      { //time to shift the Relay Window
       windowStartTimeExtruder += WindowSizeExtruder;
      }
      if(OutputValueExtruder > now - windowStartTimeExtruder) digitalWrite(ExtruderOutput,HIGH);
      else digitalWrite(ExtruderOutput,LOW); 
  }
  if ((ExtruderOutput==M1) || (ExtruderOutput==M2)){
   analogWrite(ExtruderOutput,OutputValueExtruder); 
  }
  
}

void Manage_Bed_Temperature (){
  read_Temperatures();
  PIDBed.Compute();
  
  if ((BedOutput==R1) || (BedOutput==R2)){
     /************************************************
      * turn the output pin on/off based on pid output
      ************************************************/
      unsigned long now = millis();
      if(now - windowStartTimeBed>WindowSizeBed)
      { //time to shift the Relay Window
       windowStartTimeBed += WindowSizeBed;
      }
      if(OutputValueBed > now - windowStartTimeBed) digitalWrite(BedOutput,HIGH);
      else digitalWrite(BedOutput,LOW); 
  }
  if ((BedOutput==M1) || (BedOutput==M2)){
   analogWrite(BedOutput,OutputValueBed); 
  }
  
}



void initPID(){
initPIDExtruder();
initPIDBed();
}

void Manage_Temperatures (){
Manage_Extruder_Temperature ();
Manage_Bed_Temperature ();
}

