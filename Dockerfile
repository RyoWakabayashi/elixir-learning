FROM livebook/livebook:0.8.0

RUN mix local.hex --force \
  && mix archive.install hex phx_new --force \
  && mix local.rebar --force

RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    gnupg2 \
    apt-transport-https \
    ca-certificates \
    lsb-release \
    curl \
    libopencv-dev \
    build-essential \
    erlang-dev \
    sudo \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && sudo apt-get update \
  && sudo apt-get install -y docker.io \
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
