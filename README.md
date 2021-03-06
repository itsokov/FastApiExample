# FastApiExample


### Description
Intended as a POC for running FastApi Python application on Windows Server with IIS as reverse proxy.

### How it works
When executed PythonWebServer.ps1 will clone this repo and create a windows service that runs uvicorn.
Then sets up IIS and reconfigures it to act as a reverse proxy for that Windows service. 
With a SSL certificate and respective binding IIS will act as SSL terminator.
Additionally a http to https redirect could be configured.

### Tested on Windows Server 2019 Datacenter edition


### Related Articles
 - https://stackoverflow.com/questions/65591630/fastapi-as-a-windows-service
 - https://techcommunity.microsoft.com/t5/iis-support-blog/setup-iis-with-url-rewrite-as-a-reverse-proxy-for-real-world/ba-p/846222
 - https://techcommunity.microsoft.com/t5/iis-support-blog/iis-acting-as-reverse-proxy-where-the-problems-start/ba-p/846259


