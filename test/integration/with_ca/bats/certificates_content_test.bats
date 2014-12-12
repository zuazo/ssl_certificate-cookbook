#!/usr/bin/env bats

CERT_PATH="/etc/"
DEB_PATH="/etc/ssl/"
RH_PATH="/etc/pki/tls/"

setup() {
  if [ -d "${DEB_PATH}" ]
  then
    CERT_PATH="${DEB_PATH}"
  elif [ -d "${RH_PATH}" ]
  then
    CERT_PATH="${RH_PATH}"
  fi
}

@test "the certificate has the correct issuer" {
  openssl x509 -in "${CERT_PATH}certs/test.pem" -noout -text \
    | grep -F 'Issuer: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=ca.test.com/emailAddress=titi@test.com'
}

@test "the certificate has the correct subject" {
  openssl x509 -in "${CERT_PATH}certs/test.pem" -noout -text \
    | grep -F 'Subject: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=test.com/emailAddress=titi@test.com'
}
