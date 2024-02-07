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
my $password = $cgi->param('currentPassword');
my $number_cuenta = $cgi->param('number_cuenta'); 

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $passwor);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $query_tarjeta = "SELECT id FROM tarjetas WHERE clave = ?";
my $sth_tarjeta = $dbh->prepare($query_tarjeta);
$sth_tarjeta->execute($password);
my $tarjeta_id;

if (my $result_tarjeta = $sth_tarjeta->fetchrow_arrayref()) {
    $tarjeta_id = $result_tarjeta->[0];
}

$sth_tarjeta->finish(); 

my $sth_cuenta = $dbh->prepare("SELECT tarjeta_id FROM cuentas WHERE numero = ?");
$sth_cuenta->execute($number_cuenta);

my $tarjetaid;

if (my $result_cuenta = $sth_cuenta->fetchrow_arrayref()) {
    $tarjetaid = $result_cuenta->[0];
}

$sth_cuenta->finish(); 

if ($tarjeta_id == $tarjetaid) {
    print "Content-type: application/json\n\n";
    print '{"isCorrect": true}';
} else {
    print "Content-type: application/json\n\n";
    print '{"isCorrect": false}';
}
$dbh->disconnect();

