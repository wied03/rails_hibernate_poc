FROM jruby:9.0.5
RUN gem install rails -v 4.2.6
RUN gem install jbundler
CMD RACKUP_IP=`ip addr list eth1 | grep 192.168 | awk '{print $2}' | sed -E s/\\\\/.*//g` bash
