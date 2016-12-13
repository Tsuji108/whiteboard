From ruby:2.3.3

RUN mkdir -p /usr/src/app
COPY . /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y nodejs && \
    bundle install

EXPOSE 3000
CMD bundle exec rails server -b 0.0.0.0
