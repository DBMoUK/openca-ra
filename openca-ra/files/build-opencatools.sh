#!/bin/bash
cd /home/openca/openca-tools-1.3.0
./configure --prefix=/opt/openca --exec-prefix=/opt/openca --with-openca-prefix=/opt/openca --with-openca-user=openca --with-openca-group=openca;
make;
make install;
