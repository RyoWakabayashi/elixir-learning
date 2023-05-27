FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Asia/Tokyo

# hadolint ignore=DL3008
RUN apt-get update \
        && apt-get install --no-install-recommends --no-install-suggests -y \
                libopencv-dev \
                git \
                wget \
                python3.8 \
                python3-pip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/* \
        && update-alternatives --install /usr/bin/python python /usr/bin/python3.8 1

WORKDIR /work

RUN git clone https://github.com/WongKinYiu/yolov7.git

WORKDIR /work/yolov7

RUN wget --quiet --continue \
        --timestamping https://github.com/WongKinYiu/yolov7/releases/download/v0.1/yolov7x.pt \
        --output-document ./yolov7x.pt

# hadolint ignore=DL3006,DL3013
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --requirement requirements.txt \
    && pip install --no-cache-dir onnx onnx-simplifier

COPY convert.sh /work/yolov7/convert.sh

RUN chmod +x /work/yolov7/convert.sh

CMD ["./convert.sh"]
