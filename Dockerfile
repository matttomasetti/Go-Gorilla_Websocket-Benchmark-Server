FROM ubuntu

# Set timezone
ENV TZ=America/New_York
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add source files to docker image
ADD .	/home/websocket

# Tell image to use bach rather than sh
SHELL ["/bin/bash", "-c"] 

# Update and install dependencies
RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get -y install curl git

# Install Go
RUN cd /home/websocket \
    && curl -O https://storage.googleapis.com/golang/go1.15.6.linux-amd64.tar.gz \
    && tar -xvf go1.15.6.linux-amd64.tar.gz \
    && chown -R root:root ./go \
    && mv go /usr/local \
    && echo "export GOPATH=/home/websocket" >> ~/.profile \
    && echo "export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >> ~/.profile \
    && source ~/.profile \

# Build project
    && go get github.com/gorilla/websocket \
    && go build go-gorilla_websocket-benchmark-server.go

    
EXPOSE 8080

WORKDIR /home/websocket
CMD ["./go-gorilla_websocket-benchmark-server"]
