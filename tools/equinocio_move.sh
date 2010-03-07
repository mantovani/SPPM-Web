#!/bin/sh

DAY=`date -d 'day' +%d|sed 's/^0//'`
QUARENTENA=$HOME/quarentena
EQUINOCIO=$HOME/www/sao-paulo.pm.org/catalyst/root/equinocio/2010/mar/

if [ -f $QUARENTENA/$DAY.pod ] ; then
	mv $QUARENTENA/$DAY.pod $EQUINOCIO
fi

