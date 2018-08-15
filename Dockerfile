FROM amazonlinux

RUN \
  yum update -y &&\
  yum -y install wget tar zip &&\
  yum -y groupinstall 'Development Tools' &&\
  echo ZONE=\"US/Eastern\" > /etc/sysconfig/clock &&\
  ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime

### NODEJS ###
ENV NODEJS_VERSION v6.11.4
ENV NODEJS_SHA1 75b22881b4581bc7b09d0f829c06ad1c1f1fd92e

RUN \
  wget http://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION.tar.gz -O /tmp/node-$NODEJS_VERSION.tar.gz &&\
  echo "$NODEJS_SHA1  /tmp/node-$NODEJS_VERSION.tar.gz" | sha1sum -c &&\
  cd /tmp &&\
  tar xvzf /tmp/node-$NODEJS_VERSION.tar.gz &&\
  cd node-$NODEJS_VERSION &&\
  ./configure --prefix=/usr && make && make install &&\
  rm -rf /tmp/*

# Install app dependencies
COPY package.json /src/package.json
RUN cd /src; npm install

# Bundle app source
COPY . /src

EXPOSE  8080
CMD ["node", "/src/index.js"]