#!/bin/sh
# Generate all IPSec configurations from the aes-cbc-128
set -eu
if [ ! -d aes-cbc-128-hmac-sha1 ]; then
	echo "No folder aes-cbc-128-hmac-sha1 here"
	exit 1
fi
[ -d aes-cbc-256-hmac-sha2-256 ] && rm -rf aes-cbc-256-hmac-sha2-256
cp -r aes-cbc-128-hmac-sha1 aes-cbc-256-hmac-sha2-256
#Replace rijndael-cbc 128bits key (16 8bits values) by 256bits (32 8bits values)
#Replace sha1 160bits keys (20 8bits values) by sha2-256 256bits keys (32 8bits values)
find aes-cbc-256-hmac-sha2-256/ -type f -name ipsec.conf -exec sed -i "" 's/rijndael-cbc "1234567890123456"/rijndael-cbc "12345678901234567890123456789012"/g' {} +
find aes-cbc-256-hmac-sha2-256/ -type f -name ipsec.conf -exec sed -i "" 's/sha1 "12345678901234567890"/sha2-256 "12345678901234567890123456789012"/g' {} +
[ -d aes-gcm-128 ] && rm -rf aes-gcm-128
cp -r aes-cbc-128-hmac-sha1 aes-gcm-128
#Replace rijndael-cbc 128bits key (16 8bits values) by aes-gcm-16 160bits keys (20 8bits values)
#Remove HMAC
find aes-gcm-128/ -type f -name ipsec.conf -exec sed -i "" 's/rijndael-cbc "1234567890123456"/aes-gcm-16 "12345678901234567890"/g' {} +
find aes-gcm-128/ -type f -name ipsec.conf -exec sed -i "" 's/ -A hmac-sha1 "12345678901234567890"//g' {} +
[ -d aes-gcm-256 ] && rm -rf aes-gcm-256
#Replace rijndael-cbc 128bits key (16 8bits values) by aes-gcm-16 288bits keys (36 8bits values)
#Remove HMAC
cp -r aes-cbc-128-hmac-sha1 aes-gcm-256
find aes-gcm-256/ -type f -name ipsec.conf -exec sed -i "" 's/rijndael-cbc "1234567890123456"/aes-gcm-16 "123456789012345678901234567890123456"/g' {} +
find aes-gcm-256/ -type f -name ipsec.conf -exec sed -i "" 's/ -A hmac-sha1 "12345678901234567890"//g' {} +
[ -d null ] && rm -rf null
cp -r aes-cbc-128-hmac-sha1 null
find null/ -type f -name ipsec.conf -exec sed -i "" 's/rijndael-cbc "1234567890123456"/null ""/g' {} +
find null/ -type f -name ipsec.conf -exec sed -i "" 's/ -A hmac-sha1 "12345678901234567890"//g' {} +
