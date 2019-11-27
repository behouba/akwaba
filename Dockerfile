FROM golang

WORKDIR /akwaba

COPY . /akwaba

RUN GOBIN=$PWD/`dirname $0`/bin go install -v ./cmd/...