FROM elixir:1.5-alpine

ENV ELIXIR_ERL_OPTIONS=" \
  -proto_dist Elixir.Clusterable.EPMD.Service \
  -epmd_module Elixir.Clusterable.EPMD.Client"

RUN set -xe \
    && apk add -U inotify-tools build-base \
    && rm -rf /var/cache/apk/*

RUN mix local.hex --force && mix local.rebar --force

WORKDIR /var/app

COPY config /var/app/config
COPY mix.exs /var/app/mix.exs
COPY mix.lock /var/app/mix.lock
COPY lib /var/app/lib

RUN mix do deps.get, deps.compile, compile

EXPOSE 4000

CMD ["iex", "-S", "mix"]
