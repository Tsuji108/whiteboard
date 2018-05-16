From ruby:2.3.3

RUN apt-get update && apt-get install -y \
    nodejs \
    imagemagick

COPY Gemfile* /tmp/
WORKDIR /tmp 
RUN bundle install 

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ADD . /usr/src/app

VOLUME /usr/src/app/public
VOLUME /usr/src/app/tmp

EXPOSE 3000
CMD bundle exec rails server -b 0.0.0.0
