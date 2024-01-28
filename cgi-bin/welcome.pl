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

my $numero = $cgi->param('numero') || 4557880159472848;
my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $password);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

# Seleccionar la tarjeta
my $query_tarjeta = "SELECT id FROM tarjetas WHERE numero = ?";
my $sth_tarjeta = $dbh->prepare($query_tarjeta);
$sth_tarjeta->execute($numero);

my $tarjeta_id;

# Verificar si se encontró una tarjeta con el número proporcionado
if (my $result_tarjeta = $sth_tarjeta->fetchrow_arrayref()) {
    $tarjeta_id = $result_tarjeta->[0];
}

$sth_tarjeta->finish(); 

# Seleccionar el cliente_id asociado a la tarjeta
my $sth_cuenta = $dbh->prepare("SELECT cliente_id FROM cuentas WHERE tarjeta_id = ?");
$sth_cuenta->execute($tarjeta_id);

my $cliente_id;

# Verificar si se encontró un cliente asociado a la tarjeta
if (my $result_cuenta = $sth_cuenta->fetchrow_arrayref()) {
    $cliente_id = $result_cuenta->[0];
}

$sth_cuenta->finish(); 


# Seleccionar los datos del cliente
my $sth_cliente = $dbh->prepare("SELECT nombres, paterno, creado FROM clientes WHERE id = ?");
$sth_cliente->execute($cliente_id);

my ($nombres, $paterno, $creado);

# Verificar si se encontraron datos del cliente
if (my $result_cliente = $sth_cliente->fetchrow_arrayref()) {
    ($nombres, $paterno, $creado) = @{$result_cliente};
}
$sth_cliente->finish();  # Liberar recursos

# Configurar la respuesta como JSON
print $cgi->header(-type => 'application/json');
# Verificar si se encontraron datos del cliente antes de imprimir la respuesta JSON
if (defined $nombres && defined $paterno && defined $creado) {
    my $response = {
        nombres => $nombres,
        paterno => $paterno,
        creado  => $creado,
    };

    print to_json($response);
} else {
    print to_json({ error => "No se encontraron datos válidos para el número" });
}

$dbh->disconnect();