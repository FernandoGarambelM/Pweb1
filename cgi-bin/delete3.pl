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


my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, {RaiseError => 1, PrintError => 0});

unless ($dbh) {
    print $cgi->header(-type => 'application/json', -charset => 'utf-8');
    print encode_json({ error => "Error al conectar a la base de datos: $DBI::errstr" });
    exit;
}

#Cambiar si un cliente tiene varias cuentas
my $delete_query3 = "DELETE FROM clientes WHERE id = ?";
my $sth3 = $dbh->prepare($delete_query3);
$sth3->execute($cliente_id);


print $cgi->header(-type => 'application/json', -charset => 'utf-8');

# Mensaje de éxito
print encode_json({ success => "Cliente y cuenta eliminados correctamente" });
