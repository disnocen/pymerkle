#!/bin/bash

usage_string="usage: ./$(basename "$0") [pytest_options] [--extended] [--backend ...]

Options
  --backend [inmemory|sqlite]   Storage backend (default: inmemory)
  --extended                    Run tests against all supported hash algorithms;
                                otherwise only against sha256 (default: false)
  -h, --help                    Display help message and exit
"

set -e

STORAGE="inmemory"

usage() { echo -n "$usage_string" 1>&2; }

opts=()
while [[ $# -gt 0 ]]
do
    arg="$1"
    case $arg in
        --extended|-e)
            opts+=($arg)
            shift
            ;;
        --backend)
            STORAGE="$2"
            shift
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            opts+=($arg)
            shift
            ;;
    esac
done


python3 -m \
  pytest tests/ \
  --backend ${STORAGE} \
  --cov-report term-missing \
  --cov=. \
  $opts