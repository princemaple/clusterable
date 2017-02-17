FROM elixir:1.4.1-slim

RUN set -xe \
    && apt-get update \
    && apt-get install -y build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /var/app

COPY config /var/app/config
COPY mix.exs /var/app/mix.exs
COPY mix.lock /var/app/mix.lock
COPY lib /var/app/lib

RUN mix do deps.get, deps.compile, compile

EXPOSE 4000

CMD ["iex", "-S", "mix"]
