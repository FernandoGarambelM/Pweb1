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

# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, { RaiseError => 1 });

if (!$dbh) {
    mostrar_mensaje("Error al conectar a la base de datos: $DBI::errstr");
    exit;
}

# Generar el número de cuenta
my $numero = int(rand(9000000000000000)) + 1000000000000000;

# Verificar si el cliente ya tiene una cuenta con el mismo número
my $verificacion_numero = $dbh->prepare("SELECT id FROM cuentas WHERE numero = ?");
$verificacion_numero->execute($numero);

if ($verificacion_numero->fetchrow_array) {
    mostrar_mensaje("El número de cuenta $numero ya está registrado.");
    $dbh->disconnect;
    exit;
}
# Verificar si el cliente ya tiene una cuenta
my $verificacion_cuenta = $dbh->prepare("SELECT id FROM cuentas WHERE cliente_id = ?");
$verificacion_cuenta->execute($titular);
if ($verificacion_cuenta->fetchrow_array) {
    mostrar_mensaje("El cliente con ID $titular ya tiene una cuenta.");
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
$cuenta_insert->execute($numero, $tipoMoneda, 1, $titular, $usuario);

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
            window.history.back();
        };
    </script>
</head>
<body></body>
</html>
EOF
    exit;
}
