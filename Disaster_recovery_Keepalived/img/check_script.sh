#!/bin/bash

([[ -f '/var/www/html/index.html' ]]) && ( exec 2>/dev/null; echo -en > /dev/tcp/127.0.0.1/80 )
