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

void Main_Menu()
{
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index--;
			if(Focus_Index == -1)
				Focus_Index = 3;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index++;
			if(Focus_Index == 4)
				Focus_Index = 0;
		}
		else if(Action == OK)
		{
			Action = Null;
			if(Focus_Index == 0)
			{
				start();
			}
			else if(Focus_Index == 1)
			{
				
                                Temp_Setup();
				
			}
			else if(Focus_Index == 2)
			{
				Sensor_Setup();
                        
                        }
                        else if(Focus_Index == 3)
			{
				Output_Setup();
                        
                        }
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Main Menu",CENTER,0);
                        myGLCD.print("Start",(Focus_Index==0)?5:0,8);
			myGLCD.print("Temp Setup",(Focus_Index==1)?5:0,16);
			myGLCD.print("Sensor Setup",(Focus_Index==2)?5:0,24);
			myGLCD.print("Output Setup",(Focus_Index==3)?5:0,32);


			Dis_Updata = 0;
		}
	}
}

void Temp_Setup()
{
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index--;
			if(Focus_Index == -1)
				Focus_Index = 1;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index++;
			if(Focus_Index == 2)
				Focus_Index = 0;
		}
		else if(Action == OK)
		{
			Action = Null;
			if(Focus_Index == 0)
			{

                                Extruder_Temp_Setup();
			}
			else if(Focus_Index == 1)
			{
				Bed_Temp_Setup();
			}
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Temp Setup",CENTER,0);
                        myGLCD.print("Extruder Temp",(Focus_Index==0)?5:0,8);
			myGLCD.print("Bed Temp",(Focus_Index==1)?5:0,16);

			Dis_Updata = 0;
		}
	}
}

void Extruder_Temp_Setup()
{
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Set_Extruder_Temp++;
			if(Set_Extruder_Temp <= 0)
				Set_Extruder_Temp = 0;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Set_Extruder_Temp--;
			if(Set_Extruder_Temp >= 350)
				Set_Extruder_Temp = 350;
		}
		else if(Action == OK)
		{
			        Action = Null;
                                Done();
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Extruder Temp",CENTER,8);
			myGLCD.print("Set Temp: ",0,16);
			myGLCD.printNumI(Set_Extruder_Temp,RIGHT,16);


			Dis_Updata = 0;
		}
	}
}

void Bed_Temp_Setup()
{
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Set_Bed_Temp++;
			if(Set_Bed_Temp <= 0)
				Set_Bed_Temp = 0;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Set_Bed_Temp--;
			if(Set_Bed_Temp >= 350)
				Set_Bed_Temp = 350;
		}
		else if(Action == OK)
		{
			        Action = Null;
                                Done();
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Bed Temp",CENTER,8);
			myGLCD.print("Set Temp: ",0,16);
			myGLCD.printNumI(Set_Bed_Temp,RIGHT,16);
			Dis_Updata = 0;
		}
	}
}

void Sensor_Setup(){
        
        ExtruderSensor =-1;
        BedSensor =-1;
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index--;
			if(Focus_Index == -1)
				Focus_Index = 2;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index++;
			if(Focus_Index == 3)
				Focus_Index = 0;
		}
		else if(Action == OK)
		{
			Action = Null;
			if(Focus_Index == 0)
			{
				ExtruderSensor = T1;
                                Sensor_Setup2();
			}
			else if(Focus_Index == 1)
			{
				
				ExtruderSensor = T2;
				Sensor_Setup2();
			}
			else if(Focus_Index == 2)
			{
								
                                ExtruderSensor = TC;
                                Sensor_Setup2();
                        }
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Select Extruder",CENTER,0);
                        myGLCD.print("Sensor",CENTER,8);
                        
                        myGLCD.print("Thermistor 1",(Focus_Index==0)?5:0,24);
			myGLCD.print("Thermistor 2",(Focus_Index==1)?5:0,32);
			myGLCD.print("Thermocouple",(Focus_Index==2)?5:0,40);

			Dis_Updata = 0;
		}
	}
}

void Sensor_Setup2(){
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index--;
			if(Focus_Index == -1)
				Focus_Index = 1;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index++;
			if(Focus_Index == 2)
				Focus_Index = 0;
		}
		else if(Action == OK)
		{
			Action = Null;
				 if ((ExtruderSensor ==T1) && (Focus_Index==0)) BedSensor = T2;
				 if ((ExtruderSensor ==T1) && (Focus_Index==1)) BedSensor = TC;
                                 if ((ExtruderSensor ==T2) && (Focus_Index==0)) BedSensor = T1;
                                 if ((ExtruderSensor ==T2) && (Focus_Index==1)) BedSensor = TC;
        			 if ((ExtruderSensor ==TC) && (Focus_Index==0)) BedSensor = T1;
        			 if ((ExtruderSensor ==TC) && (Focus_Index==1)) BedSensor = T2;
        
                                Done();
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Select Bed",CENTER,0);
                        myGLCD.print("Sensor",CENTER,8);
                        
                        if (ExtruderSensor ==T1) {
                          myGLCD.print("Thermistor 2",(Focus_Index==0)?5:0,24);
                          myGLCD.print("Thermocouple",(Focus_Index==1)?5:0,32);
                        }
                        if (ExtruderSensor ==T2) {
                          myGLCD.print("Thermistor 1",(Focus_Index==0)?5:0,24);
                          myGLCD.print("Thermocouple",(Focus_Index==1)?5:0,32);
                        }
                        
			if (ExtruderSensor ==TC){
                         myGLCD.print("Thermistor 1",(Focus_Index==0)?5:0,24);
                         myGLCD.print("Thermistor 2",(Focus_Index==1)?5:0,32); 
                        }			

			Dis_Updata = 0;
		}
	}
}

