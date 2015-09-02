#!/usr/bin/env bats

DEB_CERT_PATH='/etc/ssl/certs'
RH_CERT_PATH='/etc/pki/tls/certs'
FB_CERT_PATH='/etc/ssl'

DEB_KEY_PATH='/etc/ssl/private'
RH_KEY_PATH='/etc/pki/tls/private'
FB_KEY_PATH='/etc/ssl'

setup() {
  if [ -d "${DEB_CERT_PATH}" ]
  then
    CERT_PATH="${DEB_CERT_PATH}"
  elif [ -d "${RH_CERT_PATH}" ]
  then
    CERT_PATH="${RH_CERT_PATH}"
  elif [ -d "${FB_CERT_PATH}" ]
  then
    CERT_PATH="${FB_CERT_PATH}"
  else
    CERT_PATH='/etc'
  fi

  if [ -d "${DEB_KEY_PATH}" ]
  then
    KEY_PATH="${DEB_KEY_PATH}"
  elif [ -d "${RH_KEY_PATH}" ]
  then
    KEY_PATH="${RH_KEY_PATH}"
  elif [ -d "${FB_KEY_PATH}" ]
  then
    KEY_PATH="${FB_KEY_PATH}"
  else
    KEY_PATH='/etc'
  fi
}

@test "creates a non-SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names1.pem" ]
}

@test "creates a SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names2.pem" ]
}

@test "creates a second SAN certificate" {
  [ -f "${CERT_PATH}/subject_alternate_names3.pem" ]
}

@test "creates the non-SAN certificate key" {
  openssl rsa -in "${KEY_PATH}/subject_alternate_names1.key" -text -noout
}

@test "the non-SAN certificate has no Subject Alternative Name line" {
  ! openssl x509 -in "${CERT_PATH}/subject_alternate_names1.pem" -text -noout \
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
    | grep -F "DNS:$(hostname)"
}

@test "the SAN certificate has a DNS:foo.FQDN entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names2.pem" -text -noout \
    | grep -F "DNS:foo.$(hostname)"
}

@test "creates the SAN certificate key" {
  openssl rsa -in "${KEY_PATH}/subject_alternate_names3.key" -text -noout
}

@test "the second SAN certificate has a Subject Alternative Name line" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'X509v3 Subject Alternative Name'
}

@test "the second SAN certificate has the copied email entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'email:email@example.com'
}

@test "the second SAN certificate has another email entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'email:my@'
}

@test "the second SAN certificate has an email entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'URI:http://'
}

@test "the second SAN certificate has an IP entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'IP Address:192.168.7.1'
}

@test "the second SAN certificate has an IPv6 entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'IP Address:13:0:0:0:0:0:0:17'
}

@test "the second SAN certificate has an RID entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'Registered ID:1.2.3.4'
}

@test "the second SAN certificate has an otherName entry" {
  openssl x509 -in "${CERT_PATH}/subject_alternate_names3.pem" -text -noout \
    | grep -F 'othername:'
}

@test "creates the second SAN certificate key" {
  openssl rsa -in "${KEY_PATH}/subject_alternate_names3.key" -text -noout
}
