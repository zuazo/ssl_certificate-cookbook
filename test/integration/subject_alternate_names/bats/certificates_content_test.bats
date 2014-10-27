#!/usr/bin/env bats

CERT_PATH="/etc/"
DEB_PATH="/etc/ssl/"
RH_PATH="/etc/pki/tls/"

setup() {
    if [ -d $DEB_PATH ]; then
        CERT_PATH=$DEB_PATH
    elif [ -d $RH_PATH ]; then
        CERT_PATH=$RH_PATH
    fi
    GREP_COMMAND1="openssl x509 -in ${CERT_PATH}certs/subject_alternate_names.pem -text -noout | grep"
    GREP_COMMAND2="openssl x509 -in ${CERT_PATH}certs/subject_alternate_names2.pem -text -noout | grep"
}

@test "the non-SAN certificate has no Subject Alternative Name line" {
    run bash -c "$GREP_COMMAND1 'X509v3 Subject Alternative Name'"
    [ "$status" -eq 1 ]
}

@test "the SAN certificate has a Subject Alternative Name line" {
    run bash -c "$GREP_COMMAND2 'X509v3 Subject Alternative Name'"
    [ "$status" -eq 0 ]
}

@test "the SAN certificate has a DNS:foo entry" {
    run bash -c "$GREP_COMMAND2 DNS:foo"
    [ "$status" -eq 0 ]
}

@test "the SAN certificate has a DNS:bar entry" {
    run bash -c "$GREP_COMMAND2 DNS:foo"
    [ "$status" -eq 0 ]
}

@test "the SAN certificate has a DNS:subject-alternate-name entry" {
    run bash -c "$GREP_COMMAND2 DNS:subject-alternate-name"
    [ "$status" -eq 0 ]
}

@test "the SAN certificate has a DNS:foo.subject-alternate-name entry" {
    run bash -c "$GREP_COMMAND2 DNS:foo.subject-alternate-name"
    [ "$status" -eq 0 ]
}
