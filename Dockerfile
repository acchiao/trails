# syntax=docker.io/docker/dockerfile:1
FROM ruby:3.1.0-slim-buster AS webpacker

ARG RAILS_ENV=production
ARG NODE_ENV=production
ARG BUNDLER_VERSION=2.6.2

ENV RAILS_ENV="${RAILS_ENV}" \
  NODE_ENV="${NODE_ENV}" \
  TRAILS_HOME=/app

ENV PATH="${TRAILS_HOME}/bin:${PATH}"

WORKDIR /app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
  && curl -sSL https://deb.nodesource.com/setup_18.x | bash - \
  && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install --yes --no-install-recommends \
    nodejs \
    yarn \
  && rm -rf \
    /var/lib/apt/lists/* \
    /usr/share/doc \
    /usr/share/man

RUN gem update --system --no-document \
  && gem install bundler --no-document --version "${BUNDLER_VERSION}"

COPY Gemfile Gemfile.lock /app/
RUN bundle config set deployment 'true' \
  && bundle config set without 'development:test' \
  && bundle install --jobs "$(nproc)" --no-cache

COPY package.json yarn.lock /app/
RUN yarn install --frozen-lockfile --check-files --audit \
  && yarn cache clean

COPY . /app/

RUN RAILS_SERVE_STATIC_FILES=enabled \
  NODE_OPTIONS=--openssl-legacy-provider \
  SECRET_KEY_BASE=placeholder \
  bundle exec rails assets:precompile \
  && bundle exec bootsnap precompile --gemfile app/ lib/

FROM ruby:3.1.0-slim-buster AS app

WORKDIR /app

ARG RAILS_ENV=production
ARG NODE_ENV=production

ENV RAILS_ENV="${RAILS_ENV}" \
  NODE_ENV="${NODE_ENV}" \
  TRAILS_HOME=/app

ENV PATH="${TRAILS_HOME}/bin:${PATH}"

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
    build-essential \
    libpq-dev \
  && rm -rf \
    /var/lib/apt/lists/* \
    /usr/share/doc \
    /usr/share/man

COPY --from=webpacker /usr/local/bundle /usr/local/bundle
COPY --from=webpacker /app/vendor /app/vendor
COPY --from=webpacker /app/public /app/public
COPY --from=webpacker /app/tmp /app/tmp

COPY . /app/

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]

FROM app AS production

CMD ["bash"]

FROM app AS staging

CMD ["bash"]
