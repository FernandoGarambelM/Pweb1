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

my $number_cuenta = $cgi->param('number_cuenta');
my $new_password = $cgi->param('new_password');

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $password);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $sth_cuenta = $dbh->prepare("SELECT tarjeta_id FROM cuentas WHERE numero = ?");
$sth_cuenta->execute($number_cuenta);

my $tarjetaid;

if (my $result_cuenta = $sth_cuenta->fetchrow_arrayref()) {
    $tarjetaid = $result_cuenta->[0];
}

$sth_cuenta->finish(); 

my $sth_tarjeta = $dbh->prepare("UPDATE tarjetas SET clave = ? WHERE id = ?");
$sth_tarjeta->execute($new_password, $tarjetaid);

$sth_tarjeta->finish(); 

my $filas_afectadas = $sth_tarjeta->rows;

if ($filas_afectadas > 0) {
    print "Content-type: application/json\n\n";
    print '{"isCorrect": true}';
} else {
    print "Content-type: application/json\n\n";
    print '{"isCorrect": false}';
}
$dbh->disconnect();