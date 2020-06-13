ARG VERSION=dev
FROM golang:1.14-alpine AS build
RUN apk add --no-cache gcc libc-dev

WORKDIR /go/src/app
COPY . .
RUN go test ./...
RUN mkdir /releases

ARG version=dev
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags "-X main.Version=$version" -o /releases/certinfo
RUN tar -czvf /releases/certinfo_linux.tar.gz -C /releases/ certinfo
RUN rm /releases/certinfo

RUN CGO_ENABLED=0 GOOS=darwin go build -ldflags "-X main.Version=$version" -o /releases/certinfo
RUN tar -czvf /releases/certinfo_darwin.tar.gz -C /releases/ certinfo
RUN rm /releases/certinfo

RUN CGO_ENABLED=0 GOOS=windows go build -ldflags "-X main.Version=$version" -o /releases/certinfo.exe
RUN tar -czvf /releases/certinfo_windows.tar.gz -C /releases/ certinfo.exe
RUN rm /releases/certinfo.exe