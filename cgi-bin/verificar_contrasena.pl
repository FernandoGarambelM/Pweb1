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
my $password = $cgi->param('currentPassword');

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $passwor);

unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $query = "SELECT * FROM tarjetas WHERE clave = ?";
my $sth = $dbh->prepare($query);
$sth->execute($password);

if (my $row = $sth->fetchrow_hashref) {
    print "Content-type: application/json\n\n";
    print '{"isCorrect": true}';
} else {
    print "Content-type: application/json\n\n";
    print '{"isCorrect": false}';
}
$dbh->disconnect();

