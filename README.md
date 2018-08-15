# Docker GCSPROXY / Panubo Proxy

This is a docker image for [daichirata/gcsproxy](https://github.com/daichirata/gcsproxy) it also has a nginx server and a template config file that reads from GCE metadata. It is desigined to be an imporved static site hosting on GCS/GCP.

## Note

GCS doesn't allow objects starting with `.well-defined/acme-challenge` (To prevent users from getting certificates with like my_bucket.storage.googleapis.com).

Ensure that Google Cloud CDN includes all components of the request URI in cache keys. See https://cloud.google.com/cdn/docs/using-cache-keys

## Development

The included `docker-compose.yml` can be used for development. It requires a `pnb-proxy.json` file present in the repo root and gcloud `~/.config/gcloud/application_default_credentials.json`.
