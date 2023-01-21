FROM ruby:2.3
RUN apt-get update && apt-get -y install build-essential libpq-dev nodejs
RUN gem install bundler -v 1.17.3
RUN mkdir /ssh-agent
RUN mkdir /sapi
WORKDIR /sapi
ADD Gemfile /sapi/Gemfile
ADD Gemfile.lock /sapi/Gemfile.lock
RUN bundle _1.17.3_ install

ADD . /sapi
