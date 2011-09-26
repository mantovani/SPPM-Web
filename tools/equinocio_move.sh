#!/bin/sh

DAY=`date +%d|sed 's/^0//'`

QUARENTENA=/opt/sao-paulo.pm/SPPM-Web/quarententa
EQUINOCIO=/opt/sao-paulo.pm/SPPM-Web/root/equinocio/2011/set/

if [ -f $QUARENTENA/$DAY.pod ] ; then
	mv $QUARENTENA/$DAY.pod $EQUINOCIO
fi

