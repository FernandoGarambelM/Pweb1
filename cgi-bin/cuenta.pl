#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;

my $db_host     = 'localhost';
my $db_name     = 'proyecto_pweb1';
my $db_user     = 'root';
my $db_password = '';

my $cgi = CGI->new;

my $tipoMoneda    = $cgi->param('tipo_moneda');
my $titular       = $cgi->param('dni_titular');
my $usuario       = $cgi->param('usuario_id');
my $tarjetaDNI = $cgi->param('num_tarjeta');

# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, { RaiseError => 1 });

if (!$dbh) {
    mostrar_mensaje("Error al conectar a la base de datos: $DBI::errstr");
    exit;
}

# Generar el número de cuenta
my $numero = int(rand(9000000000000000)) + 1000000000000000;

#obtener el id del cliente mediante su dni
my $id_cliente_query = $dbh->prepare("SELECT id FROM clientes WHERE dni = ?");
$id_cliente_query->execute($titular);
my ($id_cliente) = $id_cliente_query->fetchrow_array;

#obtener el id de la tarjeta mediante su numero
my $id_tarjeta_query = $dbh->prepare("SELECT id FROM tarjetas WHERE numero = ?");
$id_tarjeta_query->execute($tarjetaDNI);
my ($id_tarjeta) = $id_tarjeta_query->fetchrow_array;

# Verificar si el cliente ya tiene una cuenta
my $verificacion_cuenta = $dbh->prepare("SELECT id FROM cuentas WHERE cliente_id = ?");
$verificacion_cuenta->execute($id_cliente);
if ($verificacion_cuenta->fetchrow_array) {
    mostrar_mensaje("El cliente con ID $id_cliente ya tiene una cuenta.");
    $dbh->disconnect;
    exit;
}
# Verificar si el usuario existe
my $verificacion_usuario = $dbh->prepare("SELECT id FROM usuarios WHERE id = ?");
$verificacion_usuario->execute($usuario);

if (!$verificacion_usuario->fetchrow_array) {
    mostrar_mensaje("El usuario con ID $usuario no existe.");
    $dbh->disconnect;
    exit;
}


# Realizar la inserción en la tabla 'cuentas'
my $cuenta_insert = $dbh->prepare("INSERT INTO cuentas (numero, moneda, tarjeta_id, cliente_id, usuario_id) VALUES (?, ?, ?, ?, ?)");
$cuenta_insert->execute($numero, $tipoMoneda, $id_tarjeta, $id_cliente, $usuario);

#obtener el id de la cuenta
my $get_id_cuenta = $dbh->prepare("SELECT id FROM cuentas WHERE numero = ?");
$get_id_cuenta->execute($numero);

my $id_cuenta = $get_id_cuenta->fetchrow_array;
if (!$id_cuenta) {
    mostrar_mensaje("Error al obtener el ID de la cuenta recién creada.");
    $dbh->disconnect;
    exit;
}
my $movimiento_insert = $dbh->prepare("INSERT INTO movimientos (tarjeta_id, cuenta_id, monto, tipo) VALUES (?, ?, ?, ?)");
$movimiento_insert->execute($id_tarjeta, $id_cuenta, 0, 1);
mostrar_mensaje("Inserción exitosa en la base de datos.");

$dbh->disconnect;

# Función para mostrar mensajes en una pequeña ventana emergente
sub mostrar_mensaje {
    my ($mensaje) = @_;
    print $cgi->header(-type => "text/html", -charset => "utf-8");
    print <<EOF;
<html>
<head>
    <script>
        window.onload = function() {
            alert('$mensaje');
            window.location.href = '../admin.html';
        };
    </script>
</head>
<body></body>
</html>
EOF
    exit;
}
