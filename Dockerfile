FROM ruby:3.0-slim-bullseye

ARG BUILD_NUMBER
ARG GIT_REF

RUN apt update && \
    apt -y upgrade && \
    apt-get install -y curl g++ gcc make musl-dev nodejs && \
    rm -rf /var/lib/apt/lists/*

ENV TZ=Europe/London
RUN ln -snf "/usr/share/zoneinfo/$TZ" /etc/localtime && echo "$TZ" > /etc/timezone

RUN mkdir /app
RUN addgroup --gid 2000 appgroup && \
  adduser --uid 2000 --disabled-password --ingroup appgroup --home /app appuser
RUN chown appuser:appgroup /app

USER 2000
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

RUN bundle config set --local without 'dev' && \
  bundle config set --local deployment 'true' && \
  bundle config set --local frozen 'true' && \
  bundle install

COPY . .

EXPOSE 3030

CMD ["bundle", "exec", "smashing", "start", "-p", "3030", "-e", "production"]
