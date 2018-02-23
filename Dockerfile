FROM node:9-alpine

ENV PHANTOMJS_ARCHIVE="phantomjs.tar.gz"
RUN echo '@edge http://nl.alpinelinux.org/alpine/edge/main'>> /etc/apk/repositories \
	&& apk --update add curl

RUN curl -Lk -o $PHANTOMJS_ARCHIVE https://github.com/fgrehm/docker-phantomjs2/releases/download/v2.0.0-20150722/dockerized-phantomjs.tar.gz \
	&& tar -xf $PHANTOMJS_ARCHIVE -C /tmp/ \
	&& cp -R /tmp/etc/fonts /etc/ \
	&& cp -R /tmp/lib/* /lib/ \
	&& cp -R /tmp/lib64 / \
	&& cp -R /tmp/usr/lib/* /usr/lib/ \
	&& cp -R /tmp/usr/lib/x86_64-linux-gnu /usr/ \
	&& cp -R /tmp/usr/share/* /usr/share/ \
	&& cp /tmp/usr/local/bin/phantomjs /usr/bin/ \
	&& rm -fr $PHANTOMJS_ARCHIVE  /tmp/*

WORKDIR /usr/charts-server

COPY . .

RUN addgroup -S app && adduser -S -G app app
RUN chown -R app /usr/charts-server
USER app

ENV ACCEPT_HIGHCHARTS_LICENSE YES
ENV HIGHCHARTS_VERSION latest
ENV HIGHCHARTS_USE_STYLED NO
RUN npm install

EXPOSE 5000

CMD ["npm", "start"]
