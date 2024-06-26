FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev patch ruby-dev zlib1g-dev liblzma-dev graphviz
RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile

RUN bundle install
ADD . /myapp
