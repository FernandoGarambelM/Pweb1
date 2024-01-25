#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;

my $dsn      = "DBI:mysql:database=proyecto_pweb1;host=localhost";
my $username = "root";
my $password = "";
my $dbh      = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0 });

my $cgi = CGI->new;

my $numeroCuenta   = $cgi->param('numero_cuenta');
my $tipoMoneda     = $cgi->param('tipo_moneda');
my $numeroTarjeta  = $cgi->param('num_tarjeta');
my $titular        = $cgi->param('id_titular');
my $usuario        = $cgi->param('id_usuario');
my $correo         = $cgi->param('correo');


my $cuenta_insert = $dbh->prepare("INSERT INTO `cuentas` (numero, moneda, tarjeta_id, cliente_id, usuario_id) VALUES (?, ?, ?, ?, ?)");


$cuenta_insert->execute($numeroCuenta, $tipoMoneda, $numeroTarjeta, $titular, $usuario);


$dbh->disconnect;

