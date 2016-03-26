FROM jruby:9.0.5
RUN gem install rails -v 4.2.6
RUN gem install jbundler
# jruby image does not have javac and we need that for Hibernate models
RUN apt-get update && apt-get install -y openjdk-8-jdk
CMD RACKUP_IP=`ip addr list eth1 | grep 192.168 | awk '{print $2}' | sed -E s/\\\\/.*//g` bash
