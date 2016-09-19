#!/bin/bash

set -e

vagrant destroy -f && vagrant plugin uninstall vagrant-alpine && docker stop consul && docker rm -v consul
