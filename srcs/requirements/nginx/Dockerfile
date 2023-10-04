# Specify OS
FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx openssl -y

# Create the key and the certifcate for TSL protocol
# -x509 refers to the certificate's type
# -out and -keyout parameters refers to where the certificate will be saved
# -subj refers to the command response (Country, State, Locality, Organization name, Organizational Unit name, Common Name)
# RUN openssl req \
#             -x509 \
#             -nodes \
#             -days 365 \
#             -newkey rsa:2048 \
#             -keyout ${CERTS_KEYOUT} \
#             -out ${CERTS_OUT} \
#             -subj ${CERT_SUBJ}

#COPY ./conf/nginx.conf /etc/nginx/

#   Copy the script in the images and modify the execution rights of it
COPY ./tools/nginx_script.sh /tmp/

#   Make sure that we can execute the script
RUN chmod +x /tmp/nginx_script.sh

CMD [ "/tmp/nginx_script.sh" ]

# Run nginx with daemon off, i.e. in the foreground since one container only
# has one service. This is best practice for Docker containers and/or debugging.
#CMD ["nginx", "-g", "daemon off;"]
