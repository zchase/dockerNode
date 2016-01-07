FROM    ubuntu:14.04

# Enable Extra Packages for Enterprise Linux (EPEL) for CentOS
RUN     apt-get update
# Install Node.js and npm
RUN     apt-get install nodejs -y
RUN     apt-get install npm -y

# Install app dependencies
COPY package.json /src/package.json
RUN cd /src; npm install

# Bundle app source
COPY . /src

EXPOSE  8080
CMD ["node", "/src/index.js"]