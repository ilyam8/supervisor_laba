FROM ubuntu:latest
RUN apt-get update && apt-get install -y supervisor wget ca-certificates
RUN wget https://my-netdata.io/kickstart.sh
RUN bash kickstart.sh --dont-wait --dont-start-it
RUN mkdir -p /opt
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY process1.sh /opt/process1.sh
COPY process2.sh /opt/process2.sh
COPY process3.sh /opt/process3.sh
COPY run.sh /run.sh
VOLUME ["/var/log/supervisor"]
RUN chmod +x /opt/*sh
RUN chmod +x /run.sh
EXPOSE 19999
CMD ["/run.sh"]
