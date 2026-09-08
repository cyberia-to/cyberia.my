# cyberia.my

What [cyberia.my](https://cyberia.my) serves beside the SPA. Each directory here
is a path on the site:

| directory | url | source |
|---|---|---|
| `cx/` | [/cx](https://cyberia.my/cx) | generated daily by [cx](https://github.com/cyberia-to/cx) |
| `hackathon/` | [/hackathon](https://cyberia.my/hackathon) | written by hand |

Push here and the page is live within a minute: cyberproxy clones this repo and a
cron job rsyncs each directory into the nginx docroot. The sync script, the host
setup and the runbook live in `cybernode` under `sites/cyberia.my/`, where server
infrastructure belongs.

## the daily fix

`.github/workflows/cx-daily.yml` runs at 06:20 UTC: it checks out the `cx` crate,
runs its tests, computes the day's century index from public price sources, and
commits `cx/index.html` and `cx/cx.json` here. With the `GRAPH_TOKEN` secret the
same run writes the fix into the `cyberia` graph at `protocol/cx/`.

Pages are plain HTML with no build step and no dependency beyond the Play webfont —
they are meant to outlive the tooling that made them.
