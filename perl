# perl

http://sylvain.lhullier.org/publications/perl.html

perl -e  "print '0'x64"
perl -ne 'chop;@a=split(/;/);print(($a[0]?$a[0]:$a[1]).":".$a[2].":0:0:".$a[3]."::\n");'
find -type f | xargs cat | perl -ne 'print join("\n", (m|https?://[\w./?&=]+|iog))."\n"'

# doc
perldoc perlre
faq.perl.org

# toujours executer avec -w pour avoir les warnings et rendre le langage moins permissif
#!/usr/bin/perl -w
use strict; # module ayant pour rôle de rendre la syntaxe Perl plus coercitive (modules pragmatiques: strict, diagnostics, etc)

# contexte
2 contextes principaux: scalaire et liste

plusieurs contextes scalaire:
- numérique (addition)
- chaines de caractères
- tolérant (ni chaine ni numerique, simplement scalaire)

contexte vide
"Bonjour"; => on aura un warning

# chaines de caractères: caractères speciaux à protéger avec \
- entre ":
$ @ \ "
- entre ':
' \

# valeur undef: valeur par defaut d'une variable scalaire non initialisée:
my $x;
my $x=undef;
undef($x);
=> écrire if(defined($x)) et NON: if ($x!=undef)

# la division avec / est une division réelle: 2/3 => 0.666...
int($x/$y) # fait une division entiere

length()
chop($x) supprime et renvoie son dernier caratère 
chomp($x) supprime son dernier caractère si c une fin de ligne
reverse(), index(), rindex()

substr($v,5,1) = "ation à ";
$v => "salutation à toi"

# pas de booleens, valeurs scalaires fausses sont:
- 0
- "0" ou 'O'
- "" ou ''
- undef

égalité		==	eq
différence	!=	ne
infériorité	<	lt
supériorité	>	gt
inf ou égal	<=	le
sup ou égal	>=	ge
comparaison	<=>	cmp
# cmp => comparaison selon la table ASCII

# toujours entourer les if par des accolades

# print "\$s undefined\n" unless (defined($s)) equivalent à if (!defined($s))

# for, while, until
last, next, redo

# listes 
(2,'age',"Bonjour $prenom")
() # liste vide
(1..10, "${insect}man", 'a'..'z', $debut..$fin)
@t = ("nom",12);
(1,2,@t,"aaa",-1) <=> (1,2,("nom",12),"aaa",-1) <=> (1,2,"nom",12,"aaa",-1) # applatissement ou linéarisation
(2,10) x 3 => (2,10,2,10,2,10)
($a,@t) = @s; # $a reçoit le 1er element, et @t absorbe tous les autres
($a,@t,@u,$b) = @s; # idem sauf que @u = () et $b = undef

