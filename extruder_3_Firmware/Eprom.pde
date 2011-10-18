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
#include <EEPROM.h>

void Write2Eprom(){
/*
add 1 ExtruderSensor byte
add 2 BedSensor byte
add 3 ExtruderOutput byte
add 4 BedOutput byte
add 5 Set_Extruder_Temp lowbyte
add 6 Set_Extruder_Temp highbyte
add 7 Set_Bed_Temp byte
*/

EEPROM.write(0,(byte)ExtruderSensor);
EEPROM.write(1,(byte)BedSensor);
EEPROM.write(2,(byte)ExtruderOutput);
EEPROM.write(3,(byte)BedOutput);
EEPROM.write(4,lowByte((word)Set_Extruder_Temp));
EEPROM.write(5,highByte((word)Set_Extruder_Temp));
EEPROM.write(6,(byte)Set_Bed_Temp);

}  




void ReadFromEprom(){
/*
add 1 ExtruderSensor byte
add 2 BedSensor byte
add 3 ExtruderOutput byte
add 4 BedOutput byte
add 5 Set_Extruder_Temp lowbyte
add 6 Set_Extruder_Temp highbyte
add 7 Set_Bed_Temp byte
*/

ExtruderSensor =  EEPROM.read(0);
BedSensor = EEPROM.read(1);
ExtruderOutput = EEPROM.read(2);
BedOutput = EEPROM.read(3);
Set_Extruder_Temp =word(EEPROM.read(5),EEPROM.read(4));
Set_Bed_Temp = EEPROM.read(6);

}
