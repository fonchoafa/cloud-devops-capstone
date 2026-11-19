# Checks the live capstone site. Usage:  .\scripts\smoke-test.ps1 -Url http://<elastic-ip>
param([Parameter(Mandatory = $true)][string]$Url)
$Url = $Url.TrimEnd('/')
$fail = 0
function Check($name, $ok) {
  if ($ok) { Write-Host "PASS  $name" -ForegroundColor Green } else { Write-Host "FAIL  $name" -ForegroundColor Red; $script:fail++ }
}
function Status($method, $path) {
  try { (Invoke-WebRequest -Uri "$Url$path" -Method $method -UseBasicParsing).StatusCode }
  catch { if ($_.Exception.Response) { [int]$_.Exception.Response.StatusCode } else { 0 } }
}
$h = Invoke-RestMethod "$Url/health"
Check "health is ok (version $($h.version))" ($h.status -eq "ok")
Check "home page loads (200)" ((Status GET "/") -eq 200)
Check "notes API reachable (200)" ((Status GET "/api/notes") -eq 200)
Check "public /metrics is blocked (404)" ((Status GET "/metrics") -eq 404)
Check "delete without admin key is refused (401)" ((Status DELETE "/api/notes/x") -eq 401)
Check "app port 3000 is not public" (-not (Test-NetConnection ([uri]$Url).Host -Port 3000 -WarningAction SilentlyContinue -InformationLevel Quiet))
if ($fail -eq 0) { Write-Host "`nAll checks passed." -ForegroundColor Green } else { Write-Host "`n$fail check(s) failed." -ForegroundColor Red; exit 1 }
