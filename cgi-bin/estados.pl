#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;
use JSON;

my $db_host     = 'localhost';
my $db_name     = 'proyecto_pweb1';
my $db_user     = 'root';
my $db_password = '';


my $cgi = CGI->new;
my $tarjeta_id = $cgi->param("tarjeta_id"); #no se porque no funciona!!

my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, {RaiseError => 1, PrintError => 0});

unless ($dbh) {
    print $cgi->header(-type => 'application/json', -charset => 'utf-8');
    print encode_json({ error => "Error al conectar a la base de datos: $DBI::errstr" });
    exit;
}

# Consultar movimientos en la base de datos
my $movimientos_query = "SELECT * FROM movimientos WHERE tarjeta_id = ?";
my $sth = $dbh->prepare($movimientos_query);
$sth->execute($tarjeta_id);

my @movimientos;
while (my $row = $sth->fetchrow_hashref) {
    push @movimientos, $row;
}

$dbh->disconnect;

# Imprimir resultados como JSON
print $cgi->header(-type => 'application/json', -charset => 'utf-8');
print encode_json(\@movimientos);
