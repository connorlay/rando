# Gazerbeam

A toy Phoenix application for randomizing user points.

Made with :heart: by Connor Lay

## Requirements

- Docker
- Docker Compose
- Elixir
- Curl (optional)

## Setup & Development

1. Clone this repository
```sh
git clone git@github.com:connorlay/rando.git
```

2. Setup the development environment
```sh
mix setup
```

3. Start the Phoenix server
```sh
mix phx.server
```

4. (Optional) Run the test suite
```sh
mix test
```

## Usage

1. Query the server for the initial state
```sh
curl 'localhost:4000'

{
  "users": [],
  "queried_at": nil
}
```

2. Wait for the server to refresh (every minute, watch the debug logs)

3. Query the server for the new state
```sh
curl 'localhost:4000'

{
  "users": [
    {
      "id": 1,
      "points": 1
    },
    {
      "id": 2,
      "points": 2
    }
  ],
  "queried_at": "2021-02-28T04:29:49.918864"
}
```

4. Wait for the server to refresh again

5. Query the server for the new state
```sh
curl 'localhost:4000'

{
  "users": [
    {
      "id": 5,
      "points": 5
    },
    {
      "id": 6,
      "points": 6
    }
  ],
  "queried_at": "2021-02-28T04:30:02.053116"
}
```

## Mix Tasks

- `mix setup`: bootstraps the project
- `mix phx.server`: starts the Phoenix server
- `mix ecto.migrate`: runs Ecto migrations
- `mix ecto.reset`: resets Ecto
- `mix test`: runs ExUnit tests
- `mix docker_compose up`: starts Docker Compose
- `mix docker_compose down`: stop Docker Compose
- `mix docker_compose drop`: resets Docker Compose
