#!/bin/sh
docker rm -f master
docker build -t hadoop:1.0 .
#docker run -it -d --name master hadoop:1.0
#docker exec -it master /bin/bash
