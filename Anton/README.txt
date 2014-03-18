
AER1514 Startup Notes v2
========================
T D Barfoot
24 July 2012

(corrected by Sean Anderson, 18 Jan 2013)


Purpose
------------
These notes will help you get started with LEGO and the Kinect under Matlab/Simulink 2012a.


System Requirements
-------------------------------
-aer1514 robotics kit (LEGO Mindstorms, Matlab/Simulink 2012a, Microsoft Kinect RGB-D camera)
-a computer running a recent version of Microsoft 32-bit Windows (usb ports, bluetooth capable)


Device Software Installation Procedure
-------------------------------------------------------
(based on an installation of 32-bit Windows 7 Ultimate on a circa 2008 Macbook Pro)


1. Lego Mindstorms

Install Matlab 2012a and type "targetinstaller" at the Matlab prompt...all software is installed automatically.


2.  Kinect

Download and install the drivers in their default locations:

A. Open NI drivers from here:
	http://www.openni.org/openni-sdk/openni-sdk-history-2/

	openni-win32-1.5.4.0-dev.msi
	nite-win32-1.5.2.21-dev.msi   (use key 0KOIk2JeIBYClPWVnMoRKn5cdY4= if asked)
	sensor-win32-5.1.2.1-redist.msi

B. Sensor Kinect driver from here:   
	https://github.com/avin2/SensorKinect

	avin2-SensorKinect-v0.93-5.1.2.1-0-g15f1975.zip
	-unzip and run bin/SensorKinect093-Bin-Win32-v5.1.2.1.msi

	NITE Samples Programs should work at this point.

C. Matlab Kinect Functions

	A compiled version of the Matlab Kinect mex code has been provided as part of the setup ZIP file; it can also be downloaded from here:
	http://sourceforge.net/projects/kinect-mex/

	kinect-mex1.3-windows.zip
	-unzip and add the "Mex" directory to Matlab's path and restart Matlab

	Samples program should work at this point: 
	- see grabkinect.m below


Sample User Software
--------------------------------

This ZIP file also contains the following:

Config/		:  Matlab Kinect configuration files (don't touch these)
Mex/			:  Matlab Kinect libraries (don't touch these)
LGPL.txt		:  license file for using Matlab Kinect  (don't touch this)

rover.mdl 		:  Simulink diagram for a basic robot (open this and poke around to see how it works)
drive.m		:  Matlab function to command robot to drive (shows how to set Simulink parameters)
brake.m		:  Matlab function to command robot to stop
armup.m		:  Matlab function to command robot to lift arm
armdown.m	:  Matlab function to command robot to lower arm
armstop.m		:  Matlab function to command robot to stop arm

grabkinect.m	:  Matlab function to grab a single rgb and a single depth image from the Kinect

Here's how it works:

1.  open 'rover.mdl' in Simulink; on the first time only, you will need to update the NXT's firmware via

	Tools->Run on Target Hardware->Update Firmware
	
2.  build a robot with the sensors /motors connected as per the simulink diagram

3.  plug in the NXT's usb cable to download the software and press the orange button to turn it on

4.  start the Simulink model running via 

	Tools->Run on Target Hardware->Run

5.  use the 'drive.m', 'brake.m', etc. commands to make the robot do things; this shows how to use "parameters" to command it

Note, once the software is running on the NXT, you can unplug the usb cable and talk to it via bluetooth.




