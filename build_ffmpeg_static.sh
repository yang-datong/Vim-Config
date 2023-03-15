#!/bin/bash

ff_version="ffmpeg-4.2.2"
ff="${ff_version}.tar.bz2"

main(){
	cd ~/

	if [ ! -d $ff_version ];then
		 if [ ! -f "$ff" ];then wget https://ffmpeg.org/releases/$ff;fi
		 tar -xjvf $ff
	fi

	cd $ff_version

	if [ -f "Changelog" ];then
		 rm Changelog *.md COPYING.* CREDITS MAINTAINERS RELEASE* VERSION
	fi

echo "IyEvYmluL2Jhc2gKZWNobyAtZSAiXDAzM1szMW1UaGUgZm9sbG93aW5nIHdpbGwgYmUgcGVyZm9y
bWVkIGNvZGUgOlwwMzNbMG0iCmNhdCAkMAplY2hvIC1lICJcMDMzWzMxbUFyZSB5b3UgYWxyZWFk
eT9bWS9uXVwwMzNbMG0iCnJlYWQgb2sKaWYgWyAiJG9rIiA9PSAibiIgXTt0aGVuIGV4aXQ7ZmkK
Ci4vY29uZmlndXJlIFwKICAgIC0tcHJlZml4PSQocHdkKS9idWlsZCBcCiAgICAtLWVuYWJsZS1z
dGF0aWMgLS1kaXNhYmxlLXNoYXJlZCBcCiAgICAtLWV4dHJhLWNmbGFncz0iLXN0YXRpYyIgXAog
ICAgLS1leHRyYS1sZGZsYWdzPSItc3RhdGljIiBcCiAgICAtLXBrZy1jb25maWctZmxhZ3M9Ii0t
c3RhdGljIiBcCiAgICAtLWRpc2FibGUtYXNtIFwKICAgIC0tZGlzYWJsZS1kb2MgXAogICAgLS1k
aXNhYmxlLW5ldHdvcmsgXAogICAgLS1kaXNhYmxlLW9wdGltaXphdGlvbnMgXAogICAgLS1kaXNh
YmxlLWZmcHJvYmUgLS1kaXNhYmxlLWZmcGxheSBcCiAgICAtLWRpc2FibGUtYXZkZXZpY2UgLS1k
aXNhYmxlLWF2cmVzYW1wbGUgLS1kaXNhYmxlLXBvc3Rwcm9jIC0tZGlzYWJsZS1zd3Jlc2FtcGxl
CgptYWtlIC1qIDE2ICYmIG1ha2UgaW5zdGFsbAo=" | base64 -d > load.sh && bash load.sh
}

main
