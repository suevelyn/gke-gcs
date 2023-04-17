FROM golang:1.20.0-alpine AS gcsfuse

RUN apk add --no-cache git
ENV GOPATH /go
RUN go env
RUN go install github.com/googlecloudplatform/gcsfuse@latest

FROM nginx:alpine

RUN apk add --no-cache ca-certificates fuse

COPY --from=gcsfuse /go/bin/gcsfuse /usr/local/bin

# Bucket files will be mounted here
RUN mkdir -p /usr/share/nginx/bucket-data

# Or any other port you use in nginx.cong
EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