# tableaux
my @t = (2,'age',"Bonjour $prenom")
$t[-1] = "Salut $pseudo"; # modif du dernier element, -2 pour l'avant dernier, etc
$t[$#t] # idem car $#t est l'indice du dernier element
$t[3] = 4; # ajout d'un 4e element
scalar(@t) # retourne le nombre d'éléments
$x = @t;  # idem $x contient la taille du tableau
if (exists( $t[100])) # vaut faux si ya pas d'element à cet indice
if (defined($t[100])) # vaut faux si l'element existe et vaut undef ou l'element n'existe pas
$t[10] = "blah"; # tous les elements entre valent undef et scalar(@t) vaut 11

@ARGV # ne contient que les arguments
$0    # contient le nom du programme

@t = @s; # copie de tableau, @t perd ses anciennes valeurs meme s'il était plus grand que @s
($a,$b) = (1,2,3); => (1,2)
($a,$b) = (1); => (1,undef)
($a,$b) = ($b,$a);

my ($a,$b); # declarer plusieurs variables comme en C avec: int a,b;

foreach my $v (@t) { ... }
foreach (@t) { print "$_\n"; }

unshift(@t,5,6); # ajout en debut de tableau
$v = shift(@t);  # supprime et renvoie le 1er element
push(@t,5,6); # ajout en fin de tableau
$v = pop(@t); # supprimer et renvoie le dernier element
@s = reverse(@t);

@t = qw(un deux trois); # ou qw/un deux trois/;

my ($arg1,$arg2) = @_; # 1ere ligne dans une fonction: recuperation des arguments 
my $x = shift; # dans une fonction, ça agit sur @_ par defaut
return ($ret1,$ret2); # une fonction peut retourner une liste

$s = join(", ", 1,2,3); # $s = "1, 2, 3";
@t = split(/, /,"1, 2, 3"); # @t = (1,2,3);
@t = (1,2,3); @s = split(/, /, join(", ",@t)); # @s = @t;

@s = sort( {$a <=> $b or $a cmp $b} @t ); # '8 navets' < '12 carottes' < '12 navets'

@s = grep { $_<0 } $x,@t; # @s reçoit les éléments négatifs
@s = grep { mafonction($_ } @t;
# NB. la liste sera modifiée si j'affecte une valeur à $_

@s = map( {-$_ } @t); # reçoit les opposés
map( { $_*=2 } @t); # tous les éléments de @t sont multipliés par 2
# NB. la valeur de la dernière expression du bloc sera placée ans la liste résultat


#
# expressions rationnelles (pattern matching: correspondance de motif)
# 
\ | ( ) [ ] { } ^ $ * + ? . # caractères spéciaux despécifier avec \

# . matche tout sauf \n
# matcher deux occurences d'un mot
m/(\w+).*\1/

# regroupement non mémorisant
(?:motif)

# en contexte scalaire m// retourne vrai ou faux
if( $w =~ m/motif/ ) # on parle de correspondance

# en contexte de liste m// retourne une liste 
if( ($x,$y) = ($v =~ m/^(foo).*(bar)$/) ) # on parle d'extraction

# separateur
la plupart des caractères sont utilisables, la lettre m n'est pas obligatoire si le séparateur est /

# en correspondance, option g permet de poursuivre la recherche en partant du dernier motif trouvé
my $v = "aatobbtbvvtczz";
while ($v =~ m/t./g) { print "$&\n"; } => to tb tc

# option e
$s =~ s/(\d+)/fonction($1)/e;
$s =~ s/0x[0-9a-f]+)/hex($1)/gei;

# par defaut
$s = "mot\nlu";
$s =~ m/mot$/ est faux
# options s (singleline)
$s =~ m/mot$/s est faux
$s =~ m/t.lu$/s est vrai
# option m (multiline)
$s =~ m/mot$/m est vrai
$s =~ m/t.lu$/m est faux

# quantificateurs non-groumands: ajouter ?
@l = ($m =~ m/'.*?'/g) # retourne tous les mots entre ''

# reference arriere
m/(.*) (?:et )+(.*) avec \1 \2/ # references arrieres qui matchera 'ab et bc avec ab bc'

# variables speciales
$& # vaut toute la sous-chaîne matchant,
$` # vaut toute la sous-chaîne qui précède la sous-chaîne matchant,
$' # vaut toute la sous-chaîne qui suit la sous-chaîne matchant. 


# pour placer une variable utilisateur dans un motif ou un remplacement, il FAUT utiliser quotemeta()

# tr
$s = "azerty";
$s =~ tr/abcde/01234/;
print "$s\n";  # affiche 0z4rty


#
# fichiers
#
perldoc -f -X # operateurs
if( -f $file && -w $file ) { ... }
my $file_size = -s $file_path;

@l = glob ('/usr/include/*.h'); 
foreach my $name ( <.*>, <*> ) {
	next if (! -d $name); print "$name : ". (-s $name) ."\n"; 
}

open(FIC, ">>data.txt") or die("open: $!"); # toujours tester si l'ouverture a reussi
while (<FIC>) { print "$. : $_"; } # numerote chaque ligne du fichier

while( defined( $line = <FILE> ) )
printf( FIC "%03d", $i ); # pas de virgule apres le descripteur
close( FIC );

$l = <FIC>; # en contexte scalaire, renvoie la prochaine ligne disponible
@t = <FIC>; # en contexte de liste, renvoie la liste des toutes les lignes restantes 

# descripteurs ouverts au lancement du pg:
STDIN, STDOUT, STDERR, ARGV 
<ARGV> ou <> # les lignes lues sont celles des fichiers de la ligne de commande
$ARGV contient le nom du fichier en cours de lecture

$c = getc(FIC);
$tailleLue = read(FIC, $tampon, $taillALire); # données placées dans $tampon
sysopen, sysread, syswrite et close # bas niveau

open(FIC1,"ls $ref |");    # FIC1 contient ce qu'a affiché la commande
open(FIC2,"|mail robert"); # FIC2 contient le mail

# fichiers DBM
my %h;
dbmopen(%h,"data",0644) or die($!);
$h{'prenom'} = 'Larry';
dbmclose(%h) or die($!);

my %h;
dbmopen(%h,"data",0644) or die($!);
print "$h{'prenom'}\n";
dbmclose(%h) or die($!);

#
# tables de hachage
#
my %h = ();
my %h = ( "Paul"     => "01.23.45.67.89",
          "Virginie" => "06.06.06.06.06",
	  "Pierre"   => "heu ..." );

sub f { return "Jac"; }
$h{f().'ques'} = "02.02.02.02.02";

foreach my $k (keys(%h)) { print "Clef=$k Valeur=$h{$k}\n"; }
foreach my $v (values(%h)) {...}
while( my ($k,$v) = each(%h) ) {...}

delete( $h{hello} ) if (exists($h{hello})); # attention $h{hello} = undef; ne supprime pas la clef

if( %h eq 0 ) { print "%h est vide\n"; }

$h{hello} .= "après";
$h{bye}++; # crée un élément de valeur 1 si la table ne comportait pas de clef bye

my @t = ("Paul", "01.23.45.67.89", "Virginie", "06.06.06.06.06", "Pierre", "heu ...");
my %h = @t;
# et retour à la case départ avec: my @t2 = %h;

foreach my $x (%h) { print "$x\n"; } # affiche la table comme une liste
%h = reverse(%h); # les valeurs deviennent les clefs

%ENV # variable contenenant l'env

$h{"$i:$j:$k"} = Calcul($i,$j,$k); # table de hash permettent d'avoir des tableaux à plusieurs dimensions


# 
# tranches
#
@t[4,10] = (4321,"age"); # equivaut à: ($t[4],$t[10]) = (4321,"age");

($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat($filename);
($mtime,$ctime) = ( stat($filename) )[9,10];

@h{'clef1','clef2'} # equivaut à: ($h{'clef1'},$h{'clef2'})

# liste de valeurs uniques à partir d'un tableau dont on n'est pas sûr que ses valeurs soient uniques:
my @t = qw(hello toto hello vous);
my %h;
@h{@t} = ();
@t = keys %h;


#
# modules
#
$ perl -V # @INC: liste des répertoires où seront recherchés les modules.
perldoc File::Copy
perl -e 'use Net::SMTP' # verifier qu'un module est dispo sur le système

#
# references
# 

# sur scalaire
$v = -43.5;
my $refv  = \$v; # \$v est la référence de la variable $v
print "$refv\n";   # affiche SCALAR(0x80ff4f0)
print "$$refv\n";  # affiche -43.5
$$refv = 56; 
print "$v\n";      # affiche 56

# sur fonction
f( \$v );
sub f
{
   my ($ref) = @_;
   $$ref = 0;
}
# et
my $reff = f2();
sub f2
{
   my $w = 43;
    return \$w;
}

# sur tableau
my @t = (23, "ab", -54.4);
my $reft  = \@t;
my @t2 = @$reft;
@$reft = (654.7, -9, "bonjour");
$reft->[1] = "coucou"; # plus lisible que $$reft[1]
my @t = ( 6, \@t1, \@t2, "s" ); # tableau de tableau, puis $t[2][1] ou avec une reference $r->[2]->[1]

# sur table de hachage
my $refh = \%h;
my %h2 = %$refh;
$refh->{Jacques} = 33;

# sur fichiers
my $refo = \*STDOUT;

# sur fonctions
my $ref = \&affcoucou;
&$ref("Larry"); ou $ref->("Larry");

# ajouter 1 à une reference ne vas pas faire pointer sur l'element d'indice +1 mais faire perdre le caractere reference à la variable

# reference anonyme
my $ref2 = \"er"; # mais $$ref2 = "blah"; lèvera une erreur
my $r = [ 34.4, "ac", -71 ]; # vers tableau
my $r = { 'Paul' => 21, 'Julie' => "e" };

# operateur ref() permet de connaitre le type d'une reference
# afficher la structure d'une variable
use Data::Dumper;
print Dumper($r);

# reference circulaire
c'est possible, mais attention le garbage-collector ne liberera pas la memoire si on ne casse pas la circularité:
$r->[1] = undef;
$r = undef;

# cpan
Config.pm: 'makepl_arg' => q[PREFIX=~/perl5lib/ LIB=~/perl5lib/lib INSTALLMAN1DIR=~/perl5lib/man1 INSTALLMAN3DIR=~/perl5lib/man3], # definir le repertoire dans lequel les modules seront installés
export PERL5LIB=~/perl5lib/lib # ajoute le repertoire à mon @INC au runtime
