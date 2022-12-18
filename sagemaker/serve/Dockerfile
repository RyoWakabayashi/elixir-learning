FROM elixir:1.14.2

RUN mix local.hex --force \
  && mix local.rebar --force

COPY ./api /app

WORKDIR /app

RUN mix deps.get

RUN mix compile.phoenix

RUN chmod +x /app/serve

ENV PATH="/app:${PATH}"

EXPOSE 8080

CMD ["serve"]
