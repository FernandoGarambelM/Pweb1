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
my $passwor = ''; 

my $cgi = CGI->new;

my $num_tarjeta = int(rand(9000000000000000)) + 1000000000000000;

my $creationDate = $cgi->param('creationDate');
my $dueDate      = $cgi->param('dueDate');
my $password     = $cgi->param('password');

my $id_user = $cgi->param('user_id');
my $dni_cliente = $cgi->param('dni');


my $q = CGI->new;   
print $q->header('text/html');
print<<BLOCK;
<!DOCTYPE html>
<html>
 <head>
 <meta charset="utf-8">
 <link rel="stylesheet" type="text/css" href="../htdocs/stateStyles.css">
 <title>Búsquedas bibliográficas de Programación Web 1 </title>
 </head>
<body>
BLOCK


my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $passwor);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $insert_query = "INSERT INTO tarjetas (numero, clave, creado, vencimiento) VALUES (?, ?, ?, ?)";
my $insert_sth = $dbh->prepare($insert_query);
$insert_sth->execute($num_tarjeta, $password, $creationDate, $dueDate);

if ($insert_sth->errstr) {
    die "Error al insertar en la base de datos: " . $insert_sth->errstr;
}

$dbh->disconnect();

print<<BLOCK;
        <h1>Registro exitoso</h1>
        <div class>
            <p1>Numero de tarjeta: $num_tarjeta </p1><br>
            <p1>Clave: $password </p1><br>
            <p1>Fecha de creacion: $creationDate </p1><br>
            <p1>fecha de vencimiento: $dueDate</p1><br>
        </div>
        <a href="../cuenta.html?dni=$dni_cliente&usuario_id=$id_user&num_tarjeta=$num_tarjeta">Regresar</a>
       
BLOCK
#se pasa a cuenta con el parametro del dni para determinar al cliente y el usuario id para determinar al usuario!
