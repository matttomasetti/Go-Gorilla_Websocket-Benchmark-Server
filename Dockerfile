FROM ubuntu

ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ADD .	/home/websocket

SHELL ["/bin/bash", "-c"] 

RUN apt-get -y update \
    && apt-get -y upgrade \
    #install dependencies
    && apt-get -y install curl git \
    && cd /home/websocket \
    && curl -O https://storage.googleapis.com/golang/go1.15.6.linux-amd64.tar.gz \
    && tar -xvf go1.15.6.linux-amd64.tar.gz \
    && chown -R root:root ./go \
    && mv go /usr/local \
    && echo "export GOPATH=/home/websocket" >> ~/.profile \
    && echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.profile \
    && source ~/.profile \
    && go get github.com/gorilla/websocket \
    && go build go-gorilla_websocket-benchmark-server.go

    
EXPOSE 8080

WORKDIR /home/websocket
CMD ["./go-gorilla_websocket-benchmark-server"]
