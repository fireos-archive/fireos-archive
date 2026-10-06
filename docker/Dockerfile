FROM python:3.14.8-bookworm@sha256:29be10b8a110d9202f6e976e5fa2c34b822c29d82b6bea7ff773e02620d5e128

LABEL io.whalebrew.name=fireos-version
LABEL io.whalebrew.config.environment=["GITHUB_ACTIONS"]

RUN apt-get update \
  && apt-get install -y jq brotli p7zip-full \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN pip3 install -U pip \
  && pip3 install --no-cache-dir androguard
RUN git clone --depth 1 https://github.com/xpirt/sdat2img.git /opt/sdat2img

COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD []
