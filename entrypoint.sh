#!/bin/bash

eval $(ssh-agent -s)

if [ $# -eq 0 ]; then
  exec /bin/bash
else
  exec "$@"
fi
