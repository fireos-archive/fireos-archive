FROM python:3.15.1-bookworm@sha256:b852d3c507d3ccaade2c2a0951505dc1f78933b85db8f5aeddf3d489bf8406ed

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
