#!/bin/bash

function usage() {
  echo "Usage: $0 <command>"
  echo "Commands:"
  echo "  stl     - Generate STL artifacts"
  echo "  clean   - Remove build artifacts"
  echo "  help    - Display this help message"
}

function stl() {
  clean

  mkdir ./dist
  (openscad -o dist/bottomless-planter.stl design_files/bottomless-planter.scad)
  (openscad -o dist/buoy.stl design_files/buoy.scad)
  (openscad -o dist/reservoir.stl design_files/reservoir.scad)
  (openscad -o dist/wicking-plate.stl design_files/wicking-plate.scad)
}

function clean() {
  rm -rf ./dist
}

if [ $# -eq 0 ]; then
  usage
  exit 1
fi

command=$1
shift

case "$command" in
  stl)
    stl
    ;;
  clean)
    clean
    ;;
  help)
    usage
    ;;
  *)
    echo "Error: Invalid command: $command"
    usage
    exit 1
    ;;
esac

