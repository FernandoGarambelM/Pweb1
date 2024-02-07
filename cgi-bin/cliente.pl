#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use DBI;
use DateTime;
use CGI::Carp qw(croak fatalsToBrowser);
my $cgi = CGI->new;

my $servername = "localhost";
my $username   = "root";
my $password   = "";
my $database   = "proyecto_pweb1";

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$servername", $username, $password, { RaiseError => 1, PrintError => 0 });

if (!$dbh) {
    die("Connection failed: " . $DBI::errstr);
}


my $nombres     = $cgi->param('nombres');
my $paterno     = $cgi->param('a_paterno');
my $materno     = $cgi->param('a_materno');
my $dni         = $cgi->param('dni');
my $nacimiento  = $cgi->param('nacimiento');
my $creado      = DateTime->now->ymd;
my $estado      = 1;
my $usuario_id     = $cgi->param('usuario');

my $insert_query = "INSERT INTO clientes (nombres, paterno, materno, dni, nacimiento, creado, estado, usuario_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
my $insert_sth   = $dbh->prepare($insert_query);

$insert_sth->execute($nombres, $paterno, $materno, $dni, $nacimiento, $creado, $estado, $usuario_id);

if ($DBI::errstr) {
    die("Error al insertar en la base de datos: " . $DBI::errstr);
}

$dbh->disconnect();

print $cgi->redirect("../tarjetas.html?dni=$dni&usuario_id=$usuario_id");
