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
}

@test "the certificates exist" {
	[ -f "${CERT_PATH}certs/subject_alternate_names.pem" -a -f "${CERT_PATH}certs/subject_alternate_names2.pem" ]
}