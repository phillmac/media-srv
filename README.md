# media-srv
Ffmpeg and other utils for streaming and ripping

# Build instructions:
```
ubuntu_version="18.04"
ffmpeg_version="tags/n4.1"

docker build \
    -t phillmac/ffmpeg-build:${ubuntu_version}-${ffmpeg_version////_} \
    --build-arg FFMPEG_VERSION=${ffmpeg_version} \
    --target ffmpeg_builder \
    git://github.com/phillmac/ffmpeg-build#${ubuntu_version}

docker build \
    -t phillmac/mkvserver_mk2-build \
    --target mkvserver_mk2_builder \
    git://github.com/phillmac/mkvserver_mk2-build

docker build \
    -t phillmac/python-ubuntu:18.04-3.7.1 \
    -t phillmac/python-ubuntu:18.04-3.7 \
    -t phillmac/python-ubuntu \
    git://github.com/phillmac/docker-python-ubuntu#18.04-3.7.1
    
docker build \
    -t phillmac/media-srv \
    git://github.com/phillmac/media-srv
```
