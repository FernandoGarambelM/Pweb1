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
my $username = $cgi->param('user');
my $password = $cgi->param('password');

my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", $user, $passwor);


unless ($dbh) {
    die "Error de conexión: " . $DBI::errstr;
}

my $query = "SELECT * FROM usuarios WHERE usuario= ? AND clave = ?";
my $sth = $dbh->prepare($query);
$sth->execute($username, $password);

if (my $row = $sth->fetchrow_hashref) {
    my $id = $row->{'id'}; 
    my $name = $row->{'usuario'}; 

    print "Content-type: application/json\n\n";
    print '{"isUser": true, "idUser": "' . $id . '", "nameUser": "' . $name . '"}';

} else {
    print "Content-type: application/json\n\n";
    print '{"isUser": false}';
}
$dbh->disconnect();
