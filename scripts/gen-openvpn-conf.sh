#!/bin/sh
# Generate some OpenVPN configurations from the aes-cbc-128-hmac-sha1
set -eu
if [ ! -d aes-cbc-128-hmac-sha1 ]; then
	echo "No folder aes-cbc-128-hmac-sha1 here"
	exit 1
fi
[ -d aes-cbc-256-hmac-sha256 ] && rm -rf aes-cbc-256-hmac-sha256
cp -r aes-cbc-128-hmac-sha1 aes-cbc-256-hmac-sha256
find aes-cbc-256-hmac-sha256/ -type f -name openvpn.conf -exec sed -i "" 's/AES-128-CBC/AES-256-CBC/g' {} \;
find aes-cbc-256-hmac-sha256/ -type f -name openvpn.conf -exec sed -i "" 's/SHA1/SHA256/g' {} \;
[ -d aes-gcm-128 ] && rm -rf aes-gcm-128
cp -r aes-cbc-128-hmac-sha1 aes-gcm-128
find aes-gcm-128/ -type f -name openvpn.conf -exec sed -i "" 's/AES-128-CBC/AES-128-GCM/g' {} \;
[ -d aes-gcm-256 ] && rm -rf aes-gcm-256
cp -r aes-cbc-128-hmac-sha1 aes-gcm-256
find aes-gcm-256/ -type f -name openvpn.conf -exec sed -i "" 's/AES-128-CBC/AES-256-GCM/g' {} \;
find aes-gcm-256/ -type f -name openvpn.conf -exec sed -i "" 's/SHA1/SHA256/g' {} \;
[ -d bf-cbc-128-hmac-sha1 ] && rm -rf bf-cbc-128-hmac-sha1
cp -r aes-cbc-128-hmac-sha1 bf-cbc-128-hmac-sha1
find bf-cbc-128-hmac-sha1/ -type f -name openvpn.conf -exec sed -i "" 's/AES-128-CBC/BF-CBC/g' {} \;
[ -d null ] && rm -rf null
cp -r aes-cbc-128-hmac-sha1 null
find null/ -type f -name openvpn.conf -exec sed -i "" 's/AES-128-CBC/none/g' {} \;
find null/ -type f -name openvpn.conf -exec sed -i "" 's/SHA1/none/g' {} \;
find null/ -type f -name openvpn.conf -exec sed -i "" 's/engine cryptodev//g' {} \;
