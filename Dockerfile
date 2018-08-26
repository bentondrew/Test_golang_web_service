FROM golang:alpine as builder
RUN adduser -D -g '' gouser
COPY source/ $GOPATH/src/test_package/test_app
WORKDIR $GOPATH/src/test_package/test_app
RUN go get -d -v
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -ldflags="-w -s" -o /go/bin/wiki

FROM scratch
LABEL maintainer="Benton Drew <benton.s.drew@drewantech.com>"
COPY --from=builder /etc/passwd /etc/passwd
COPY --from=builder /etc/group /etc/group
COPY --chown=gouser --from=builder /go/bin/ /test_package/test_app/
USER gouser
WORKDIR /test_package/test_app/
EXPOSE 8080
ENTRYPOINT ["/test_package/test_app/wiki"]
