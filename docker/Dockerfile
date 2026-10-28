FROM python:3.15.2-bookworm@sha256:e79bc58043116e8190135cd6d0214ffcf185ce53248ad2b15598133b63e044e5

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
