#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;

my $database = 'proyecto_pweb1';
my $host     = 'localhost';
my $port     = '3306'; 
my $user     = 'root';
my $password = '';

#my $cgi = CGI->new;
#my $accion = $cgi->param('action');
#my $cantidad = $cgi->param("cantidad");
#my $num_tarjeta = $cgi->param("codigo_tarjeta");


my $cgi = CGI->new;
my $accion = "depositar";
my $cantidad = 100;
my $num_tarjeta = 1;
my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $password);



#Se encarga de ver el tipo de operacion, 1 es deposito y -1 es retiro
my $codAccion;
if ($accion eq "depositar") {
    $codAccion = 1;

} elsif ($accion eq "retirar") {
    $codAccion = -1;
}


#Se esta extreyando el saldo de la tarjeta correspondiente
my $sth = $dbh->prepare("SELECT * FROM movimientos WHERE id = ?");
$sth->execute($num_tarjeta);

my $monto;

while (my $fila = $sth->fetchrow_arrayref) {
    $monto = $fila->[3];
}



#Haremos la operacion, ya sea de deposito o retiro
if (1 == $codAccion) {
    $monto = $monto + $cantidad;
} elsif (-1 == $codAccion) {
    $monto = $monto - $cantidad;
}

#Ya hemos calculado el monto, ahora debemos actualizar la tabla de movimientos 
# Ya hemos calculado el monto, ahora debemos actualizar la tabla de movimientos 
my $actualizar = $dbh->prepare("UPDATE movimientos SET monto = ? WHERE id = ?");
$actualizar->execute($monto, $num_tarjeta);


# Verificar si la actualización fue exitosa
if ($actualizar->rows > 0) {
    print "El saldo de la tarjeta $num_tarjeta ha actualizado correctamente.\n";
} else {
    print "No se pudo actualizar el saldo de la tarjeta con ID $num_tarjeta.\n";
}

# Cerrar la conexión
$sth->finish;
$actualizar->finish;
$dbh->disconnect;

