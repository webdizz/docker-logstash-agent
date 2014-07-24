#!/bin/sh

exec /opt/logstash/bin/logstash agent -f /etc/logstash/logstash.conf >> /var/log/logstash.log 2>&1
