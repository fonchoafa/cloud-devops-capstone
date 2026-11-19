# Screenshots checklist

Save each file in this folder with exactly this name.

| File | What to capture |
| --- | --- |
| 01-actions-green.png | GitHub Actions run with all jobs green, including "Verify the live deployment" |
| 02-ghcr-package.png | The public package page on GitHub |
| 03-terraform-apply.png | End of `terraform apply` with the outputs |
| 04-live-site.png | The live site in the browser (address bar visible) |
| 05-health.png | `curl.exe <live_url>/health` showing `version` equal to the commit id |
| 06-smoke-test.png | `.\scripts\smoke-test.ps1` all PASS |
| 07-docker-ps.png | `docker compose ps` on the server (SSH) |
| 08-prometheus.png | Prometheus Targets page, app UP (through the SSH tunnel) |
| 09-cloudwatch-logs.png | CloudWatch log group with app JSON logs |
| 10-cloudwatch-alarms.png | CloudWatch alarms list |
| 11-architecture.png | Copy of `docs/architecture.png` (optional, already in docs) |
