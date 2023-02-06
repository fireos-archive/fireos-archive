FROM python:2.7.18-buster

LABEL io.whalebrew.name 'fireos-version'
LABEL io.whalebrew.config.environment '["GITHUB_ACTIONS"]'

RUN apt-get update \
  && apt-get install -y jq brotli p7zip-full \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN pip2 install -U pip \
  && pip2 install --no-cache-dir androguard
RUN git clone --depth 1 https://github.com/xpirt/sdat2img.git /opt/sdat2img

COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD []
