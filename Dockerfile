FROM webdizz/baseimage-java8

MAINTAINER Izzet Mustafaiev "izzet@mustafaiev.com"

# Set correct environment variables.
ENV     HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# add GeoIP support
RUN cd /opt \
    && curl -LO http://geolite.maxmind.com/download/geoip/database/GeoLiteCity.dat.gz \
    && gunzip GeoLiteCity.dat.gz \
    && rm -rf GeoLiteCity.dat.gz

# Logstash version
ENV     LOGSTASH_VERSION    1.4.2
ENV     LOGSTASH_URL        https://download.elasticsearch.org/logstash/logstash/logstash-${LOGSTASH_VERSION}.tar.gz

# logstash
RUN	cd /tmp \
	&& curl -LO $LOGSTASH_URL \
	&& mkdir -p /opt \
	&& cd /opt \
	&& tar zxf /tmp/logstash-${LOGSTASH_VERSION}.tar.gz \
	&& mv logstash-${LOGSTASH_VERSION} logstash \
	&& rm -rf /tmp/logstash-${LOGSTASH_VERSION}.tar.gz \
	&& mkdir -p /etc/logstash \
	&& mkdir -p /etc/service/logstash

ADD	logstash.conf /etc/logstash/logstash.conf

# add init script
ADD logstash.sh /etc/service/logstash/run
RUN chmod +x /etc/service/logstash/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*