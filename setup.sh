#!/usr/bin/env bash

set -e

show_usage() {
  echo "Usage: $(basename $0) takes exactly 1 argument (install | uninstall)"
}

if [ $# -ne 1 ]
then
  show_usage
  exit 1
fi

check_env() {
  if [[ -z "${RALPM_TMP_DIR}" ]]; then
    echo "RALPM_TMP_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_INSTALL_DIR}" ]]; then
    echo "RALPM_PKG_INSTALL_DIR is not set"
    exit 1
  
  elif [[ -z "${RALPM_PKG_BIN_DIR}" ]]; then
    echo "RALPM_PKG_BIN_DIR is not set"
    exit 1
  fi
}

install() {
  wget https://github.com/indygreg/python-build-standalone/releases/download/20220802/cpython-3.9.13+20220802-x86_64-unknown-linux-gnu-install_only.tar.gz -O $RALPM_TMP_DIR/cpython-3.9.13.tar.gz
  tar xf $RALPM_TMP_DIR/cpython-3.9.13.tar.gz -C $RALPM_PKG_INSTALL_DIR
  rm $RALPM_TMP_DIR/cpython-3.9.13.tar.gz

  $RALPM_PKG_INSTALL_DIR/python/bin/pip3.9 install urh==2.9.3
  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/urh $RALPM_PKG_BIN_DIR/urh
  ln -s $RALPM_PKG_INSTALL_DIR/python/bin/urh_cli $RALPM_PKG_BIN_DIR/urh_cli

  echo "This package adds the commands:"
  echo " - urh"
  echo " - urh_cli"
}

uninstall() {
  rm -rf $RALPM_PKG_BIN_DIR/python
  rm $RALPM_PKG_BIN_DIR/urh
  rm $RALPM_PKG_BIN_DIR/urh_cli  
}

run() {
  if [[ "$1" == "install" ]]; then 
    install
  elif [[ "$1" == "uninstall" ]]; then 
    uninstall
  else
    show_usage
  fi
}

check_env
run $1