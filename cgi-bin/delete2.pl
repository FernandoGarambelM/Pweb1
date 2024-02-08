#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;
use JSON;

#Solo elimina la cuenta y el cliente

my $db_host     = 'localhost';
my $db_name     = 'proyecto_pweb1';
my $db_user     = 'root';
my $db_password = '';

my $cgi = CGI->new;
my $cliente_id= $cgi->param("cliente_id");
my $cuenta_id= $cgi->param("cuenta_id");


my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, {RaiseError => 1, PrintError => 0});

unless ($dbh) {
    print $cgi->header(-type => 'application/json', -charset => 'utf-8');
    print encode_json({ error => "Error al conectar a la base de datos: $DBI::errstr" });
    exit;
}

my $consulta_id_tarjeta = "SELECT tarjeta_id FROM cuentas WHERE id = ?";
my $sth_id_tarjeta = $dbh->prepare($consulta_id_tarjeta);
$sth_id_tarjeta->execute($cuenta_id);
my ($id_tarjeta) = $sth_id_tarjeta->fetchrow_array;

#borrar todos los movimientos de esa tarjeta
my $delete_query1 = "DELETE FROM movimientos WHERE tarjeta_id = ?";
my $sth1 = $dbh->prepare($delete_query1);
$sth1->execute($id_tarjeta);

my $delete_query2 = "DELETE FROM cuentas WHERE id = ?";
my $sth2 = $dbh->prepare($delete_query2);
$sth2->execute($cuenta_id);

my $delete_query3 = "DELETE FROM tarjetas WHERE id = ?";
my $sth3 = $dbh->prepare($delete_query3);
$sth3->execute($id_tarjeta);
print $cgi->header(-type => 'application/json', -charset => 'utf-8');

print encode_json({ success => "Cuenta y tarjeta eliminados correctamente" });
