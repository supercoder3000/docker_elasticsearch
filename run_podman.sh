podman run --rm --name elasticstack -it -e DISPLAY=$DISPLAY  -p 9200:9200 -p5601:5601 --privileged --volume ~:/mnt/host -v /tmp/.X11-unix:/tmp/.X11-unix supercoder:elasticstack

