# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

### Development

- `bin/setup` — install deps (bundle + bun), prepare DB, start server
- `bin/dev` — start dev server (Puma + JS/CSS watchers via Procfile.dev)
- `bin/rails console` — open Rails console
- `bin/rails db:prepare` — create/migrate the database

### Testing

- `bin/rails test` — run all unit/integration tests
- `bin/rails test test/models/foo_test.rb` — run a single test file
- `bin/rails test test/models/foo_test.rb:42` — run a single test by line number
- `bin/rails test:system` — run system tests (Capybara + Selenium)
- `bin/rails db:test:prepare` — required before first test run

### Linting & Security

- `bin/rubocop` — lint Ruby (rubocop-rails-omakase style)
- `bin/rubocop -a` — auto-correct lint violations
- `bin/brakeman --quiet --no-pager` — static security analysis
- `bin/bundler-audit` — audit gems for known vulnerabilities

### CI

- `bin/ci` — full CI pipeline: setup, rubocop, bundler-audit, brakeman, tests, seed check

## Architecture

Rails 8.1 / Ruby 4.0.2 app using **PostgreSQL** for all databases. JavaScript bundled with **Bun** via jsbundling-rails (`bun.config.js`). CSS via **Tailwind CSS v4** through cssbundling-rails (`@tailwindcss/cli`). Assets served by **Propshaft**. Frontend uses **Hotwire** (Turbo + Stimulus). Background jobs, caching, and WebSockets use Solid adapters (Queue, Cache, Cable) backed by separate PostgreSQL databases. Deployment via **Kamal + Thruster**.

### Key Architectural Details

- **No importmap** — JS dependencies managed via `package.json` + `bun install`, bundled by `bun.config.js` into `app/assets/builds/`
- **Procfile.dev** runs three processes: Rails server, JS watcher (`bun run build --watch`), CSS watcher (`bun run build:css --watch`)
- **Production** uses 4 PostgreSQL databases: primary, cache, queue, cable (see `config/database.yml`)
- **Solid Queue** runs inside Puma via `plugin :solid_queue` when `SOLID_QUEUE_IN_PUMA=true` (production default)
- **No migrations yet** — `db/` only has Solid adapter schemas (`cache_schema.rb`, `queue_schema.rb`, `cable_schema.rb`) and seeds
- **Stimulus controllers** live in `app/javascript/controllers/`, auto-registered via `controllers/index.js`
- **CI config** defined in `config/ci.rb` (used by `bin/ci`) and `.github/workflows/ci.yml`

### Conventions

- **Linting**: rubocop-rails-omakase (Rails' opinionated style guide)
- **Testing**: Minitest with fixtures (not factories), parallel execution via `parallelize(workers: :number_of_processors)`
- **JS dependencies**: `bun install` / `bun add <package>` — not npm/yarn
- **Active Storage** configured for local disk storage
- **Dev Container** available via `.devcontainer/` (PostgreSQL + Selenium services)
