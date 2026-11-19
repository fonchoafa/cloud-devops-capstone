# CI/CD and monitoring

## Pipeline (`.github/workflows/ci-cd.yml`)
| Job | What it proves |
| --- | --- |
| Test | 14 automated tests pass |
| Build and check the image | The Dockerfile builds, the container becomes healthy, `/metrics` works, delete without key gives 401 |
| Publish to GHCR | Image tagged `latest` and with the commit id; uses the built-in `GITHUB_TOKEN` |
| Verify the live deployment | The live `/health` reports this commit id, `/metrics` is 404 publicly, delete without key is 401 |

Pull requests run only test and build. Dependabot proposes dependency and Docker updates weekly. Do not merge a Dependabot PR while a `main` run is in progress (the run would be cancelled).

## Monitoring layers
| Layer | Tool | Where to see it |
| --- | --- | --- |
| App metrics (requests, latency, errors) | Prometheus scraping `/metrics` | SSH tunnel to `localhost:9090` |
| Alert rules | `monitoring/alerts.yml`: AppDown, HighErrorRate, SlowRequests | Prometheus **Alerts** page |
| Container logs | Docker `awslogs` driver to CloudWatch Logs | Log group `/devops-capstone/app` |
| Error alarm | Metric filter on `{ $.level = "error" }` then alarm `devops-capstone-app-errors` | CloudWatch alarms |
| Server health | CPU alarm, status-check alarm, memory and disk via the CloudWatch agent | CloudWatch |
| Cost | AWS Budget with email at 80% of the monthly limit | Email |
| Notification | SNS email topic | Your inbox |

## Quick drills
- **Break the app on purpose:** `ssh` in and run `docker stop capstone-app-1`; Prometheus `AppDown` goes pending then firing, and compose restarts it.
- **Generate errors:** call `curl.exe <live_url>/api/notes/bad/attachment` a few times and watch the request metrics in Prometheus.
