#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

my $dsn      = "DBI:mysql:database=proyecto_pweb1;host=localhost";
my $username = "root";
my $password = "";
my $dbh      = DBI->connect($dsn, $username, $password, { RaiseError => 1, PrintError => 0 });

my $cgi = CGI->new;

my $nombres    = $cgi->param('nombres');
my $apellidos  = $cgi->param('apellidos');
my $dni        = $cgi->param('dni');
my $celular    = $cgi->param('celular');
my $correo     = $cgi->param('correo');
my $contraseña = $cgi->param('contraseña');
my $nacimiento = $cgi->param('nacimiento');
my $genero     = $cgi->param('genero');

my $cliente_insert = $dbh->prepare("INSERT INTO cliente (dni, nombres, apellido, nacimiento) VALUES (?, ?, ?, ?)");
$cliente_insert->execute($dni, $nombres, $apellidos, $nacimiento);

my $usuario_insert = $dbh->prepare("INSERT INTO usuario (usuario, clave) VALUES (?, ?)");
$usuario_insert->execute($correo, $contraseña);

$dbh->disconnect;

print $cgi->redirect('confirmacion.html');
