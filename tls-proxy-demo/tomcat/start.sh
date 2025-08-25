#!/bin/bash

sed -i "s/tomcat_address/${tomcat_address:-$HOSTNAME}/g" ./conf/server.xml
sed -i "s/tomcat_port/${tomcat_port}/g"                  ./conf/server.xml
sed -i "s/tomcat_jvm_route/${tomcat_jvm_route}/g"        ./conf/server.xml

### SSL part ###
### we generate keys for each tomcat container individually
cd certs
openssl genrsa -out ssl-demo-tomcat-private.key 4096
openssl req -new -key ssl-demo-tomcat-private.key -out ssl-demo-tomcat.csr -config csr.conf
openssl x509 -req -in ssl-demo-tomcat.csr -CA rootCA.crt -CAkey rootCA.key -CAcreateserial -out ssl-demo-tomcat.crt -days 7 -sha256 -extfile cert.conf

openssl pkcs12 -export \
       -in ssl-demo-tomcat.crt \
       -inkey ssl-demo-tomcat-private.key \
       -certfile ssl-demo-tomcat.crt \
       -CAfile rootCA.crt \
       -chain \
       -out mycert.p12 \
       -name tomcat \
       -password pass:changeit

keytool -importcert -trustcacerts -file rootCA.crt -keystore truststore.p12 -storepass truststorepass -storetype PKCS12 -noprompt

cd ..

bin/catalina.sh run

