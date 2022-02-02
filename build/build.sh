#!/usr/bin/env bash

set -e

echo "prepping clamav"

rm -rf bin
rm -rf lib
rm lambda_layer.zip || true

yum update -y
amazon-linux-extras install epel -y
yum install -y cpio yum-utils zip

# extract binaries for clamav, json-c, pcre
mkdir -p /tmp/build
pushd /tmp/build

# Download the clamav package that includes unrar
curl -L --output clamav-0.103.3-22187.el7.art.x86_64.rpm http://www6.atomicorp.com/channels/atomic/centos/7/x86_64/RPMS/clamav-0.103.3-22187.el7.art.x86_64.rpm
rpm2cpio clamav-0*.rpm | cpio -vimd

# Download libcrypt.so.1
curl -L --output glibc-2.17-317.el7.x86_64.rpm http://mirror.centos.org/centos/7/os/x86_64/Packages/glibc-2.17-317.el7.x86_64.rpm
rpm2cpio glibc*.rpm | cpio -vimd

# Download other package dependencies
yumdownloader -x \*i686 --archlist=x86_64 clamav clamav-lib clamav-update json-c pcre2 libxml2 bzip2-libs libtool-ltdl xz-libs libprelude gnutls nettle libcurl libnghttp2 libidn2 libssh2 openldap libffi krb5-libs keyutils-libs libunistring cyrus-sasl-lib nss nspr libselinux openssl-libs libcrypt
rpm2cpio clamav-lib*.rpm | cpio -vimd
rpm2cpio clamav-update*.rpm | cpio -vimd
rpm2cpio json-c*.rpm | cpio -vimd
rpm2cpio pcre*.rpm | cpio -vimd
rpm2cpio libxml2*.rpm | cpio -vimd
rpm2cpio bzip2-libs*.rpm | cpio -vimd
rpm2cpio libtool-ltdl*.rpm | cpio -vimd
rpm2cpio xz-libs*.rpm | cpio -vimd
rpm2cpio libprelude*.rpm | cpio -vimd
rpm2cpio gnutls*.rpm | cpio -vimd
rpm2cpio nettle*.rpm | cpio -vimd
rpm2cpio libcurl*.rpm | cpio -vimd
rpm2cpio libnghttp2*.rpm | cpio -vimd
rpm2cpio libidn2*.rpm | cpio -vimd
rpm2cpio libssh2*.rpm | cpio -vimd
rpm2cpio openldap*.rpm | cpio -vimd
rpm2cpio libffi*.rpm | cpio -vimd
rpm2cpio krb5-libs*.rpm | cpio -vimd
rpm2cpio keyutils-libs*.rpm | cpio -vimd
rpm2cpio libunistring*.rpm | cpio -vimd
rpm2cpio cyrus-sasl-lib*.rpm | cpio -vimd
rpm2cpio nss*.rpm | cpio -vimd
rpm2cpio nspr*.rpm | cpio -vimd
rpm2cpio libselinux*.rpm | cpio -vimd
rpm2cpio openssl-libs*.rpm | cpio -vimd
rpm2cpio libcrypt*.rpm | cpio -vimd

# reset the timestamps so that we generate a reproducible zip file where
# running with the same file contents we get the exact same hash even if we
# run the same build on different days
find usr -exec touch -t 200001010000 "{}" \;
popd

mkdir -p bin
mkdir -p lib

cp /tmp/build/usr/bin/clamscan /tmp/build/usr/bin/freshclam bin/.
cp -R /tmp/build/usr/lib64/* lib/.
cp -R /tmp/build/lib64/* lib/.
cp freshclam.conf bin/freshclam.conf

zip -r9 /opt/app/lambda_layer.zip bin
zip -r9 /opt/app/lambda_layer.zip lib
