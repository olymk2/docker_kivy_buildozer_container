Buildozer docker container
=========================

Docker container to give you a clean enviroment to build your applications.

building the image
-----------------

You can build the container from scratch using the command below in your terminal

```docker build -t buildozer .```

Compile and deploying your application
-------------------------------------

To generate and deploy your apk run the command below updating path/to/your/app/with/buildozer_file to be the folder with your application on your host

```docker run -v --privileged -v /dev/bus/usb:/dev/bus/usb -v /etc/udev/rules.d/:/etc/udev/rules.d/ -v path/to/your/app/with/buildozer_file:/opt/app buildozer```

You can override the entry point if you like to run your own buildozer folder with --entrypoint see below for example

```docker run -v --privileged -v /dev/bus/usb:/dev/bus/usb -v /etc/udev/rules.d/:/etc/udev/rules.d/ -v path/to/your/app/with/buildozer.spec:/opt/app buildozer```
