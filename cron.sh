#!/bin/bash
# install the sync cron entry (idempotent), then verify it actually landed
set -u

TMP=/tmp/cyberia-cron.txt
LINE="* * * * * /home/cyber/cyberia-my-sync.sh >/dev/null 2>&1"

crontab -l 2>/dev/null | grep -v cyberia-my-sync > "$TMP" || true
echo "$LINE" >> "$TMP"
crontab "$TMP"
rm -f "$TMP"

echo "--- crontab now ---"
crontab -l

if crontab -l 2>/dev/null | grep -q cyberia-my-sync; then
  echo "CRON OK"
else
  echo "CRON FAILED"
fi
