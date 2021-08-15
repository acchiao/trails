FROM ruby:3.0.2-slim-buster as webpacker

WORKDIR /app

ARG RAILS_ENV=production
ARG NODE_ENV=production

ENV RAILS_ENV=${RAILS_ENV} \
      NODE_ENV=${NODE_ENV} \
      TRAILS_HOME=/app

ENV PATH=${TRAILS_HOME}/bin:${PATH}

RUN apt-get update \
      && apt-get install --yes --no-install-recommends \
        build-essential \
        curl \
        git \
        libpq-dev \
      && curl -sSL https://deb.nodesource.com/setup_14.x | bash - \
      && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
      && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
      && apt-get update && apt-get install --yes --no-install-recommends \
        nodejs \
        yarn \
      && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
      && apt-get clean

RUN gem install bundler --no-document --version 2.2.25

COPY Gemfile Gemfile.lock /app/
RUN bundle config set deployment 'true' \
      && bundle config set without 'development:test' \
      && bundle install --jobs $(nproc)

COPY package.json yarn.lock ${PLATFORM_HOME}/
RUN yarn install --frozen-lockfile --check-files \
      && yarn cache clean

COPY . /app/

RUN RAILS_SERVE_STATIC_FILES=enabled \
      SECRET_KEY_BASE=proxy \
      bundle exec rails assets:precompile

FROM ruby:3.0.2-slim-buster AS app

WORKDIR /app

ARG RAILS_ENV=production
ARG NODE_ENV=production

ENV RAILS_ENV=${RAILS_ENV} \
      NODE_ENV=${NODE_ENV} \
      TRAILS_HOME=/app

ENV PATH=${TRAILS_HOME}/bin:${PATH}

RUN apt-get update \
      && apt-get install --yes --no-install-recommends \
        build-essential \
        libpq-dev \
      && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
      && apt-get clean

COPY --from=webpacker /usr/local/bundle /usr/local/bundle
COPY --from=webpacker /app/public /app/public
COPY . /app/

EXPOSE 3000

CMD ["rails", "server", "-p", "3000"]