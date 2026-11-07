#!/bin/bash

copilot \
  --available-tools='bash,edit,view,grep,glob' \
  --allow-tool='shell(bash main.bash),write(src/**)'