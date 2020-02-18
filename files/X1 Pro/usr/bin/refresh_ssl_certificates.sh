#!/bin/sh
# Regenerate SSL keys for HTTPS, set HTTPS server to use new 
# certificates then restart uhttpd service.
# Author: Nicholas Smith <nicholas.smith@telcoantennas.com.au>
# 13-Jan-2020

echo "Regenerating SSL certificates for a validity of 730 days then restarting HTTP server."
logger -t INFO "SSL Certificate: Regenerating SSL certificates for a validity of 730 days then restarting HTTP server."
/usr/bin/openssl req -x509 -days 730 -sha256 -outform der -nodes -keyout /etc/uhttpd.key -out /etc/uhttpd.crt -config=/etc/telcoscert.config
logger -t INFO "SSL Certificate: Restarting web server to use new certificates."
echo "Restarting web server to use new certificates."
/etc/init.d/uhttpd restart
logger -t INFO "SSL Certificate: Process completed successfully."
echo "Done."