void Output_Setup(){
        ExtruderOutput =-1;
        BedOutput =-1;
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index--;
			if(Focus_Index == -1)
				Focus_Index = 3;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index++;
			if(Focus_Index == 4)
				Focus_Index = 0;
		}
		else if(Action == OK)
		{
			Action = Null;
			if(Focus_Index == 0)
			{
				ExtruderOutput = R1;
                                Output_Setup2();
			}
			else if(Focus_Index == 1)
			{
				
				ExtruderOutput = R2;
				Output_Setup2();
			}
			else if(Focus_Index == 2)
			{
								
                                ExtruderOutput = M1;
                                Output_Setup2();
                        }
			else if(Focus_Index == 3)
			{
								
                                ExtruderOutput = M2;
                                Output_Setup2();
                        }

			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Select Extruder",CENTER,0);
                        myGLCD.print("Output",CENTER,8);
                        
                        myGLCD.print("Relay 1",(Focus_Index==0)?5:0,16);
			myGLCD.print("Relay 2",(Focus_Index==1)?5:0,24);
			myGLCD.print("Mosfet 1",(Focus_Index==2)?5:0,32);
			myGLCD.print("Mosfet 2",(Focus_Index==3)?5:0,40);

			Dis_Updata = 0;
		}
	}
}

void Output_Setup2(){
        myGLCD.clrScr();
        unsigned char Action = Null;
	int  Focus_Index = 0;
	unsigned char Dis_Updata = 1;
	while(1)
	{
		Action = KeyScan();
		if(Action == UP)
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index--;
			if(Focus_Index == -1)
				Focus_Index = 2;
		}
		else if(Action ==DN )
		{
			Action = Null;
			Dis_Updata = 1;
			Focus_Index++;
			if(Focus_Index == 3)
				Focus_Index = 0;
		}
		else if(Action == OK)
		{
			Action = Null;
				 if ((ExtruderOutput ==R1) && (Focus_Index==0)) BedOutput = R2;
				 if ((ExtruderOutput ==R1) && (Focus_Index==1)) BedOutput = M1;
				 if ((ExtruderOutput ==R1) && (Focus_Index==2)) BedOutput = M2;

				 if ((ExtruderOutput ==R2) && (Focus_Index==0)) BedOutput = R1;
				 if ((ExtruderOutput ==R2) && (Focus_Index==1)) BedOutput = M1;
				 if ((ExtruderOutput ==R2) && (Focus_Index==2)) BedOutput = M2;

				 if ((ExtruderOutput ==M1) && (Focus_Index==0)) BedOutput = R1;
				 if ((ExtruderOutput ==M1) && (Focus_Index==1)) BedOutput = R2;
				 if ((ExtruderOutput ==M1) && (Focus_Index==2)) BedOutput = M2;

				 if ((ExtruderOutput ==M2) && (Focus_Index==0)) BedOutput = R1;
				 if ((ExtruderOutput ==M2) && (Focus_Index==1)) BedOutput = R2;
				 if ((ExtruderOutput ==M2) && (Focus_Index==2)) BedOutput = M1;
        
                                 Done();
			
		}
		if(Dis_Updata == 1)
		{
			myGLCD.clrScr();
                        myGLCD.print("Select Bed",CENTER,0);
                        myGLCD.print("Output",CENTER,8);
                        
                        if (ExtruderOutput ==R1) {
                          myGLCD.print("Relay 2",(Focus_Index==0)?5:0,24);
                          myGLCD.print("Mosfet 1",(Focus_Index==1)?5:0,32);
                          myGLCD.print("Mosfet 2",(Focus_Index==2)?5:0,40);

                        }
                        if (ExtruderOutput ==R2) {
                          myGLCD.print("Relay 1",(Focus_Index==0)?5:0,24);
                          myGLCD.print("Mosfet 1",(Focus_Index==1)?5:0,32);
                          myGLCD.print("Mosfet 2",(Focus_Index==2)?5:0,40);

                        }
                        
			if (ExtruderOutput ==M1){
                         myGLCD.print("Relay 1",(Focus_Index==0)?5:0,24);
                         myGLCD.print("Relay 2",(Focus_Index==1)?5:0,32); 
                         myGLCD.print("Mosfet 2",(Focus_Index==2)?5:0,40); 
                        
                        }			
                        if (ExtruderOutput ==M2){
                         myGLCD.print("Relay 1",(Focus_Index==0)?5:0,24);
                         myGLCD.print("Relay 2",(Focus_Index==1)?5:0,32); 
                         myGLCD.print("Mosfet 1",(Focus_Index==2)?5:0,40); 
                        
                        }			
                        

			Dis_Updata = 0;
		}
	}
}

