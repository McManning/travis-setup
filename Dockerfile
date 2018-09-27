
FROM alpine:3.7

MAINTAINER Chase McManning <cmcmanning@gmail.com>

RUN apk update && \
    apk add --no-cache git openssh ruby ruby-dev build-base libffi-dev && \
    gem install travis --no-rdoc --no-ri

COPY setup.sh /setup.sh

ENTRYPOINT ["/setup.sh"]
