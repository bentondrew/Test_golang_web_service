FROM golang:alpine as builder
COPY source/ $GOPATH/src/test_package/test_app
WORKDIR $GOPATH/src/test_package/test_app
RUN go get -d -v
RUN go build -o /go/bin/wiki

FROM scratch
LABEL maintainer="Benton Drew <benton.s.drew@drewantech.com>"
COPY --from=builder /go/bin/wiki /wiki
ENTRYPOINT ["/wiki"]
