# Docker GCSPROXY / Panubo Proxy

This is a docker image for [daichirata/gcsproxy](https://github.com/daichirata/gcsproxy) it also has a nginx server and a template config file that reads from GCE metadata. It is desigined to be an imporved static site hosting on GCS/GCP.

## Note

GCS doesn't allow objects starting with `.well-defined/acme-challenge` (To prevent users from getting certificates with like my_bucket.storage.googleapis.com).

