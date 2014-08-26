#!/bin/sh
composer install
mkdir -m 777 temp/
mkdir -m 777 log/
cd www/
bower install
coffee --compile coffee/

