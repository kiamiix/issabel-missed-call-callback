#!/bin/bash
# Prints the extension that last called number $1 without an answer.
# Usage: lastcaller.sh <caller-number> [hours, default 3]
# Matches on the last 10 digits so 0912.. / +98912.. / 912.. are the same number.
# Runs as the asterisk user; reads the DB password from /etc/amportal.conf at run time.

EXT_LEN=3   # length of your internal extensions

n="${1: -10}"
[[ "$n" =~ ^[0-9]{10}$ ]] || exit 0
[[ "${2:-3}" =~ ^[0-9]+$ ]] || exit 0
u=$(grep '^AMPDBUSER' /etc/amportal.conf | cut -d= -f2-)
p=$(grep '^AMPDBPASS' /etc/amportal.conf | cut -d= -f2-)
mysql -N -u"$u" -p"$p" asteriskcdrdb 2>/dev/null -e \
 "SELECT src FROM cdr WHERE dst LIKE '%$n' AND disposition<>'ANSWERED'
  AND calldate > NOW() - INTERVAL ${2:-3} HOUR AND CHAR_LENGTH(src) = $EXT_LEN
  ORDER BY calldate DESC LIMIT 1"
