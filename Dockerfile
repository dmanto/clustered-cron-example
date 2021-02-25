FROM perl
RUN apt-get -y update && apt-get -y install etcd
WORKDIR /opt/myapp
COPY . .
RUN cpanm --installdeps -n .
EXPOSE 3000
CMD ./myapp.pl prefork