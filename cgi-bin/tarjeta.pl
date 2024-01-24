#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;

my $database = 'proyecto_pweb1';
my $host     = 'localhost';
my $port     = '3306'; 
my $user     = 'root';
my $password = '';

my $cgi = CGI->new;
my $creationDate = $cgi->param('creationDate');
my $dueDate = $cgi->param('dueDate');
my $password = $cgi->param('password');

my $num_tarjeta = int(rand(9000000000000000)) + 1000000000000000;
#print "El numero es: $num_tarjeta";

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $password);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $query = "SELECT * FROM tarjetas WHERE numero= ? AND clave = ? AND creado = ? AND vencimiento = ?";
my $sth = $dbh->prepare($query);
$sth->execute($num_tarjeta, $password, $creationDate, $dueDate);

#Para poner el estado y sellado de la tarjeta podría ponerse como default el valor true desde la misma
#base de datos

$dbh->disconnect();
