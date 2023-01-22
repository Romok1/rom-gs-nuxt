FROM ruby:2.3
RUN apt-get update && apt-get -y install build-essential libpq-dev nodejs
RUN gem install bundler -v 1.17.3

#added
ARG user=romi
ARG group=romi
ARG gid=1000
ARG uid=1000

#only this was present- RUN mkdir /sapiadder
RUN mkdir /sapiadder && \
    chown -R 1000:1000 /sapiadder
RUN groupadd -g ${gid} ${group} && useradd -u ${uid} -g ${group} -d /sapiadder -s /bin/bash ${user}
    
#just added
USER romi

WORKDIR /sapiadder
ADD Gemfile /sapiadder/Gemfile
ADD Gemfile.lock /sapiadder/Gemfile.lock
RUN bundle _1.17.3_ install

#ADD . /sapiadder
COPY --chown=${user}:${group} . /sapiadder
