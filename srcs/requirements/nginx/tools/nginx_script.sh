#!/bin/bash

# Create the key and the certifcate for TSL protocol
# -x509 refers to the certificate's type
# -out and -keyout parameters refers to where the certificate will be saved
# -subj refers to the command response (Country, State, Locality, Organization name, Organizational Unit name, Common Name)
openssl req \
        -x509 \
        -nodes \
        -days 365 \
        -newkey rsa:2048 \
        -keyout ${CERTS_KEYOUT} \
        -out ${CERTS_OUT} \
        -subj ${CERT_SUBJ}

echo "ssl_certificate ${CERTS_OUT};\nssl_certificate_key ${CERTS_KEYOUT};" > ${SNIPPETS}

nginx -g "daemon off;"