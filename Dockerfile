FROM livebook/livebook

RUN mix local.hex --force \
  && mix archive.install hex phx_new --force \
  && mix local.rebar --force

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y libopencv-dev build-essential erlang-dev

ENV EVISION_PREFER_PRECOMPILED=true

COPY ./livebooks /home/livebook

CMD ["/app/bin/livebook", "start"]
