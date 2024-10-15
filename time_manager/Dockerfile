FROM elixir:1.14-alpine

WORKDIR /app

RUN apk add --no-cache build-base

RUN mix local.hex --force && \
    mix local.rebar --force

COPY mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

COPY . .
RUN mix do compile

EXPOSE 4000

CMD ["mix", "phx.server"]