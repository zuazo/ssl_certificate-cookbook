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

@test "creates dummy1 certificate" {
  openssl x509 -in "${CERT_PATH}/dummy1.pem" -text -noout
}

@test "creates dummy2 certificate" {
  openssl x509 -in "${CERT_PATH}/dummy2.pem" -text -noout
}

@test "creates dummy3 certificate" {
  openssl x509 -in "${CERT_PATH}/dummy3.pem" -text -noout
}

@test "sets dummy4 certificate country" {
  openssl x509 -in "${CERT_PATH}/dummy4.pem" -text -noout \
    | grep -F 'C=Bilbao'
}

@test "creates dummy5 certificate from a data bag" {
  openssl x509 -in "${CERT_PATH}/dummy5-data-bag.pem" -text -noout \
    | grep -F 'C=AU, ST=Some-State, O=Internet Widgits Pty Ltd'
}

@test "creates dummy6 certificate from node attributes" {
  openssl x509 -in "${CERT_PATH}/dummy6-attributes.pem" -text -noout \
    | grep -F 'C=AU, ST=Some-State, O=Internet Widgits Pty Ltd'
}
