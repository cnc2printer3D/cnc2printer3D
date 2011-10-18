
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







void mosfet_ON(int MOSFET)
{
    digitalWrite(MOSFET,HIGH);
}

void mosfet_OFF(int MOSFET)
{
    digitalWrite(MOSFET,LOW);
}

