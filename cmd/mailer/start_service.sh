#!/bin/bash
TEMPLATES_OUT=templates.tar.gz

cd mailer/

tar -zxvf $TEMPLATES_OUT

rm $TEMPLATES_OUT

sudo su
systemctl restart mailer

exit