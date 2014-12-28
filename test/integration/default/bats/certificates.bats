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

@test "creates the apache2 virtualhost" {
  echo | openssl s_client -connect 127.0.0.1:443 \
    | grep -F 'subject=/O=ssl_certificate apache2 template test/'
}
