# build stage
FROM ubuntu:latest as build-stage
WORKDIR /app
RUN apt-get update && apt-get install -y curl
RUN apt-get install -y gnupg2
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y  software-properties-common && \
    add-apt-repository ppa:webupd8team/java -y && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && \
    apt-get clean
RUN apt-get install -y ca-certificates && update-ca-certificates && apt-get install -y openssl
COPY package*.json ./
COPY . .
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN dpkg -i ./google-chrome-stable_current_amd64.deb; apt-get -fy install
RUN npm install
RUN npm run build
RUN npm run e2e
