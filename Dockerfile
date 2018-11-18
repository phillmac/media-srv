FROM phillmac/python-ubuntu

RUN apt-get update && apt-get install -y nano tmux less mbuffer
RUN pip install streamlink
COPY --from=phillmac/mkvserver_mk2-build /root/mkvserver_mk2/server /root/bin/* /usr/local/bin/
