#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;


my $db_host     = 'localhost';
my $db_name     = 'proyecto_pweb1';
my $db_user     = 'root';
my $db_password = '';

my $cgi = CGI->new;

my $numeroCuenta   = $cgi->param('numero_cuenta');
my $tipoMoneda     = $cgi->param('tipo_moneda');
my $numeroTarjeta  = $cgi->param('num_tarjeta');
my $titular        = $cgi->param('id_titular');
my $usuario        = $cgi->param('id_usuario');
my $fechacreacion = $cgi->param('creationDate');

# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password);

if ($dbh) {
    print "Content-type: text/html\n\n";
    print "Conexión a la base de datos exitosa.<br>";
} else {
    print "Content-type: text/html\n\n";
    print "Error al conectar a la base de datos: $DBI::errstr";
    exit;
}
my $cuenta_insert = $dbh->prepare("INSERT INTO cuentas (numero, creado, estado, moneda, tarjeta_id, cliente_id, usuario_id) VALUES (?, ?, ?, ?, ?, ?)");

$cuenta_insert->execute($numeroCuenta, $fechacreacion, 1, $tipoMoneda, $numeroTarjeta, $titular, $usuario);


$dbh->disconnect;

