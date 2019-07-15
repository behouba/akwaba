FROM golang

WORKDIR /akwaba/website

COPY . /akwaba

RUN go build -o website .