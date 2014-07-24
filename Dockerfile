FROM webdizz/baseimage-java8

MAINTAINER Izzet Mustafaiev "izzet@mustafaiev.com"

# Set correct environment variables.
ENV     HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Logstash version
ENV     LOGSTASH_VERSION    1.4.2
ENV     LOGSTASH_URL        https://download.elasticsearch.org/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz

ENV     OPT_DIR             /opt/logstash

# logstash
RUN	cd /tmp \
	&& curl -LO $LOGSTASH_URL \
	&& mkdir $OPT_DIR \
	&& cd $OPT_DIR/.. \
	&& tar zxf /tmp/logstash-${LOGSTASH_VERSION}.tar.gz \
	&& ln -s logstash-${LOGSTASH_VERSION} logstash \
	&& rm -rf /tmp/logstash-${LOGSTASH_VERSION}.tar.gz \
	&& mkdir /etc/logstash \
	&& mkdir /etc/service/logstash

ADD	logstash.conf /etc/logstash/logstash.conf

# add init script
ADD run /etc/service/logstash/run
RUN chmod +x /etc/service/logstash/run

# add GeoIP support
RUN cd /opt \
    && curl -LO http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
    && gunzip GeoLiteCity.dat.gz \
    && rm -rf GeoLiteCity.dat.gz


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*