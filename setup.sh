#!/bin/bash
# one-time setup: cron-based github -> cyberia.my static sync (runs as user cyber)
set -e

CLONE=/home/cyber/cyberia-my-static
DOCROOT=/var/www/html/cyberia.my

if [ ! -d "$CLONE/.git" ]; then
  git clone --depth 1 -b main https://github.com/cyberia-to/my-static.git "$CLONE"
fi

cat > /home/cyber/cyberia-my-sync.sh <<'EOF'
#!/bin/bash
# sync static branch of cyberia-to/my into the cyberia.my docroot
cd /home/cyber/cyberia-my-static || exit 1
git fetch origin main --quiet || exit 0
if [ "$(git rev-parse HEAD)" != "$(git rev-parse origin/main)" ]; then
  git reset --hard origin/main --quiet
  for d in */; do
    rsync -a --exclude .git "$d" "/var/www/html/cyberia.my/$d"
  done
fi
EOF
chmod +x /home/cyber/cyberia-my-sync.sh

( crontab -l 2>/dev/null | grep -v cyberia-my-sync ; echo "* * * * * /home/cyber/cyberia-my-sync.sh" ) | crontab -

/home/cyber/cyberia-my-sync.sh
echo "SETUP OK — cron installed, first sync done"
