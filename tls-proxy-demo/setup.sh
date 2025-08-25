echo "Setting up the demo"

# create root certificate
mkdir -p ca && cd ca
openssl req -x509 -sha256 -days 7 -nodes -newkey rsa:4096 -subj "/CN=localhost" -keyout rootCA.key -out rootCA.crt
# we'll use it with both containers, tomcat and httpd
cp rootCA.crt rootCA.key ../tomcat/certs/
cp rootCA.crt rootCA.key ../httpd/certs/
cd ..

echo "root certificate done"

# let's build the images
cd tomcat
podman build . -t tomcat-ssl || exit 1
cd ..

echo "tomcat container image done"

cd httpd
podman build . -t httpd-mpc-ssl || exit 2
cd ..

echo "httpd + mod_proxy_cluster container image done"

echo "Done!"

