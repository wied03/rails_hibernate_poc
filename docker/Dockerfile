FROM jruby:9.0.5
# Get all of our deps preloaded
RUN cd /tmp; wget https://github.com/wied03/rails_hibernate_poc/archive/master.zip; unzip master.zip; cd rails_hibernate_poc-master; bundle install; jbundle install
RUN rm -rf /tmp/rails_hibernate_poc-master; rm -rf /tmp/master.zip
# jruby image does not have javac and we need that for jrubyc --javac (tinkering with precompiling models)
RUN apt-get update && apt-get install -y openjdk-8-jdk
CMD RACKUP_IP=`ip addr list eth1 | grep 192.168 | awk '{print $2}' | sed -E s/\\\\/.*//g` bash
