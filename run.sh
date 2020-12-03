#!/bin/bash
/usr/sbin/netdata &
/usr/bin/supervisord -n
