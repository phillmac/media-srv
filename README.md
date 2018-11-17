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
    -t phillmac/mkvserver_mk2_builder \
    --target mkvserver_mk2_builder \
    git://github.com/phillmac/mkvserver_mk2_build
```
