FROM elixir:1.17.2

RUN mix local.hex --force \
  && mix local.rebar --force

COPY ./api /app

WORKDIR /app

ENV ERL_FLAGS="+JPperf true"
ENV HOME="/app"
ENV MIX_ENV="dev"

RUN mix deps.get

RUN mix compile.phoenix

RUN chmod 777 -R /app/
RUN chmod +x /app/serve

ENV PATH="/app:${PATH}"

EXPOSE 8080

CMD ["serve"]
