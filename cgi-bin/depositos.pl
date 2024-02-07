#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;


#Este CGI se encargará solamente de hacer depositos que los hace los mismos
#trabajadores o usuarios del banco

my $database = 'proyecto_pweb1';
my $host     = 'localhost';
my $port     = '3306'; 
my $user     = 'root';
my $password = '';


#valores que se usaran
my $cgi = CGI->new;
my $cantidad = $cgi->param('cantidad');
my $clave_tarjeta = $cgi->param("clave_tarjeta");
my $num_tarjeta = $cgi->param("num_tarjeta");


#Para hacer la salidad en formato html
my $q = CGI->new;
my $year = $q->param('year');
print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Informe del depósito</title>
    <link rel='stylesheet' href='../htdocs/movimientos.css'>
    <style>
    body {
        background-image: url('../wallpaper2.jpg');
        background-size: cover;
        background-attachment: fixed;
        background-position: center;
        background-repeat: no-repeat;
    }
    
    h1 {
        text-align: center;
    }

    a {
        text-decoration: none;
    }

    table {
        width: 80%;
        margin: 0 auto; 
        border-collapse: collapse; 
        margin-bottom: 2rem;
    }
    td {
        background-color: black;
        color: wheat;
    }
    th, td {
        padding: 10px; 
        border: 1px solid #ddd; 
        text-align: left; 
    }

    th {
        background-color: wheat; 
        text-align: center;
    }

    td:hover {
        background-color: #4b1717; 
    }

    .dirigir{
        background-color: rgb(65, 6, 6);
        display: flex;
        padding: 10px;
        width: 7%;
        justify-content: center;
        margin: 0 auto; 
        border-radius: 2rem;
        
    }

    .regresar {
        color: wheat;
    } 

    .dirigir:hover {
        background-color: rgb(11, 11, 103);
        color: wheat
    }

    .error {
        width: 50%;
        display: flex;
        flex-direction: column;
        align-items: center;
        margin: 0 auto;
    }

    </style>
</head>
<body>
BLOCK


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
        print "<div class='error'>";
        print "<div class='mensaje'>";
        print "<h1>Error: Las claves no coinciden, <a href='../htdocs/depositos.html'>intente de nuevo</a>\n";
        print "</div>";
        print "<img src='../htdocs/error.png'>";
        print "</div>";
        exit;
    }
} else {
    print "<div class='error'>";
    print "<div class='mensaje'>";
    print "<h1>Error: No se encontro la tarjeta, <a href='../htdocs/depositos.html'>intente de nuevo</a>\n";
    print "</div>";
    print "<img src='../htdocs/error.png'>";
    print "</div>";
    exit;
}

#Ahora con el id, podremos ingresar a los movimientos para esa tarjeta
$sth = $dbh->prepare("SELECT * FROM movimientos WHERE tarjeta_id = ? ORDER BY tarjeta_id DESC LIMIT 1");
$sth->execute($id_tarjeta);

#Extraemos el monto
my $monto_antiguo; 

if (my $fila = $sth->fetchrow_arrayref) {
    $monto_antiguo = $fila->[3];
} else {
    print "No se encontró";
    exit;
}
my $monto = $monto_antiguo + $cantidad;


#Debemos especificar que cuenta esta haciendo el movimiento, para ello se buscará tarjeta_id y el id 
#de cuenta sera mandado a movimientos
my ($id_cuenta, $cliente_id, $usuario_id);
$sth = $dbh->prepare("SELECT * FROM cuentas WHERE tarjeta_id = ?");
$sth->execute($id_tarjeta);
if (my $fila = $sth->fetchrow_arrayref) {
    $id_cuenta = $fila->[0];
    $cliente_id = $fila->[6];
    $usuario_id = $fila->[7];
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

#Ahora con los datos extraidos, se buscaran otros mas para crear un informe de la transaccion
my ($nombre, $paterno, $materno, $dni);
$sth = $dbh->prepare("SELECT * FROM clientes WHERE id = ?");
$sth->execute($cliente_id);
if (my $fila = $sth->fetchrow_arrayref) {
    $dni = $fila->[1];
    $nombre = $fila->[2];
    $paterno = $fila->[3];
    $materno = $fila->[4];
} else {
    print "No se encontró";
    exit;
}
my $nombre_completo = "$nombre  $paterno  $materno";



my $usuarioBanco;
$sth = $dbh->prepare("SELECT * FROM usuarios WHERE id = ?");
$sth->execute($usuario_id);
if (my $fila = $sth->fetchrow_arrayref) {
    $usuarioBanco = $fila->[1];
} else {
    print "No se encontró";
    exit;
}


#Como se tienen los datos necesarios, se procede a realizar el informe
print<<BLOCK;
        <h1>Informacion del deposito</h1>
        <br><br>
        <table>
            <tr>
                <th>Item</th>
                <th>Descripcion</th>
            </tr>
            <tr>
                <td>Cliente</td>
                <td>$nombre_completo</td>
            </tr>

            <tr>
                <td>DNI</td>
                <td>$dni</td>
            </tr>

            <tr>
                <td>Num. Tarjeta</td>
                <td>$num_tarjeta</td>
            </tr>

            <tr>
                <td>Accion</td>
                <td>Deposito</td>
            </tr>

            <tr>
                <td>Cantidad</td>
                <td>$cantidad</td>
            </tr>

            <tr>
                <td>Nuevo saldo</td>
                <td>$monto</td>
            </tr>

            <tr>
                <td>Usuario</td>
                <td>$usuarioBanco</td>
            </tr>
        </table>

        <div class="dirigir">
            <a class='regresar' href='../admin.html'>Regresar</a>
        </div>
        
</body>
</html>
BLOCK

# Cerrar la conexión.
$sth->finish;
$dbh->disconnect;

