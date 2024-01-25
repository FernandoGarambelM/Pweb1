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

my $nombres    = $cgi->param('nombres');
my $apellidos  = $cgi->param('apellidos');
my $dni        = $cgi->param('dni');
my $celular    = $cgi->param('celular');
my $correo     = $cgi->param('correo');
my $id_user    = $cgi->param('id_user');
my $nacimiento = $cgi->param('nacimiento');
my $genero     = $cgi->param('genero');

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $passwor);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $cliente_insert = $dbh->prepare("INSERT INTO clientes (dni, nombres, paterno, nacimiento, usuario_id) VALUES (?, ?, ?, ?, ?)");
$cliente_insert->execute($dni, $nombres, $apellidos, $nacimiento, $id_user);

$dbh->disconnect;

print $cgi->redirect('../confirmacion.html');
