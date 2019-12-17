FROM ruby:2.6.5-alpine

RUN apk add --update git build-base nodejs && \
    gem install bundler:2.0.2

RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

COPY Gemfile* /app/
WORKDIR /app
RUN bundle install

COPY . .

RUN chown -R appuser:appgroup /app

USER 1000

CMD ["smashing", "start"]

EXPOSE 3030
