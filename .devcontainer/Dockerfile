FROM golang:buster

ARG HUGO=0.76.2

RUN mkdir -p /tmp/hugo && \
    curl -sSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO}/hugo_extended_${HUGO}_Linux-64bit.tar.gz" | tar zx -C /tmp/hugo && \
    cp /tmp/hugo/hugo /usr/local/bin/ && \
    rm -rf /tmp/hugo

EXPOSE 1313
