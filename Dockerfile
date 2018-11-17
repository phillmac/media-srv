FROM python:3.7.1

RUN apt-get update && apt-get install -y nano tmux less mbuffer
RUN pip install streamlink
COPY --from=phillmac/mkvserver_mk2-build /mkvserver_mk2/server /root/bin/* /usr/local/bin/
