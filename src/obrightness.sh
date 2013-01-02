#!/bin/sh
#obrightness v0.1
#    Patryk Rzucidlo (@PTKDev) <ptkdev@gmail.com> - http://me.ptkdev.it/
#    Copyright (C) 2013 
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

type=0
for arg in "$@"
  do
	case $arg in
	(--help)
		echo "Usage: obrightness v0.1"
		echo "                                   "
		echo "    args = --plus (brightness +10%)"
		echo "           --minus (brightness -10%)"
		echo "           --max (brightness 100%)"
		echo "           --min (brightness 0%)"
		echo "                                   "
		echo "Credits: Patryk Rzucidlo (@PTKDev) <ptkdev@gmail.com>"
		echo "License: GPLv3"
		echo "                                   "
		;;

	(--plus)
		type=1
		;;
	(--minus)
		type=2
		;;
	(--max)
		type=3
		;;
	(--min)
		type=4
		;;
	esac
done
	  
for dir in $( ls /sys/class/backlight ); do
	brightness=`cat /sys/class/backlight/$dir/actual_brightness`
	brightness_max=`cat /sys/class/backlight/$dir/max_brightness` 
	brightness_min=0
	percent=`expr $brightness_max / 10`
	  
	 if [ $type -eq 1 ]; then
		if [ $brightness -ge $brightness_max ]; then
			brightness=$brightness_max
		else
			brightness=`expr $brightness \+ $percent`
		fi
	 elif [ $type -eq 2 ]; then
		if [ $brightness -le 0 ]; then
			brightness=$brightness_min
		else
			brightness=`expr $brightness \- $percent`
		fi
	 elif [ $type -eq 3 ]; then
			brightness=$brightness_max
	 elif [ $type -eq 4 ]; then
			brightness=$brightness_min
	 fi
	 
	#debug:
	#echo $brightness
	#echo $type
	
	echo $brightness >> /sys/class/backlight/$dir/brightness
done
