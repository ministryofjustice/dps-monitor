FROM ruby:2-alpine

RUN apk add --update git build-base nodejs && \
    gem install bundler:2.0.2

RUN addgroup -g 2000 -S appgroup && \
    adduser -u 2000 -S appuser -G appgroup

RUN mkdir /app && chown appuser:appgroup /app
COPY --chown=appuser:appgroup Gemfile* /app/
USER 2000
WORKDIR /app
RUN bundle install --path=/app/.gem

ADD --chown=appuser:appgroup . .

USER 2000

CMD ["smashing", "start"]

EXPOSE 3030
