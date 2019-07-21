#!/bin/bash
ASSETS_OUT=assets.tar.gz
TEMPLATES_OUT=templates.tar.gz

cd website/
tar -zxvf $ASSETS_OUT

tar -zxvf $TEMPLATES_OUT

rm $ASSETS_OUT $TEMPLATES_OUT