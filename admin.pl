#!C:/xampp/perl/bin/perl.exe
use strict;
use warnings;
use CGI;
use CGI::Carp qw(croak fatalsToBrowser);
use Encode;
use DBI;
use JSON;

my $db_host     = 'localhost';
my $db_name     = 'proyecto_pweb1';
my $db_user     = 'root';
my $db_password = '';


my $cgi = CGI->new;
my $user_id = $cgi->param("user_id"); 

my $dbh = DBI->connect("DBI:mysql:database=$db_name;host=$db_host", $db_user, $db_password, {RaiseError => 1, PrintError => 0});

unless ($dbh) {
    print $cgi->header(-type => 'application/json', -charset => 'utf-8');
    print encode_json({ error => "Error al conectar a la base de datos: $DBI::errstr" });
    exit;
}

my $movimientos_query = "SELECT * FROM clientes WHERE usuario_id = ?";
my $sth = $dbh->prepare($movimientos_query);
$sth->execute($user_id);

my @usuarios;
while (my $row = $sth->fetchrow_hashref) {
    push @usuarios, $row;
}

$dbh->disconnect;

print $cgi->header(-type => 'application/json', -charset => 'utf-8');
print encode_json(\@usuarios);
