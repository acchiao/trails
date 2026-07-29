# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

Greenfield Rails scaffold: no application code, migrations, tests, or fixtures exist yet. `db/` holds an empty `schema.rb` plus the Solid adapter schemas (`cache_schema.rb`, `queue_schema.rb`, `cable_schema.rb`) and seeds.

## Common Commands

- `bin/setup` - install deps (bundle + bun), prepare DB, start dev server; `--skip-server` skips the server (used by `bin/ci` and the devcontainer, not GitHub Actions), `--reset` also runs `db:reset`
- `bin/dev` - start dev server (Puma + JS/CSS watchers via Procfile.dev); auto-installs the `foreman` gem if missing
- `bin/rails test` / `bin/rails test:system` - unit/integration tests / system tests (Capybara + Selenium)
- `bin/rubocop` - lint Ruby (rubocop-rails-omakase); the only linter/formatter in the repo - JS/CSS/ERB have none
- `bin/brakeman --quiet --no-pager` - static security analysis; the binstub adds `--ensure-latest`, so a stale brakeman gem fails the run (update the gem - it is not a real finding)
- `bin/bundler-audit` - audit gems for known vulnerabilities
- `bin/jobs` - run Solid Queue workers outside Puma
- `bin/ci` - local CI pipeline; skips system tests (commented out in `config/ci.rb`) and is stricter than GitHub CI: brakeman warnings fail here, bundler-audit is allowed to fail on GitHub
- GitHub Actions (`.github/workflows/ci.yml`) runs 4 parallel jobs: `audit`, `lint`, `test`, `system-test`
- `bin/rails stimulus:manifest:update` - regenerate `app/javascript/controllers/index.js` after adding Stimulus controllers

## Architecture

Rails 8.1 / Ruby 4.0.2 app using **PostgreSQL**. JavaScript bundled with **Bun** via jsbundling-rails (`bun.config.js`). CSS via **Tailwind CSS v4** through cssbundling-rails. Assets served by **Propshaft**. Frontend uses **Hotwire** (Turbo + Stimulus). Deployment via **Kamal + Thruster**, but `config/deploy.yml` is still unconfigured generator scaffold (placeholder server IP and registry).

- **Solid adapters are production-only.** Production uses 4 PostgreSQL databases (primary, cache, queue, cable) with Solid Queue/Cache/Cable. Development and test use a single database each with the default async job adapter, memory/null cache store, and async cable - jobs and caching behave differently locally.
- **Solid Queue** runs inside Puma via `plugin :solid_queue` when `SOLID_QUEUE_IN_PUMA` is set (production default)
- **No importmap** - JS deps managed via `package.json` + `bun install` / `bun add` (not npm/yarn), bundled into `app/assets/builds/`
- **Active Storage** uses local disk (`:test` service in test) and needs **libvips** for image variants: `brew install vips` on macOS; CI and the Dockerfile install `libvips`
- **`DB_HOST` env var** switches `config/database.yml` to TCP with `postgres`/`postgres` credentials (the devcontainer sets it); unset means local socket
- **System tests** switch to remote Selenium when `CAPYBARA_SERVER_PORT` + `SELENIUM_HOST` are set (the devcontainer sets them)

## Conventions

- **Commits**: Conventional Commits (`feat:`, `fix:`, `ci:`, ...)
- **Testing**: Minitest with fixtures (not factories), parallel execution via `parallelize(workers: :number_of_processors)`
- **Generators do not auto-correct style** (`apply_rubocop_autocorrect_after_generate!` is commented out) - run `bin/rubocop -a` after `bin/rails generate`
- **Bundler 4 with lockfile checksums** - modifying gems with an older Bundler strips the `sha256` checksums from `Gemfile.lock`
