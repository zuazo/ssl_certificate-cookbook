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
  # [ -f "${CERT_PATH}/dummy-ca-bundle.pem" ]
  openssl x509 -in "${CERT_PATH}/dummy-ca-bundle.pem" -text -noout
}

@test "creates chained certificate from a data bag" {
  openssl x509 -in "${CERT_PATH}/chain-data-bag.pem" -text -noout
}

@test "creates chained combined certificate from a data bag" {
  openssl x509 -in "${CERT_PATH}/chain-data-bag.pem.chained.pem" -text -noout
}
