Install-WindowsFeature -name Web-Server -IncludeAllSubFeature -IncludeManagementTools
Import-Module WebAdministration

$InstallPath="c:\PythonWebApp\FastApiExample"

New-Item -Path $InstallPath -ItemType "directory"

cd $InstallPath

Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#reload path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

choco install git -y
choco install googlechrome -y --ignore-checksums
choco install webdeploy -y
choco install urlrewrite -y
choco install iis-arr -y --ignore-checksums

#reload path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

git clone https://github.com/itsokov/FastApiExample.git $InstallPath -q

choco install nssm -y
choco install python -y

#reload path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

pip install -r requirements.yml

nssm install "FastAPIWindowsService" "uvicorn" "main:app --port 5000 --log-level info --workers 2"
nssm set "FastAPIWindowsService" AppDirectory "C:\users\itsokov\FastApiExample\"
nssm set "FastAPIWindowsService" AppStdout "C:\users\itsokov\FastApiExample\logs\access.log"
nssm set "FastAPIWindowsService" AppStderr "C:\users\itsokov\FastApiExample\logs\service.log"
nssm start "FastAPIWindowsService"

#nssm remove "FastAPIWindowsService"


Copy-Item .\www\web.config C:\inetpub\wwwroot

## add self signed certificate generation
## add arr enable
# add 443 binding to default website

iisreset

#problem with compression!