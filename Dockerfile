FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev patch ruby-dev zlib1g-dev liblzma-dev
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile

RUN rm -f /myapp/Gemfile.lock && rm -f /myapp/tmp/pids/server.pid
RUN bundle install
RUN apt-get install -y graphviz
ADD . /myapp
