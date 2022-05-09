FROM livebook/livebook

RUN mix local.hex --force \
  && mix archive.install hex phx_new --force \
  && mix local.rebar --force

RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
  gnupg2 \
  apt-transport-https \
  libopencv-dev \
  build-essential \
  erlang-dev \
  sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O - https://pkg.wslutiliti.es/public.key | sudo tee -a /etc/apt/trusted.gpg.d/wslu.asc

RUN echo "deb https://pkg.wslutiliti.es/debian bullseye main" | sudo tee -a /etc/apt/sources.list

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  wslu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV EVISION_PREFER_PRECOMPILED=true

COPY ./setup_for_wsl.sh /home/livebook/

RUN chmod +x /home/livebook/setup_for_wsl.sh

COPY ./livebooks /home/livebook

CMD ["/app/bin/livebook", "start"]
