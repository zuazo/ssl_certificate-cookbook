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

@test "creates a non-SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names.pem" ]
}

@test "creates a SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names2.pem" ]
}

@test "the non-SAN certificate has no Subject Alternative Name line" {
  ! openssl x509 -in "${CERT_PATH}/subject_alternate_names.pem" -text -noout \
    | grep -F 'X509v3 Subject Alternative Name'
}

@test "the SAN certificate has a Subject Alternative Name line" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'X509v3 Subject Alternative Name'
}

@test "the SAN certificate has a DNS:foo entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:foo'
}

@test "the SAN certificate has a DNS:bar entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:bar'
}

@test "the SAN certificate has a DNS:FQDN entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:ssl-certificate.local'
}

@test "the SAN certificate has a DNS:foo.FQDN entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F 'DNS:foo.ssl-certificate.local'
}
