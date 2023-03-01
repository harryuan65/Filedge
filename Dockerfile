FROM ruby:3.0.3-alpine
WORKDIR /app

ARG RUBY_PACKAGES="build-base postgresql-dev tzdata"
# Fix nokogiri .so version error
ARG NOKOGIRI_PACKAGES="gcompat"
RUN apk upgrade \
  && apk add --update --no-cache $RUBY_PACKAGES $NOKOGIRI_PACKAGES\
  && gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install -j 8
COPY . .

ENV RAILS_ENV=production
ENV RAILS_SERVIE_STATIC_FILES=true

EXPOSE 3000

CMD ["bundle","exec","rails", "server", "-p", "3000"]


