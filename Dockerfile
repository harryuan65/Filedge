FROM ruby:3.0.3
WORKDIR /app
COPY Gemfile Gemfile.lock ./
COPY entrypoint.sh ./entrypoint.sh
RUN gem install bundler:2.3.4
RUN bundle install
COPY . .

ENV RAILS_ENV=production
ENV RAILS_SERVIE_STATIC_FILES=true

ARG SECRET_KEY_BASE=assets
RUN bin/rails assets:clobber && bin/rails assets:precompile

# CMD ["bin/rails", "server", "-p", "3000", "-b", "0.0.0.0"]
ENTRYPOINT [ "./entrypoint.sh" ]
CMD [ "start_service" ]


