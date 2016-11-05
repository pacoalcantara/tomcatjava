#
# VERSION 0.0.1
#
 
FROM ubuntu:14.04
MAINTAINER pacoalcantara
 
# Setup
RUN apt-get update && apt-get install -y software-properties-common debconf-utils
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
 
# Java7
RUN echo "oracle-java7-installer shared/accepted-oracle-license-v1-1 boolean true" | debconf-set-selections
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get install -y oracle-java7-installer
 
# Tomcat
RUN apt-get install -y tomcat7
ENV JAVA_HOME /usr/lib/jvm/java-7-oracle/jre
 
RUN rm -r /var/lib/tomcat7/webapps/ROOT
COPY ./WEB-INF /tmp/
RUN jar -cf /tmp/webapp.war /tmp/WEB-INF
ADD ./webapp.war /var/lib/tomcat7/webapps/ROOT.war
 
EXPOSE 8081
CMD /etc/init.d/tomcat7 start && wait && tail -f /var/lib/tomcat7/logs/catalina.out