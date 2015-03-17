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

RUN apt-get -y install mysql-server mysql-client


# Switch back to jboss user
USER meruvian

# Set the JAVA_HOME variable to make it clear where Java is located
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# Install Jetty
RUN wget -O /opt/jetty.tar.gz "http://eclipse.org/downloads/download.php?file=/jetty/9.0.7.v20131107/dist/jetty-distribution-9.0.7.v20131107.tar.gz&r=1"
RUN tar -xvf /opt/jetty.tar.gz -C /opt/
RUN rm /opt/jetty.tar.gz
RUN mv /opt/jetty-distribution-9.0.7.v20131107 /opt/jetty
RUN rm -rf /opt/jetty/webapps.demo
RUN useradd jetty -U -s /bin/false
RUN chown -R jetty:jetty /opt/jetty


# Set the WILDFLY_VERSION env variable
ENV YAMA_VERSION 2.0.Final

RUN cd $HOME && curl -O http://download.madcoder.org/yama/$YAMA_VERSION/yama-$YAMA_VERSION.zip && unzip yama-$YAMA_VERSION.zip && mv $HOME/yama-$YAMA_VERSION $HOME/yama && rm wildfly-$YAMA_VERSION.zip

# Set the YAMA_HOME env variable
ENV YAMA_HOME /opt/meruvian/yama

# Run Jetty
EXPOSE 8080
CMD ["java", "-Djetty.home=/opt/jetty", "-jar", "/opt/jetty/start.jar"]
