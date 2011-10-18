/*
  LCD5110_Basic.cpp - Arduino library support for Nokia 5110 compatible LCDs
  Copyright (C)2011 Henning Karlsen. All right reserved
  
  Basic functionality of this library are based on the demo-code provided by
  ITead studio. You can find the latest version of the library at
  http://www.henningkarlsen.com/electronics

  This library has been made to make it easy to use the basic functions of
  the Nokia 5110 LCD module on an Arduino.

  If you make any modifications or improvements to the code, I would appreciate
  that you share the code with me so that I might include it in the next release.
  I can be contacted through http://www.henningkarlsen.com/electronics/contact.php

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include "WProgram.h"
#include "LCD5110_Basic.h"
#include <avr/pgmspace.h>
#include <pins_arduino.h>

LCD5110::LCD5110(int SCK, int MOSI, int DC, int RST, int CS)
{ 
	P_SCK	= portOutputRegister(digitalPinToPort(SCK));
	B_SCK	= digitalPinToBitMask(SCK);
	P_MOSI	= portOutputRegister(digitalPinToPort(MOSI));
	B_MOSI	= digitalPinToBitMask(MOSI);
	P_DC	= portOutputRegister(digitalPinToPort(DC));
	B_DC	= digitalPinToBitMask(DC);
	P_RST	= portOutputRegister(digitalPinToPort(RST));
	B_RST	= digitalPinToBitMask(RST);
	P_CS	= portOutputRegister(digitalPinToPort(CS));
	B_CS	= digitalPinToBitMask(CS);
	pinMode(SCK,OUTPUT);
	pinMode(MOSI,OUTPUT);
	pinMode(DC,OUTPUT);
	pinMode(RST,OUTPUT);
	pinMode(CS,OUTPUT);
}

void LCD5110::_LCD_Write(unsigned char data, unsigned char mode)
{   
	*P_CS &= ~B_CS;

	if (mode==0)
		*P_DC &= ~B_DC;
	else
		*P_DC |= B_DC;

	for (unsigned char c=0; c<8; c++)
	{
		if (data & 0x80)
			*P_MOSI |= B_MOSI;
		else
			*P_MOSI &= ~B_MOSI;
		data = data<<1;
		*P_SCK &= ~B_SCK;
		asm ("nop");
		*P_SCK |= B_SCK;
	}

	*P_CS |= B_CS;
}

void LCD5110::InitLCD()
{
	*P_DC |= B_DC;
	*P_MOSI |= B_MOSI;
	*P_SCK |= B_SCK;
	*P_CS |= B_CS;

	*P_RST &= ~B_RST;
	delay(10);
	*P_RST |= B_RST;

	_LCD_Write(0x21, LCD_COMMAND);
	_LCD_Write(0xC6, LCD_COMMAND);
	_LCD_Write(0x06, LCD_COMMAND);
	_LCD_Write(0x13, LCD_COMMAND);
	_LCD_Write(0x20, LCD_COMMAND);
	_LCD_Write(0x40, LCD_COMMAND);
	_LCD_Write(0x80, LCD_COMMAND);
	for (int c=0; c<504; c++)
		_LCD_Write(0x00, LCD_DATA);
	_LCD_Write(0x0C, LCD_COMMAND);

	cfont.font=0;
}

void LCD5110::clrScr()
{
	_LCD_Write(0x40, LCD_COMMAND);
	_LCD_Write(0x80, LCD_COMMAND);
	for (int c=0; c<504; c++)
		_LCD_Write(0x00, LCD_DATA);
}

void LCD5110::clrRow(int row, int start_x, int end_x)
{
	_LCD_Write(0x40 + row, LCD_COMMAND);
	_LCD_Write(0x80 + start_x, LCD_COMMAND);
	for (int c=start_x; c<=end_x; c++)
		_LCD_Write(0x00, LCD_DATA);
	_LCD_Write(0x40, LCD_COMMAND);
	_LCD_Write(0x80, LCD_COMMAND);
}

void LCD5110::invert(bool mode)
{
	if (mode==true)
		_LCD_Write(0x0D, LCD_COMMAND);
	else
		_LCD_Write(0x0C, LCD_COMMAND);
}

void LCD5110::print(char *st, int x, int y)
{
	unsigned char ch;
	int stl, row, xp;

	stl = strlen(st);
	if (x == RIGHT)
		x = 84-(stl*cfont.x_size);
	if (x == CENTER)
		x = (84-(stl*cfont.x_size))/2;
	if (x < 0)
		x = 0;

	row = y / 8;
	xp = x;

	for (int cnt=0; cnt<stl; cnt++)
			_print_char(*st++, x + (cnt*(cfont.x_size)), row);
}

void LCD5110::printNumI(long num, int x, int y)
{
  char buf[13];
  char st[15];
  boolean neg=false;
  int c=0;
  
  if (num==0)
  {
	  st[0]=48;
	  st[1]=0;
  }
  else
  {
	  if (num<0)
	  {
		neg=true;
		num=-num;
	  }
	  
	  while (num>0)
	  {
		buf[c]=48+(num % 10);
		c++;
		num=(num-(num % 10))/10;
	  }
	  buf[c]=0;
	  
	  if (neg)
	  {
		st[0]=45;
	  }
	  
	  for (int i=0; i<c; i++)
	  {
		st[i+neg]=buf[c-i-1];
	  }
	  st[c+neg]=0;
  }

  print(st,x,y);
}

void LCD5110::printNumF(double num, byte dec, int x, int y)
{
  char buf[25];
  char st[27];
  boolean neg=false;
  int c=0;
  int c2;
  unsigned long inum;
  
  if (num==0)
  {
	  st[0]=48;
	  st[1]=46;
	  for (int i=0; i<dec; i++)
		  st[2+i]=48;
	  st[2+dec]=0;
  }
  else
  {
	  if (num<0)
	  {
		neg=true;
		num=-num;
	  }
	  
	  if (dec<1)
		dec=1;
	  if (dec>5)
		dec=5;
	  
	  inum=long(num*pow(10,dec));
	  
	  while (inum>0)
	  {
		buf[c]=48+(inum % 10);
		c++;
		inum=(inum-(inum % 10))/10;
	  }
	  if ((num<1) and (num>0))
	  {
		  buf[c]=48;
		  c++;
	  }
	  buf[c]=0;
	  
	  if (neg)
	  {
		st[0]=45;
	  }
	  
	  c2=neg;
	  for (int i=0; i<c; i++)
	  {
		st[c2]=buf[c-i-1];
		c2++;
		if ((c-(c2-neg))==dec)
		{
		  st[c2]=46;
		  c2++;
		}
	  }
	  st[c2]=0;
  }

  print(st,x,y);
}

void LCD5110::_print_char(unsigned char c, int x, int row)
{
	if (((x+cfont.x_size)<=84) and (row+(cfont.y_size/8)<=6))
	{
		for (int rowcnt=0; rowcnt<(cfont.y_size/8); rowcnt++)
		{
			_LCD_Write(0x40+row+rowcnt, LCD_COMMAND);
			_LCD_Write(0x80+x, LCD_COMMAND);

			int font_idx = ((c - cfont.offset)*(cfont.x_size*(cfont.y_size/8)))+4;

			for(int cnt=0; cnt<cfont.x_size; cnt++)
			{
				_LCD_Write(pgm_read_byte(&cfont.font[font_idx+cnt+(rowcnt*cfont.x_size)]), LCD_DATA);
			}
		}
		_LCD_Write(0x40, LCD_COMMAND);
		_LCD_Write(0x80, LCD_COMMAND);
	}
}

void LCD5110::setFont(uint8_t* font)
{
	cfont.font=font;
	cfont.x_size=pgm_read_byte(&cfont.font[0]);
	cfont.y_size=pgm_read_byte(&cfont.font[1]);
	cfont.offset=pgm_read_byte(&cfont.font[2]);
	cfont.numchars=pgm_read_byte(&cfont.font[3]);
}

void LCD5110::drawBitmap(int x, int y, uint8_t* bitmap, int sx, int sy, bool flash)
{
	int starty, rows;
    
	starty = y / 8;

	if (sy%8==0)
		rows=sy/8;  
	else
		rows=(sy/8)+1;

	for (int cy=0; cy<rows; cy++)
	{
		_LCD_Write(0x40+(starty+cy), LCD_COMMAND);
		_LCD_Write(0x80+x, LCD_COMMAND);
		for(int cx=0; cx<sx; cx++)
		{
			if (flash)
			_LCD_Write(pgm_read_byte(&bitmap[cx+(cy*sx)]), LCD_DATA);
				else
			_LCD_Write(bitmap[cx+(cy*sx)], LCD_DATA);
		}
	}      
	_LCD_Write(0x40, LCD_COMMAND);
	_LCD_Write(0x80, LCD_COMMAND);
}
