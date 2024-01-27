#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;


#Este CGI se encargará solamente de hacer depositos que los hace los mismos
#trabajadores del banco

my $database = 'proyecto_pweb1';
my $host     = 'localhost';
my $port     = '3306'; 
my $user     = 'root';
my $password = '';


#valores que se usaran
my $cgi = CGI->new;
my $cantidad = $cgi->param('cantidad') || 50;
my $clave_tarjeta = $cgi->param("clave_tarjeta") || 123456;
my $num_tarjeta = $cgi->param("num_tarjeta") || 4557880159472848;




# Conexión a la base de datos
my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $password, {RaiseError => 1, PrintError => 0});

#Necesitamos buscar el numero de tarjeta (valor único) y una vez extraida, verificar si
#la clave ingresada es correcta

my $sth = $dbh->prepare("SELECT * FROM tarjetas WHERE numero = ?");
$sth->execute($num_tarjeta);

my $tem_clave;
my $id_tarjeta; #Para poder ingresar a los movimientos 

if (my $fila = $sth->fetchrow_arrayref) {
    my $tem_clave = $fila->[2];  
    if ($clave_tarjeta == $tem_clave) {
        $id_tarjeta = $fila->[0];
    } else {
        # Las claves no coinciden, salir del CGI, ya le agregan el formato adecuado para
        #que se muestre en la página
        print "Content-type: text/plain\n\n";
        print "Error: Las claves no coinciden. Saliendo del CGI.\n";
        exit;
    }
} else {
    # No se encontró una tarjeta con el número proporcionado, salir del CGI
    print "Content-type: text/plain\n\n";
    print "Error: Número de tarjeta no válido. Saliendo del CGI.\n";
    exit;
}

#Ahora con el id, podremos ingresar a los movimientos para esa tarjeta
$sth = $dbh->prepare("SELECT * FROM movimientos WHERE tarjeta_id = ? ORDER BY tarjeta_id DESC LIMIT 1");
$sth->execute($id_tarjeta);

#Extraemos el monto
my $monto; 

if (my $fila = $sth->fetchrow_arrayref) {
    $monto = $fila->[3];
} else {
    print "No se encontró";
    exit;
}
$monto = $monto + $cantidad;

#Debemos especificar que cuenta esta haciendo el movimiento, para ella se buscará tarjeta_id y el id 
#de cuenta sera mandado a movimientos
my $id_cuenta;
$sth = $dbh->prepare("SELECT * FROM cuentas WHERE tarjeta_id = ?");
$sth->execute($id_tarjeta);
if (my $fila = $sth->fetchrow_arrayref) {
    $id_cuenta = $fila->[0];
} else {
    print "No se encontró";
    exit;
}

# Ya hemos calculado el monto, ahora debemos agregar el monto a la tabla a manera de
#historial
$sth = $dbh->prepare("INSERT INTO movimientos (tarjeta_id, cuenta_id, monto, tipo) VALUES (?, ?, ?, ?)");
$sth->execute($id_tarjeta, $id_cuenta, $monto, 1);


# Verificar si la actualización fue exitosa

if ($sth->rows > 0) {
    print "Registro satisfactorio";
} else {
    print "No se logró ejecutar la accion";
}

# Cerrar la conexión
$sth->finish;
$dbh->disconnect;
