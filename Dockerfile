FROM ubuntu:20.04

RUN apt update

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get install -y git g++ cmake ninja-build libxcursor-dev libgl1-mesa-dev libfontconfig1-dev python python3
RUN apt-get install -y libx11-dev xorg-dev valgrind x11-apps
RUN apt-get install -y openjdk-11-jre
RUN apt-get install -y curl nano wget

RUN apt-get install -y tmux
RUN mkdir /mnt/host

RUN useradd -ms /bin/bash elastic
USER elastic
WORKDIR /home/elastic

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.11.1-linux-x86_64.tar.gz
RUN wget https://artifacts.elastic.co/downloads/kibana/kibana-7.11.1-linux-x86_64.tar.gz

RUN tar -xzf elasticsearch-7.11.1-linux-x86_64.tar.gz
RUN tar -xzf kibana-7.11.1-linux-x86_64.tar.gz

RUN echo 'network.host: 0.0.0.0' >> /home/elastic/elasticsearch-7.11.1/config/elasticsearch.yml
RUN echo 'transport.host: localhost' >> /home/elastic/elasticsearch-7.11.1/config/elasticsearch.yml
RUN echo 'transport.tcp.port: 9300' >> /home/elastic/elasticsearch-7.11.1/config/elasticsearch.yml
RUN echo 'http.port: 9200' >> /home/elastic/elasticsearch-7.11.1/config/elasticsearch.yml

RUN echo 'server.host: "0.0.0.0"' >> /home/elastic/kibana-7.11.1-linux-x86_64/config/kibana.yml
RUN echo 'elasticsearch.hosts: ["http://0.0.0.0:9200"]' >> /home/elastic/kibana-7.11.1-linux-x86_64/config/kibana.yml

RUN echo '#!/bin/bash\n /home/elastic/elasticsearch-7.11.1/bin/elasticsearch & \nsleep 10s \n/home/elastic/kibana-7.11.1-linux-x86_64/bin/kibana ' >> run_server.sh
RUN chmod +x run_server.sh

CMD "./run_server.sh"


