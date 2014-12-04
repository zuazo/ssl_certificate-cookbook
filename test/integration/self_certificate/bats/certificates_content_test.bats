@test "the certificate has the correct issuer" {
  openssl x509 -in /etc/ssl/certs/test.pem -noout -text \
    | grep -F 'Issuer: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=ca.test.com/emailAddress=titi@test.com'
}

@test "the certificate has the correct subject" {
  openssl x509 -in /etc/ssl/certs/test.pem -noout -text | grep -F 'Subject: C=FR, ST=Ile de Paris, L=Paris, O=Toto, OU=Titi, CN=test.com/emailAddress=titi@test.com'
}
