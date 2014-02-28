#!/bin/bash
cd /home/openca/openca-base-1.5.0
FQDN=`hostname`
export FQDN
./configure --with-openssl-tools-prefix=/opt/openca --with-openca-user=openca --with-openca-group=openca --with-web-host=$FDQN --with-db-name=openca --with-db-host=localhost --with-db-user=opencadbuser --with-db-password=openca --with-db-type=mysql --with-service-mail-account=ca@puppetlabs.com --with-httpd-user=apache --with-httpd-group=apache --with-cgi-fs-prefix=/var/www/cgi-bin/pki --with-cgi-url-prefix=/cgi-bin/pki --with-htdocs-fs-prefix=/var/www/pki --with-openca-prefix=/opt/openca --with-module-prefix=/opt/openca/ca/modules --with-ca-organization=Puppetlabs-CA --with-organization=Puppetlabs --with-ca-locality=Portland --with-ca-state=OR --with-ca-country=US --with-support-mail-address=support@puppetlabs.com  --disable-external-modules --enable-dbi --enable-rbac --enable-db --prefix=/opt/openca --with-openssl-prefix=/usr/include/ --with-openca-tools-prefix=/opt/openca
BASENAME=/home/openca/openca-base-1.5.0
cd $BASENAME
chown -R openca:openca * 

cd $BASENAME/src/ext-modules

for package in "XML-Parser-2.41.tar.gz" "Net-SSLeay-1.40.tar.gz","XML-Twig-3.44.1.tar.gz"
 do
   STUB=`echo $package|sed s/"\.tar\.gz"//`
   tar xzvf $package
   cd $BASENAME/src/ext-modules/$STUB
   perl Makefile.PL -y
   make install
   cd $BASENAME/src/ext-modules
 done

cd $BASENAME
make;
make install-modules
make install-common
make install-online install-offline;
cd /home/openca/openca-base-1.5.0/src/scripts;
make install
FILE_CHECK=`ls -1|grep -v in|grep -v modver|grep -v Makefile|wc -l`
if [[ $FILE_CHECK -eq 19 ]]
then
  BASENAME=/opt/openca/openca-base-1.5.0/src/scripts
  DESTINATION=/opt/openca/bin
  ls -1|grep -v in|grep -v modver|grep -v Makefile|while read LINE
do
  cp $BASENAME/$LINE $DESTINATION/$LINE
  chown openca:openca $DESTINATION/$LINE
  chmod 700 $DESTINATION/$LINE
done
fi
