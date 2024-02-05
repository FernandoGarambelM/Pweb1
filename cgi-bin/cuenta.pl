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

my $tipoMoneda    = $cgi->param('tipo_moneda');
my $titular       = $cgi->param('id_titular');
my $usuario       = $cgi->param('id_usuario');
my $numero= int(rand(90000000000)) + 10000000000;

# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, { RaiseError => 1 });

if (!$dbh) {
    print "Content-type: text/html\n\n";
    print "Error al conectar a la base de datos: $DBI::errstr";
    exit;
}

# Verificar si el cliente ya tiene una cuenta
my $verificacion_cuenta = $dbh->prepare("SELECT id FROM cuentas WHERE cliente_id = ?");
$verificacion_cuenta->execute($titular);

if ($verificacion_cuenta->fetchrow_array) {
    print "Content-type: text/html\n\n";
    print "El cliente con ID $titular ya tiene una cuenta.";
    $dbh->disconnect;
    exit;
}

# Verificar si la cuenta ya tiene una tarjeta
my $verificacion_tarjeta = $dbh->prepare("SELECT id FROM tarjetas WHERE id IN (SELECT tarjeta_id FROM cuentas WHERE id = ?)");
$verificacion_tarjeta->execute($titular);

if ($verificacion_tarjeta->fetchrow_array) {
    print "Content-type: text/html\n\n";
    print "La cuenta con ID $titular ya tiene una tarjeta asociada.";
    $dbh->disconnect;
    exit;
}

# Realizar la inserción en la tabla 'cuentas'
my $cuenta_insert = $dbh->prepare("INSERT INTO cuentas (numero, moneda, tarjeta_id, cliente_id, usuario_id) VALUES (?, ?, ?, ?, ?)");
$cuenta_insert->execute($numero, $tipoMoneda, 1, $titular, $usuario);

print "Content-type: text/html\n\n";
print "Inserción exitosa en la base de datos.";

$dbh->disconnect;
