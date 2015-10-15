# place this in your project folder next to buikldozer.spec
# docker build -t buildozer .
# docker run buildozer
# your package should then be built 
# VERSION               0.0.1

FROM     ubuntu:15.04
MAINTAINER Oliver Marks "olymk2@gmail.com"

# make sure the package repository is up to date

RUN apt-get update 
RUN apt-get -y upgrade
RUN apt-get install -y \
    wget nano curl unzip zlib1g-dev lib32z1 \
    software-properties-common build-essential libc6-dev-i386 \
    python-dev python-pil git python-virtualenv python-pip python-markupsafe \
    openjdk-7-jdk ragel android-tools-adb android-tools-fastboot

RUN pip install cython==0.21.2
RUN pip install buildozer

RUN adduser --disabled-password --gecos 'builduser' builduser
RUN usermod -g plugdev,builduser builduser
RUN chmod -R 777 /opt 
RUN cd /home/builduser

RUN pip install cython==0.21.2
RUN pip install buildozer

RUN mkdir -p /opt/app/

WORKDIR /opt/app

RUN mkdir -p /opt/buildozer/fabricad/.buildozer/android/platform/python-for-android && mkdir -p /opt/android/ && mkdir -p /opt/app/.buildozer/android/platform/python-for-android && cd /opt/android/ && \ 
    git clone https://github.com/olymk2/python-for-android.git && \
    cd python-for-android && git checkout feature/freetype-recipe

RUN chmod -R 777 /opt

USER builduser

#set android enviroment vars
ENV ANDROIDSDK /opt/buildozer/fabricad/.buildozer/android/android-sdk-linux_86/
ENV ANDROIDNDK /opt/buildozer/fabricad/.buildozer/android/android-ndk-r8c/
ENV ANDROIDNDKVER r8c
ENV ANDROIDAPI 14

#create a test build folder so we can run buildozer and get the android platform
RUN mkdir /opt/test_build
WORKDIR /opt/test_build
RUN buildozer init
RUN buildozer android update

#switch to folder with sdk tools and pull in the missing SDK
WORKDIR /home/builduser/.buildozer/android/platform/android-sdk-20/tools 
RUN ./android list sdk --all
RUN ./android update sdk -u -a -t 1,2

EXPOSE 5037

WORKDIR /opt/app
ENTRYPOINT ["/bin/bash", "-c", "buildozer android debug deploy run"]



#adjust the paths above for your package

#to build the image run "docker build -t buildozer ."
#to generate your apk run "docker run -v --privileged -v /dev/bus/usb:/dev/bus/usb -v /etc/udev/rules.d/:/etc/udev/rules.d/ -v path/to/your/app/with/buildozer.spec:/opt/app buildozer"
