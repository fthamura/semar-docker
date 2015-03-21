FROM ubuntu
MAINTAINER Frans Thamura <frans@meruvian.com>

RUN apt-get update
RUN apt-get upgrade -y

# Install packages necessary to run 
RUN apt-get -y install unzip curl wget

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

RUN apt-get -y install mysql-server mysql-client


# Switch back to meruvian user
USER meruvian

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ENV JETTY_VERSION 9.2.4
ENV RELEASE_DATE v20141103
RUN wget http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    tar -xzvf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    rm -rf jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}.tar.gz && \
    mv jetty-distribution-${JETTY_VERSION}.${RELEASE_DATE}/ /opt/jetty


# Set the WILDFLY_VERSION env variable
ENV YAMA_VERSION 2.0.Final

# RUN cd $HOME && curl -O http://download.madcoder.org/yama/$YAMA_VERSION/yama-$YAMA_VERSION.zip && unzip yama-$YAMA_VERSION.zip && mv $HOME/yama-$YAMA_VERSION $HOME/yama && rm wildfly-$YAMA_VERSION.zip

# Set the YAMA_HOME env variable
ENV YAMA_HOME /opt/meruvian/yama

# Run Jetty
EXPOSE 8080
CMD ["java", "-Djetty.home=/opt/jetty", "-jar", "/opt/jetty/start.jar"]
