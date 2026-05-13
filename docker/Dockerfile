FROM python:3.14.5-bookworm@sha256:78f0b36c1bc4c17ff3ddf4c8a006a5e500958c651dec6d1b155a9e1edd2cb91b

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
