From ruby:2.3.3

RUN apt-get update && \
    apt-get install -y nodejs && \
    mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install
COPY . /usr/src/app
RUN bundle exec rake db:create
RUN bundle exec rake db:migrate

EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
