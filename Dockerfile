FROM ghcr.io/livebook-dev/livebook:0.14.6

RUN mix local.hex --force \
  && mix archive.install hex phx_new --force \
  && mix local.rebar --force

RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    erlang-dev \
    gnupg2 \
    lsb-release \
    sudo \
    unzip \
    vim \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For Docker
RUN mkdir -p /etc/apt/keyrings \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get install -y docker.io \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For NetCDF
RUN apt-get update \
  && apt-get install -y \
    libhdf5-serial-dev \
    libnetcdf-dev \
    nco \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For WSL
RUN wget -O - https://pkg.wslutiliti.es/public.key | sudo tee -a /etc/apt/trusted.gpg.d/wslu.asc
RUN echo "deb https://pkg.wslutiliti.es/debian bullseye main" | sudo tee -a /etc/apt/sources.list
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
  wslu \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
COPY ./setup_for_wsl.sh /home/livebook/
RUN chmod +x /home/livebook/setup_for_wsl.sh

# For Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH=$PATH:$HOME/.cargo/bin

# For ffmpeg
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    ffmpeg \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libswscale-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For OpenCV
RUN apt-get upgrade -y \
  && apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
    apt-get install --no-install-recommends -y \
    libopencv-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For Vix, Image
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    libvips-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For PostgreSQL
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    postgresql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For SoX (Sound eXchange)
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y sox \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For Playwrite
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For Membrane
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    clang-format \
    libfdk-aac-dev \
    libswresample-dev \
    libmad0-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# For PHP
RUN apt-get upgrade -y \
  && apt-get update \
  && apt-get install --no-install-recommends -y php \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Zig
RUN wget "https://ziglang.org/download/0.13.0/zig-linux-aarch64-0.13.0.tar.xz" -O "zig-linux.tar.xz" \
  && tar Jxvf "zig-linux.tar.xz" -C /usr/local \
  && mv /usr/local/zig-linux-aarch64-0.13.0 /usr/local/zig-linux \
  && rm "zig-linux.tar.xz"
ENV PATH=/usr/local/zig-linux:${PATH}

# Neo4j
RUN curl -fsSL https://debian.neo4j.com/neotechnology.gpg.key | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/neo4j.gpg \
  && echo 'deb https://debian.neo4j.com stable latest' | sudo tee -a /etc/apt/sources.list.d/neo4j.list \
  && apt-get update \
  && apt-get install --no-install-recommends -y neo4j \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LIVEBOOK_HOME=/home/livebook

COPY ./livebooks /home/livebook

CMD ["/app/bin/livebook", "start"]
