#!/bin/bash
pushd 2019/debian-9
bash build.sh
popd

docker build -t craeckie/phabricator .
