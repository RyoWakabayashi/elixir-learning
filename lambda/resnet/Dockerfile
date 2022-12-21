FROM amazonlinux:2022.0.20221207.4 as build

RUN set -e \
    && yum -y update \
    && yum -y groupinstall "Development Tools" \
    && yum -y install \
        ncurses-devel \
        openssl \
        openssl-devel \
        gcc-c++ \
    && yum clean all

ARG OTP_VERSION="25.2"

RUN set -e \
        && OTP_DOWNLOAD_URL="https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" \
        && curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" \
        && export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" \
        && mkdir -vp $ERL_TOP \
        && tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 \
        && rm otp-src.tar.gz \
        && ( cd $ERL_TOP \
             && ./otp_build autoconf \
             && ./configure \
             && make -j$(nproc) \
             && make install ) \
        && find /usr/local -name examples | xargs rm -rf

ARG REBAR3_VERSION="3.20.0"

RUN set -xe \
        && REBAR3_DOWNLOAD_URL="https://github.com/erlang/rebar3/archive/${REBAR3_VERSION}.tar.gz" \
        && mkdir -p /usr/src/rebar3-src \
        && curl -fSL -o rebar3-src.tar.gz "$REBAR3_DOWNLOAD_URL" \
        && tar -xzf rebar3-src.tar.gz -C /usr/src/rebar3-src --strip-components=1 \
        && rm rebar3-src.tar.gz \
        && cd /usr/src/rebar3-src \
        && HOME=$PWD ./bootstrap \
        && install -v ./rebar3 /usr/local/bin/ \
        && rm -rf /usr/src/rebar3-src

ARG ELIXIR_VERSION=1.14.2

ENV LANG=en_US.UTF-8

ENV MIX_REBAR3=/usr/local/bin/rebar3

RUN set -xe \
        && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/v${ELIXIR_VERSION}.tar.gz" \
        && curl -fsSL $ELIXIR_DOWNLOAD_URL -o elixir-src.tar.gz \
        && mkdir -p /usr/src/elixir-src \
        && tar -xzf elixir-src.tar.gz -C /usr/src/elixir-src --strip-components=1 \
        && rm elixir-src.tar.gz \
        && cd /usr/src/elixir-src \
        && make -j$(nproc) \
        && make install \
        && rm -rf /usr/src/elixir-src \
        && cd $HOME \
        && mix local.hex --force \
        && mix hex.info

WORKDIR /tmp

COPY mix.exs /tmp/
COPY lib /tmp/lib
COPY config /tmp/config

RUN mix deps.get \
    && mix compile

RUN mix download_models

RUN MIX_ENV=prod mix aws.release Resnet

FROM amazonlinux:2022.0.20221207.4

ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie

COPY entry.sh "/entry.sh"

RUN chmod +x /usr/local/bin/aws-lambda-rie
RUN chmod +x /entry.sh

ENV LANG=en_US.UTF-8
ENV TZ=:/etc/localtime
ENV PATH=/var/lang/bin:/usr/local/bin:/usr/bin/:/bin:/opt/bin
ENV LD_LIBRARY_PATH=/var/lang/lib:/lib64:/usr/lib64:/var/runtime:/var/runtime/lib:/var/task:/var/task/lib:/opt/lib
ENV LAMBDA_TASK_ROOT=/var/task
ENV LAMBDA_RUNTIME_DIR=/var/runtime

WORKDIR /var/task

COPY --from=build /tmp/_aws/docker/bootstrap /var/runtime/
COPY --from=build /tmp/_aws/docker/ /var/task/
COPY --from=build /opt/ml/model /opt/ml/model

ENTRYPOINT [ "/bin/bash", "/entry.sh" ]

CMD [ "Resnet" ]
