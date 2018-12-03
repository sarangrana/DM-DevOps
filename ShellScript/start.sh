#!/bin/bash

serviceA="http://app-serviceregistry:8761"
serviceB="http://app-serviceconfig:8888/app-captcha-api/default"
echo "Dependency Services are $serviceA, $serviceB"
while [ $(curl -sL -w "%{http_code}\\n" "$serviceA" -o /dev/null) != 200 -o $(curl -sL -w "%{http_code}\\n" "$serviceB" -o /dev/null) != 200 ];
	do
		sleep 1
	done
echo "All required services are up now. Start this service."


if [ -f /app-captcha-api/certs/db-ca-cert.cer ];
then
  echo "db-ca-cert.cer exists"
  keytool -list -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit -alias decisionmines-db
  if [ $? -ne 0 ];
  then
    echo "DB SSL Certificate is not present in keystore. Adding it."
    yes | keytool -import -trustcacerts -keystore /usr/lib/jvm/java-8-openjdk-amd64/jre/lib/security/cacerts -storepass changeit -file /app-captcha-api/certs/db-ca-cert.cer -alias decisionmines-db
  else
    echo "DB cert already imported in java keystore."
  fi
else
  echo "db-ca-cert does not exist"
fi
java -jar app-captcha-api.jar
