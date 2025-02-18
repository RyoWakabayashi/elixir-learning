FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive

ENV TZ=Asia/Tokyo

# hadolint ignore=DL3008
RUN apt-get update \
        && apt-get install --no-install-recommends --no-install-suggests -y \
                python3-pip \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir transformers sentence-transformers 'fugashi[unidic-lite]' 'fugashi[unidic]' \
    && python3 -m unidic download

WORKDIR /work

COPY convert.py /work/convert.py

RUN chmod +x /work/convert.py

CMD ["python3", "./convert.py"]
