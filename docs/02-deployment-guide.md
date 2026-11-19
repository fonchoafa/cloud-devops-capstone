# Deployment guide (Windows, PowerShell)

Needs: Git, Terraform, AWS CLI configured (`aws sts get-caller-identity` works), an SSH key at `~/.ssh/id_ed25519.pub`.

## 1. Publish the code and the image
1. Create a **public** GitHub repo `cloud-devops-capstone`, push this folder (check that `.env` and `terraform.tfvars` are not in `git status`).
2. Open the **Actions** tab and wait for the run to go green (test, build, publish). Deploy-verify is skipped for now.
3. GitHub > your profile > **Packages** > `cloud-devops-capstone` > **Package settings** > **Change visibility** > **Public**. The server pulls the image without a login, so it must be public.

## 2. Create the infrastructure
```powershell
cd terraform
copy terraform.tfvars.example terraform.tfvars
# edit terraform.tfvars: my_ip_cidr (curl.exe -4 -s ifconfig.me, then add /32) and alert_email
terraform init
terraform plan
terraform apply
```
Confirm the SNS subscription email AWS sends you, or no alerts arrive.

## 3. Turn on the live check
Copy the `live_url` output, then GitHub repo > **Settings > Secrets and variables > Actions > Variables > New repository variable**: name `LIVE_URL`, value the URL (no trailing slash). Re-run the latest workflow run; the **Verify the live deployment** job now runs.

## 4. Verify
```powershell
curl.exe <live_url>/health
.\scripts\smoke-test.ps1 -Url <live_url>
terraform output admin_key_command   # run the printed command to read the admin key
```

## 5. Look at Prometheus
```powershell
ssh -i ~/.ssh/id_ed25519 -L 9090:localhost:9090 ubuntu@<ip>
```
Leave it open and browse to http://localhost:9090.

## Troubleshooting
| Symptom | Cause / fix |
| --- | --- |
| Site does not answer for a few minutes | First boot installs Docker. Check `sudo tail -50 /var/log/cloud-init-output.log` |
| `/health` fails, log says "image pull failed" | The GHCR package is still private, or the pipeline has not published yet |
| SSH times out | Your IP changed. Update `my_ip_cidr` and `terraform apply` |
| Deploy-verify fails after 10 minutes | On the server: `sudo systemctl status capstone-update.service` and `docker compose -f /opt/capstone/src/deploy/docker-compose.yml ps` |

## Clean up
```powershell
cd terraform
terraform destroy
```
Do this once the module is reviewed. Also delete the GHCR package if you wish.
