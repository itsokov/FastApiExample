Install-WindowsFeature -name Web-Server -IncludeAllSubFeature -IncludeManagementTools
Import-Module WebAdministration

$InstallPath="c:\PythonWebApp\FastApiExample"

New-Item -Path $InstallPath -ItemType "directory"

cd $InstallPath

#Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#reload path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

choco install git -y
choco install googlechrome -y --ignore-checksums
choco install webdeploy -y
choco install urlrewrite -y
choco install iis-arr -y --ignore-checksums
choco install nssm -y
choco install python -y

#reload path
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 

git clone https://github.com/itsokov/FastApiExample.git $InstallPath -q

pip install -r "$InstallPath\requirements.yml" 

nssm install "FastAPIWindowsService" "uvicorn" "main:app --port 5000 --log-level info --workers 2"
nssm set "FastAPIWindowsService" AppDirectory "$InstallPath\"
nssm set "FastAPIWindowsService" AppStdout "$InstallPath\logs\access.log"
nssm set "FastAPIWindowsService" AppStderr "$InstallPath\logs\service.log"
nssm start "FastAPIWindowsService"

#nssm remove "FastAPIWindowsService"


Copy-Item "$InstallPath\www\web.config" C:\inetpub\wwwroot

## add self signed certificate generation
## add arr enable
Set-WebConfigurationProperty -pspath 'MACHINE/WEBROOT/APPHOST'  -filter "system.webServer/proxy" -name "enabled" -value "True"

# add 443 binding to default website

#add server variables
Add-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -location "Default Web Site"  -filter "system.webServer/rewrite/allowedServerVariables" -name "." -value @{name='HTTP_X_ORIGINAL_ACCEPT_ENCODING'}
Add-WebConfigurationProperty -pspath "MACHINE/WEBROOT/APPHOST" -location "Default Web Site"  -filter "system.webServer/rewrite/allowedServerVariables" -name "." -value @{name='HTTP_ACCEPT_ENCODING'}

iisreset
