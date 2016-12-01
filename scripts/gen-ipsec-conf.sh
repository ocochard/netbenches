#!/bin/sh
# Generate all IPSec configurations from the aes-cbc-128
set -eu
if [ ! -d aes-cbc-128 ]; then
	echo "No folder aes-cbc-128 here"
	exit 1
fi
cp -r aes-cbc-128 aes-cbc-256
find aes-cbc-256/ -type f -name ipsec.conf -exec sed -i -e 's/1234567890123456/12345678901234561234567890123456/g' {} +
cp -r aes-cbc-128 camellia-cbc-128
cp -r aes-cbc-256 camellia-cbc-256
find camellia-cbc-*/ -type f -name ipsec.conf -exec sed -i -e 's/rijndael-cbc/camellia-cbc/g' {} +
cp -r aes-cbc-128 aes-ctr-128
find aes-ctr-128/ -type f -name ipsec.conf -exec sed -i -e 's/rijndael-cbc/aes-ctr/g' {} +
find aes-ctr-128/ -type f -name ipsec.conf -exec sed -i -e 's/1234567890123456/12345678901234567890/g' {} +
cp -r aes-ctr-128 aes-ctr-256
find aes-ctr-256/ -type f -name ipsec.conf -exec sed -i -e 's/12345678901234567890/123456789012345678901234567890123456/g' {} +
cp -r aes-ctr-128 aes-gcm-128
cp -r aes-ctr-256 aes-gcm-256
find aes-gcm-*/ -type f -name ipsec.conf -exec sed -i -e 's/aes-ctr/aes-gcm-16/g' {} +
cp -r aes-cbc-128 null
find null/ -type f -name ipsec.conf -exec sed -i -e 's/rijndael-cbc/null/g' {} +
find null/ -type f -name ipsec.conf -exec sed -i -e 's/1234567890123456//g' {} +

