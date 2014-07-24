docker-logstash-worker
======================

[Docker](https://www.docker.com/) image to run [Logstash](http://logstash.net/) as a service.

### Features:

* Base image is [webdizz/baseimage-java8](https://github.com/webdizz/docker-baseimage-java8)
* Support for [GeoIP](https://www.maxmind.com/en/geolocation_landing)
 
### Getting started
 
    dooker run -d -v logstash.conf:/etc/logstash/logstash.conf webdizz/logstash-agent  
