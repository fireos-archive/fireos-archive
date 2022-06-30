FROM python:2.7.18-buster AS extfstools

RUN apt-get update \
  && apt-get install -y build-essential libboost-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN git clone --depth 1 https://github.com/nlitsme/extfstools.git /opt/extfstools
RUN cd /opt/extfstools && make -f Makefile.unix

FROM python:2.7.18-buster

LABEL io.whalebrew.name 'fireos-version'
LABEL io.whalebrew.config.environment '["GITHUB_ACTIONS"]'

RUN apt-get update \
  && apt-get install -y jq brotli \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*
RUN pip2 install -U pip \
  && pip2 install --no-cache-dir androguard
RUN git clone --depth 1 https://github.com/xpirt/sdat2img.git /opt/sdat2img \
  && git clone --depth 1 https://github.com/hexedit/ext4extract.git /opt/ext4extract
COPY --from=extfstools /opt/extfstools /opt/extfstools

COPY ./entrypoint.sh /opt/entrypoint.sh
RUN chmod +x /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD []
