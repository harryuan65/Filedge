# Filedge

A simple file-sharing application.

# Environment

| env             | version |
| --------------- | ------- |
| rails           | 7.0.4.2 |
| ruby            | 3.0.3   |
| PostgreSQL 14.4 | 1.22.19 |

# Setup - Local R

## 1. Install dependencies

```bash
bin/setup
```

## 2. Start the application

```
bin/dev
```

Then visit `http://localhost:3000` to access the app.

# Setup - Docker

Build services:

```
make build
```

Start services:

```
make dev
```

If make command is unavailable to you, you can also run these manually:

```
docker compose build
docker compose run --rm web bin/rails db:create db:migrate db:seed
docker compose up
```
