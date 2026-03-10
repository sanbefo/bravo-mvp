FROM ruby:3.3.0-alpine

RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    nodejs \
    npm \
    yarn \
    tzdata \
    gcompat \
    libstdc++

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs 4

COPY package.json yarn.lock ./
RUN yarn install

COPY . .

RUN RAILS_ENV=production SECRET_KEY_BASE_DUMMY=1 bundle exec rails assets:precompile

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
