FROM python:3.14.6-bookworm@sha256:166a4ea2454b5938cd5f108e7c244d71374f90f0f59c00c3c58ee648972a43fc

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
