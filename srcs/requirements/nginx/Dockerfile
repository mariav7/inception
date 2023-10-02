# Specify OS
FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y
RUN apt-get install nginx openssl -y

# Create the key and the certifcate for TSL protocol
# -x509 refers to the certificate's type
# -out and -keyout parameters refers to where the certificate will be saved
# -subj refers to the command response (Country, State, Locality, Organization name, Organizational Unit name, Common Name)
RUN openssl req \
            -x509 \
            -nodes \
            -days 365 \
            -newkey rsa:2048 \
            -keyout /etc/ssl/private/nginx-selfsigned.key \
            -out /etc/ssl/certs/nginx-selfsigned.crt \
            -subj '/C=FR/ST=Ile-de-France/L=Paris/O=42/OU=42Paris/CN=TLIOT/UID=TTT'

RUN echo "ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;\nssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;" > /etc/nginx/snippets/self-signed.conf

RUN openssl dhparam -out /etc/nginx/dhparam.pem 2048

COPY ./conf/ssl-params.conf /etc/nginx/snippets/

COPY ./conf/default    /etc/nginx/sites-available/
COPY ./conf/adminer.conf    /etc/nginx/sites-available/
COPY ./conf/subdomain.conf  /etc/nginx/sites-available/

RUN  ln -s /etc/nginx/sites-available/adminer.conf /etc/nginx/sites-enabled/
RUN  ln -s /etc/nginx/sites-available/subdomain.conf /etc/nginx/sites-enabled/

# Run nginx with daemon off, i.e. in the foreground since one container only
# has one service. This is best practice for Docker containers and/or debugging.
CMD ["nginx", "-g", "daemon off;"]
