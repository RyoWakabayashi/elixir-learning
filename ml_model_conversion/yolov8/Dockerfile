FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Asia/Tokyo

# hadolint ignore=DL3008
RUN apt-get update \
        && apt-get install --no-install-recommends --no-install-suggests -y \
                ca-certificates \
                git \
                libopencv-dev \
                python3-pip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

WORKDIR /work

RUN git clone https://github.com/poeticoding/yolo_elixir.git

WORKDIR /work/yolo_elixir

# hadolint ignore=DL3006,DL3013
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --requirement python/requirements.txt

COPY convert.sh /work/yolo_elixir/convert.sh

RUN chmod +x /work/yolo_elixir/convert.sh

CMD ["./convert.sh"]
