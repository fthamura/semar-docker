FROM ubuntu
MAINTAINER Frans Thamura <frans@meruvian.com>

RUN apt-get update
RUN apt-get upgrade -y

# Install packages necessary to run 
RUN apt-get -y install unzip curl

# Create a user and group used to launch processes
# The user ID 1000 is the default for the first "regular" user on Fedora/RHEL,
# so there is a high chance that this ID will be equal to the current user
# making it easier to use volumes (no permission issues)
RUN groupadd -r meruvian -g 1000 && useradd -u 1000 -r -g meruvian -m -d /opt/meruvian -s /sbin/nologin -c "Meruvian user" meruvian

# Set the working directory to jboss' user home directory
WORKDIR /opt/meruvian

# User root user to install software
USER root

# Install necessary packages
RUN apt-get -y install openjdk-7-jdk

# Switch back to jboss user
USER meruvian

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Set the WILDFLY_VERSION env variable
ENV YAMA_VERSION 2.0.Final

RUN cd $HOME && curl -O http://download.madcoder.org/yama/$YAMA_VERSION/yama-$YAMA_VERSION.zip && unzip yama-$YAMA_VERSION.zip && mv $HOME/yama-$YAMA_VERSION $HOME/yama && rm wildfly-$YAMA_VERSION.zip

# Set the YAMA_HOME env variable
ENV YAMA_HOME /opt/meruvian/yama

# Expose the ports we're interested in
EXPOSE 8080 

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/meruvian/yama/bin/standalone.sh"]
