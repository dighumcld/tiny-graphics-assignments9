
#!/bin/bash

function nuke() {
  rm -rf bin/* && rm -rf lib/* && rm -rf build/*
}

function uninstall() {
  xargs rm < build/install_manifest.txt
}

function build() {
  mkdir -p build
  cd build
  cmake .. -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=.. -DBUILD_SHARED_LIBS=ON
  make && make install
}

if [[ $1 == "nuke" ]]; then
  nuke
elif [[ $1 == "uninstall" ]]; then
  uninstall
else
  uninstall
  build
fi