#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;
use JSON::MaybeXS qw(to_json);

my $database = 'proyecto_pweb1';
my $host     = 'localhost';
my $port     = '3306'; 
my $user     = 'root';
my $password = '';

my $cgi = CGI->new;

my $id_usuario = $cgi->param('idUser') || 1;

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $password);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

# Seleccionar la tarjeta
my $query = "SELECT numero FROM cuentas WHERE usuario_id = ?";
my $sth = $dbh->prepare($query);
$sth->execute($id_usuario);

my @resultados;
while (my $row = $sth->fetchrow_hashref) {
    push @resultados, $row;
}

$dbh->disconnect();

print $cgi->header('application/json');
print to_json(\@resultados);