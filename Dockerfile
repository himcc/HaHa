FROM ubuntu:14.04
RUN apt-get update
RUN apt-get install -y openssh-server vim supervisor
RUN mkdir /var/run/sshd
RUN echo 'root:root' |chpasswd
RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
COPY sshd.conf /etc/supervisor/conf.d/sshd.conf
EXPOSE 22
CMD /usr/bin/supervisord -n
