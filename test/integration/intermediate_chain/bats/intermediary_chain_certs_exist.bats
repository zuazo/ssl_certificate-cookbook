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

@test "the intermediate chains exist" {
	[ -f "${CERT_PATH}certs/dummy-ca-bundle.pem" -a -f "${CERT_PATH}certs/dummy-ca-bundle2.pem" ]
}