#!/bin/bash

BASENAME=/home/openca/OPENCA_PERL_MODULES

# Perl Modules unpacked in here.

cd $BASENAME
ls -1|grep tar|while read TAR
do
  tar xzvf $TAR
done

# Untar! ALL THE THINGS


ls -1|grep -v tar|sort > MODULE_INSTALL_ORDER.txt

if [[ $? -eq 0 ]]
then
  cat MODULE_INSTALL_ORDER.txt|while read MODULE
do
  cd $MODULE
  perl Makefile.PL -y INSTALL_BASE=/opt/openca/ca/modules/perl5
  make 
  make install
done
fi

# Install! ALL THE THINGS
if [[ $? -eq 0 ]]
then
  ln -fs /opt/openca/ca/modules/perl5/lib/perl5/Net /opt/openca/ca/modules/perl5/Net
  ln -fs /usr/local/share/perl5/XML /opt/openca/ca/modules/perl5
fi

# Create link to /opt/openca/ca/modules/perl5/Net so the @INC path works.
