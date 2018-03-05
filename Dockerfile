FROM node:9-alpine

# Build-time
RUN set -ex \
  && apk add --no-cache --virtual .build-deps ca-certificates openssl \
  && wget -qO- "https://github.com/dustinblackman/phantomized/releases/download/2.1.1/dockerized-phantomjs.tar.gz" | tar xz -C /

WORKDIR /usr/charts-server
COPY . .

RUN addgroup -S app && adduser -S -G app app
RUN chown -R app /usr/charts-server
USER app

ENV ACCEPT_HIGHCHARTS_LICENSE YES
ENV HIGHCHARTS_VERSION latest
ENV HIGHCHARTS_USE_STYLED NO
RUN npm install

USER root
RUN apk del .build-deps

# Run-time
USER app

EXPOSE 5000

CMD ["npm", "start"]
