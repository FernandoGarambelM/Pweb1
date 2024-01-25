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
my $passwor = ''; 

my $cgi = CGI->new;

my $num_tarjeta = int(rand(9000000000000000)) + 1000000000000000;

my $creationDate = $cgi->param('creationDate');
my $dueDate      = $cgi->param('dueDate');
my $password     = $cgi->param('password');

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $passwor);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $insert_query = "INSERT INTO tarjetas (numero, clave, creado, vencimiento) VALUES (?, ?, ?, ?)";
my $insert_sth = $dbh->prepare($insert_query);
$insert_sth->execute($num_tarjeta, $password, $creationDate, $dueDate);

if ($insert_sth->errstr) {
    die "Error al insertar en la base de datos: " . $insert_sth->errstr;
}

$dbh->disconnect();
