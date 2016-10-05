# tcl

A command within square brackets ([]) is replaced with the return value from the execution of that command.
Words within double quotes or braces are grouped into a single argument. However, double quotes and braces cause different behavior during the substitution phase.
By contrast, grouping words within double braces *disables* substitution within the braces
Characters within braces are passed to a command exactly as written. The only "Backslash Sequence" that is processed within braces is the backslash at the end of a line. This is still a line continuation character.
Inside an already grouped string (" ou {}) a brace is treated as ASCII character
If the string is grouped with quotes, substitutions will occur within the quoted string, even between the braces. 
command in [] is actually part of the Tcl substitution phase.
A square bracket within braces is not modified during the substitution phase.
set returns the new value of the variable
The test expression following if should return one of:
                      False            True
                      -------          ------ 
 a numeric value      0                all others
 yes/no               no               yes 
 true/false           false            true

True/FALSE or YeS/nO are legitimate return
The test expression following if may be enclosed within quotes, or braces. If it is enclosed within braces, it will be evaluated within the if command, and if enclosed within quotes it will be evaluated during the substitution phase, and then another round of substitutions will be done within the if command.

set y x;
if "$$y != 1" {

When proc is invoked, it creates a structure to define the procedure, and adds that structure and name to the tables used when parsing commands. If the command already existed, then it will be replaced by the new command with the same name.

si ya pas de return, proc will return the value of the last command to be executed.

"blah{$toto}"
{blah{$toto}}

## vuln
tclsh8.5 [~]set cc {[puts pwn]}
[puts pwn]
tclsh8.5 [~]if $cc { puts "ok" }

## pas vuln
tclsh8.5 [~]if [catch {$cc} msg] { puts "ok" }
ok

## vuln
tclsh8.5 [~]if [catch $cc msg] { puts "ok: $msg" } else { puts "else:$msg" }
pwn
ok: empty command name ""

## pas vuln
eval $lqry

de manière générale, faire eval d'une liste ne presente pas de vuln


