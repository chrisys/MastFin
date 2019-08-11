
#  Balena ADS-B Multi-Service Flight Tracker
**Balena-ready dump1090-fa + piaware + fr24feed + planefinder**

Contribute to the flight tracking community! Feed your local ADS-B data from an [RTL-SDR](https://www.rtl-sdr.com/) USB dongle and a Raspberry Pi running BalenaOS to the tracking services FlightAware, Flightradar24, and Plane Finder. In return, you will receive free premium accounts (worth several hundred dollars/year)! 

This project is inspired by and has borrowed code from the following repos: https://github.com/compujuckel/adsb-docker and https://bitbucket.org/inodes/resin-docker-rtlsdr. Thanks for sharing!

## Part 1 – Build the receiver

We'll build the receiver using the parts that are outlined on the Flightradar24 and FlightAware websites: https://www.flightradar24.com/build-your-own and https://flightaware.com/adsb/piaware/build. If you wish to keep the setup as cheap as possible, you can use a Raspberry Pi Zero rather than the described Raspberry Pi 3 B+. The Raspberry Pi Zero comes without ethernet, however. If you need this, you will have to buy a breakout cable, too. This one works well: https://shop.pimoroni.com/products/three-port-usb-hub-with-ethernet-and-microb-connector. Keep in mind that the Zero is less powerful than the 3 B+. If you plan to run a lot of services simultaneously, you should probably go all-in on the 3 B+.

In addition to the Pi, you will need an RTL-SDR compatible USB dongle. The dongles are based on a digital television tuner, and numerous types will work – both generic TV sticks and specialized ADS-B sticks (produced by FlightAware). Although both options work, the ADS-B sticks seem to perform a little better.

## Part 2 – Setup Balena and configure the device

 1. [Create a free Balena account](https://dashboard.balena-cloud.com/signup). During the process, you will be asked to upload your public SSH key. If you don't have a public SSH key yet, you can [create one](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent).
 2. Sign in to Balena and head over to the [Applications panel](https://dashboard.balena-cloud.com/apps).
 3. Create an application with the name of your choice, for the device type of your choice. In the dialog that appears, make sure to pick a Default Device Type that matches your receiver. I have tested this code with Raspberry Pi Zero and Raspberry Pi 3 B+, and both work well. If you want to use WiFi, specify the SSID and password here, too.
 4. Balena will create an SD card image for you, and this will start downloading automatically after a few seconds. Flash the image to an SD-card using Balena's dedicated tool [balenaEtcher](https://www.balena.io/etcher/).
 5. Insert the SD card in your receiver, and connect it to your cabled network (unless you plan to use WiFi only, and configured that in step 3). 
 6. Power up the receiver.
 7. From the Balena dashboard, navigate to the application you just created. Within a few minutes, a new device with an automatically generated name should appear. Click on it to open it.
 8. Rename your device to your taste by clicking on the pencil icon next to the current device name.
 9. Next, we'll configure the receive with its geographic location. Unless you happen to know this, you can use [Google Maps](https://maps.google.com) to find it. When you click on your desired location on the map, the corresponding coordinates should appear. We are looking for the decimal coordinates, which should look similar to this: 60.395429, 5.325127.
 10. Back in the Balena console, verify that you have opened up the view for your desired device. Click on the Device Varibles-button – D(x). Add the following two variables: **LAT** *(Receiver Latitude)*, e.g. **60.12345** and **LON** *(Receiver Longitude)*, e.g. **4.12345**.
 11. Almost there! Next, we are going to push this code to your device through the Balena cloud. Head into your terminal and clone this repository to your local computer: ´git clone git@github.com:ketilmo/balena-ads-b.git´
 12. Add a Balena remote to your newly created local Git repo. You'll find the exact command you need for this at the Application page in your Balena dashboard. It should look something like this: ´git remote add balena your_username@git.balena-cloud.com:your_username/your_application_name.git´
 13. Push the code to Balena's servers by typing ´git push balena master´. 
 14. Now, wait while the Docker containers build on Balena's servers. If the process is successful, you will see a beautiful piece of ASCII art depicting a unicorn.
 15. Wait a few moments while the Docker containers are deployed and installed on your RPI. The groundwork is now done – good job!


## Part 3 – Configure FlightAware
If you have previously setup a FlightAware receiver, and want to port it to Balena, you only have to follow the following steps:

* Head back to your device's page in Balena, and click on the Device Varibles-button D(x). Add the following variable:
	* FLIGHTAWARE_FEEDER_ID, then paste your ´Unique Identifier´, eg. 134cdg7d-7533-5gd4-d31d-r31r52g63v12.
* Restart the "piaware" application under "Services" by clicking the "cycle" button.

If you have not previously setup FlightAware, do the following steps:

* Register a new account at FlightAware: https://flightaware.com/account/join/
* Login using your newly created credentials.
* From the same network (either cabled or wireless) as the RPi is running on, head to this page: https://flightaware.com/adsb/piaware/claim
* See if any receivers shows up under "Linked PiAware Receivers". If now, wait about five minutes and click the "Check Again for my PiAware"-button. Hopefully, your receiver is now visible under the "Linked PiAware Receivers" headers.
* In the left-hand-side menu on the top of the page, click the "My ADBS-B"-link. Your device should visible in an orange rectangle. Click the cogwheel icon on the right-hand side of the screen.
* Click the "Configure Location"-button, and verify that the location matches the coordinates you entered earlier. If not, correct them.
* Click the "Configue Height"-button, and specify the altitude of you receiver. If you don't know the receivers altitude, you can find it here using your coordinates: https://www.maps.ie/coordinates.html
* If you have unrestricred bandwith, enable MLAT. This will make your receiver connect to other nearby receivers to multilaterate positions of planes that does not report their position. If you have restricted bandwidth, consider leaving this off. 
* Specify the other settings according to your personal preferences.
* Close the lightbox. Find and copy your receiver's ´Unique Identifier´. It should look somethign like this: 134cdg7d-7533-5gd4-d31d-r31r52g63v12
* Head back to your device's page in Balena, and click on the Device Varibles-button D(x). Add the following variable:
	* FLIGHTAWARE_FEEDER_ID, then paste your ´Unique Identifier´, eg. 134cdg7d-7533-5gd4-d31d-r31r52g63v12.

## Part 4 – Configure FlightRadar24

If you have previously setup a FlightRadar24 receiver, and want to port it to Balena, you only have to follow the following steps:

* Head back to your device's page in Balena, and click on the Device Varibles-button D(x). Add the following variable:
	* FR24_KEY, then paste your ´fr24key´ from the previous step, eg. dv4rrt2g122g7233.
* Restart the "fr24feed" application under "Services" by clicking the "cycle" button.

If you have not previously setup FlightRadar24, do the following steps:

* Head back to your device's page in Balena.
* Inside the "Termnial" section, click "Select a target", then ´fr24feed´, then "Start terminal session."
* This will open a terminal inside your FlightRadar24 container.
* At the prompt, enter ´fr24feed --signup´
* Enter your email address when asked.
* Next, you will be asked if you have a FlightRadar sharing key. Unless you have one from the past, rust press return here.
* If you want to activate multilateration, type ´yes´ at the next prompt. If you have restricted bandwidth available, consider leaving it off by typing ´no´. 
* Enter the receiver's latitude. This should be the exact same value that you entered initially.
* Enter the receiver's longitude. This should be the exact same value that you entered initially.
* Then, enter the receiver's altitude in feet. This should be the same value that you entered in the FlightAware configuration earlier.
* Now, a summary of your settings will be displayed. If you are happy with the result, type yes to continue.
* Under receiver type, choose 4 for ModeS Beast.
* Under connection type, choose 1 for Network connection.
* When asked for your receiver's IP address/hostname, enter ´dump1090-fa´.
* Next, enter the data port number: ´30005´.
* Type ´yes´ to enable the RAW data feed on port 30334.
* Type ´yes´ to enable the Basestation data feed on port 3003.
* Enter ´0´ to disable log file writing.
* When asked for a log file path, just hit return.
* The configuration is now submitted, and you are redirected back to the terminal.
* Type ´cat /etc/fr24feed.ini´
* Your FlightRadar settings will be displayed. 
* Find the line starting with ´fr24key=´, and copy the string between the quotes. It will look something like this: dv4rrt2g122g7233.
* Click on the Device variablees-button D(x) in the left-hand menu. Add the following variable:
	* FR24_KEY, then paste your ´fr24key´ from the previous step, eg. dv4rrt2g122g7233.
* Restart the "fr24feed" application under "Services" by clicking the "cycle" button.
* As soon as your receiver starts receiving data, you will receive an e-mail from FlightRadar24 containing your login credentials.
* You are all set. Enjoy!
