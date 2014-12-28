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

@test "creates a certificate with a CA" {
  [ -f "${CERT_PATH}/test.com.pem" ]
}

@test "the certificate with a CA has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/test.com.pem" -noout -text \
    | grep -F 'Issuer: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=ca.test.com/emailAddress=titi@test.com'
}

@test "the certificate with a CA has the correct subject" {
  openssl x509 -in "${CERT_PATH}/test.com.pem" -noout -text \
    | grep -F 'Subject: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=test.com/emailAddress=titi@test.com'
}

@test "creates the apache2 virtualhost" {
  echo | openssl s_client -connect 127.0.0.1:443 \
    | grep -F 'subject=/C=FR/ST=Ile de Paris/L=Paris/O=Toto/OU=Titi/CN=test.com/emailAddress=titi@test.com'
}

@test "creates a CA certificate from a data bag" {
  [ -f "${CERT_PATH}/ca.example.org.pem" ]
}

@test "the CA certificate has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/ca.example.org.pem" -noout -text \
    | grep -F 'Issuer: C=ES, ST=Bizkaia, L=Bilbao, O=Conquer the World, OU=Everything, CN=ca.example.org/emailAddress=everything@example.org'
}

@test "the CA certificate has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/ca.example.org.pem" -noout -text \
    | grep -F 'Subject: C=ES, ST=Bizkaia, L=Bilbao, O=Conquer the World, OU=Everything, CN=ca.example.org/emailAddress=everything@example.org'
}

@test "creates a certificate with a CA from a data bag" {
  [ -f "${CERT_PATH}/example.org.pem" ]
}

@test "the certificate with a CA has the correct issuer" {
  openssl x509 -in "${CERT_PATH}/example.org.pem" -noout -text \
    | grep -F 'Issuer: C=ES, ST=Bizkaia, L=Bilbao, O=Conquer the World, OU=Everything, CN=ca.example.org/emailAddress=everything@example.org'
}
