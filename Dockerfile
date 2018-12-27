#
# Copyright (C) 2018 IOTech Ltd
#
# SPDX-License-Identifier: Apache-2.0

FROM golang:1.11.2-alpine3.7 AS builder

ENV GOPATH=/go
ENV PATH=$GOPATH/bin:$PATH

RUN echo http://nl.alpinelinux.org/alpine/v3.7/main > /etc/apk/repositories; \
    echo http://nl.alpinelinux.org/alpine/v3.7/community >> /etc/apk/repositories

RUN apk update && apk add make && apk add bash
RUN apk add curl && apk add git && apk add openssh && apk add build-base && apk add tree

RUN pwd

ADD device-mqtt-go/getglide.sh .
RUN sh ./getglide.sh
# set the working directory
WORKDIR $GOPATH/src/github.com/edgexfoundry/device-mqtt-go

COPY ./device-mqtt-go .
ADD ./edgex-go/ ../edgex-go/
ADD ./device-sdk-go/ ../device-sdk-go/


RUN go get github.com/BurntSushi/toml
RUN go get github.com/cisco/senml
RUN go get github.com/eclipse/paho.mqtt.golang
RUN go get github.com/globalsign/mgo/bson
RUN go get github.com/go-kit/kit/log
RUN go get gopkg.in/mgo.v2/bson
RUN go get github.com/google/uuid
RUN go get github.com/gorilla/mux
RUN go get github.com/hashicorp/consul/api
RUN go get github.com/robfig/cron
RUN go get gopkg.in/yaml.v2

RUN make build


FROM scratch

ENV APP_PORT=49982
EXPOSE $APP_PORT

COPY --from=builder /go/src/github.com/edgexfoundry/device-mqtt-go/cmd /

ENTRYPOINT ["/device-mqtt","--registry","--profile=docker","--confdir=/res"]
