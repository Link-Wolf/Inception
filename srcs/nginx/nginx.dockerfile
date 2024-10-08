FROM debian:buster

# Install Nginx and OpenSSL
RUN apt-get update && apt-get install -y nginx openssl

RUN mkdir -p /etc/ssl ; mkdir -p /var/www/html
RUN chmod -R 755 /var/www/html

# Nginx SSL configuration
RUN openssl																		\ 
	# Create a self-signed certificate
	req -x509							                                        \ 
	# No password so nginx can start without asking for it
	-nodes                                                                      \
	# Certificate validity period (looooooong boi)
	-days 4242                                                                  \
	# New rsa key with 2048 bits
	-newkey rsa:2048					                                        \
	#Where the key will be stored
	-keyout /etc/ssl/nginx.key                                                  \
	#Where the certificate will be stored
	-out /etc/ssl/nginx.crt													 	\
	# Certificate subject
	-subj "/C=FR/CN=login.42.fr"

# Copy the Nginx configuration file
COPY ./nginx.conf /etc/nginx/conf.d

# Expose HTTPS
EXPOSE 443

# Launch Nginx
CMD [ "nginx", "-g", "daemon off;" ]