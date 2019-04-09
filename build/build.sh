#!/usr/bin/env bash

set -e

echo "prepping clamav"

yum update -y
amazon-linux-extras install epel -y
yum install -y cpio yum-utils zip

# extract binaries for clamav, json-c, pcre
mkdir -p /tmp/build
pushd /tmp/build
yumdownloader -x \*i686 --archlist=x86_64 clamav clamav-lib clamav-update json-c pcre2
rpm2cpio clamav-0*.rpm | cpio -vimd
rpm2cpio clamav-lib*.rpm | cpio -vimd
rpm2cpio clamav-update*.rpm | cpio -vimd
rpm2cpio json-c*.rpm | cpio -vimd
rpm2cpio pcre*.rpm | cpio -vimd
popd

mkdir -p bin
mkdir -p lib

cp /tmp/build/usr/bin/clamscan /tmp/build/usr/bin/freshclam bin/.
cp /tmp/build/usr/lib64/* lib/.
cp freshclam.conf bin/freshclam.conf

zip -r9 /opt/app/lambda_layer.zip bin
zip -r9 /opt/app/lambda_layer.zip lib