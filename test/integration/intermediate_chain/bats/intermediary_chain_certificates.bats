#!/usr/bin/env bats

DEB_PATH='/etc/ssl/certs'
RH_PATH='/etc/pki/tls/certs'
FB_PATH='/etc/ssl'

setup() {
  if [ -d "${DEB_PATH}" ]
  then
    CERT_PATH="${DEB_PATH}"
  elif [ -d "${RH_PATH}" ]
  then
    CERT_PATH="${RH_PATH}"
  elif [ -d "${FB_PATH}" ]
  then
    CERT_PATH="${FB_PATH}"
  else
    CERT_PATH='/etc'
  fi
}

@test "creates the intermediate chains certificate" {
  [ -f "${CERT_PATH}/dummy-ca-bundle.pem" ]
}

@test "creates chained certificate from a data bag" {
  [ -f "${CERT_PATH}/chain-data-bag.pem" ]
}

@test "creates chained certificate from node attributes" {
  [ -f "${CERT_PATH}/chain-data-bag2.pem" ]
}
