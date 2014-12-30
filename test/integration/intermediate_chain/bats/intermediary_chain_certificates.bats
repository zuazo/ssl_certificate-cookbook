#!/usr/bin/env bats

SSL_PATH='/etc'
DEB_PATH='/etc/ssl'
RH_PATH='/etc/pki/tls'

setup() {
  if [ -d "${DEB_PATH}" ]
  then
    SSL_PATH="${DEB_PATH}"
  elif [ -d "${RH_PATH}" ]
  then
    SSL_PATH="${RH_PATH}"
  fi
  CERT_PATH="${SSL_PATH}/certs"
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
