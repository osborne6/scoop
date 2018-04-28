#!/usr/bin/perl
use strict;
use DBI;

if ($ARGV[0] =~ /^--?h/) {
	print "usage: fix_urls.pl user pass database\n";
	exit;
}

my $db_user = $ARGV[0] || 'nobody';
my $db_host = 'localhost';
my $db_pass = $ARGV[1] || '';
my $db_port = 3306;
my $db_name = $ARGV[2] || 'scoop';

my %checksums = (
	user_box           => [ 'a4e91983b55f83ee88bc8933f56f9018', 'box'   ],
	menu_footer        => [ 'd3dc9c6158dda84c2df3056122090410', 'box'   ],
	older_list_box     => [ '098a2a9f909ddd770a16d8d2b34055a9', 'box'   ],
	admin_tools        => [ '96e05a9552d22b558c2048b352a7095b', 'box'   ],
	main_menu          => [ '8c9d61466809f03e14d6ccfb1eece849', 'box'   ],
	poll_box           => [ '90bf60c573d6f2e9cc0dcab4cc1e0b3f', 'box'   ],
	comment            => [ '16b74b2075b9fe54bb04e176139f2a3d', 'block' ],
	moderation_comment => [ '6570cded66f022d45fbbaae008f7ce90', 'block' ],
	scoop_intro        => [ 'a9886a9553823ea18abd69ce1126c5ac', 'block' ]
);

my $dsn = "DBI:mysql:database=$db_name:host=$db_host:port=$db_port";
my $dbh = DBI->connect($dsn, $db_user, $db_pass);

$| = 1;     # turn buffering off

print "Scanning DB for changes...";
my %no_update;

my $box_query = "SELECT md5(content) FROM box WHERE boxid = ?";
my $block_query = "SELECT md5(block) FROM blocks WHERE bid = ?";

my $box_sth = $dbh->prepare($box_query);
my $block_sth = $dbh->prepare($block_query);

while (my($k, $v) = each %checksums) {
	my $sth = ($v->[1] eq 'box') ? $box_sth : $block_sth;
	$sth->execute($k);
	my ($sum) = $sth->fetchrow_array;
	if ($sum ne $v->[0]) {
		$no_update{$k} = $v->[1];
	}
}

$box_sth->finish;
$block_sth->finish;
print "done\n";

print "Loading SQL statements and making changes...\n";
while (my $l = <DATA>) {
	chomp($l);
	next unless $l;
	my ($b, $data) = split(/=/, $l, 2);
	unless ($no_update{$b}) {
		print "updating $checksums{$b}->[1] $b\n";
		$dbh->do($data);
	}
}
print "done\n\n";

$dbh->disconnect;

print "Finished updating all unchanged boxes and blocks. For the rest, you'll
need to manually edit them. Also, if you've written any other boxes or blocks
with links to others parts of scoop in them, you'll probably want to check them
for &'s instead of ;'s in the URL. The following were not updated because they
have been changed:\n\n";

while (my($name, $type) = each %no_update) {
	print "$type $name\n";
}

__DATA__
user_box=UPDATE box SET content = 'my $content;

menu_footer=UPDATE box SET content = 'my $submit = \'\';

older_list_box=UPDATE box SET content = 'my $section = $S->{CGI}->param(\'section\') || \'front\';

admin_tools=UPDATE box SET content = 'my $content;

main_menu=UPDATE box SET content = 'my $submit = \'\';

poll_box=UPDATE box SET content = 'my $pollqid = shift @ARGS;

comment=UPDATE blocks SET block = '<!-- start comment -->

moderation_comment=UPDATE blocks SET block = '<!-- start comment -->

scoop_intro=UPDATE blocks SET block = '<TABLE WIDTH="100%" BORDER=1 CELLPADDING=2 CELLSPACING=0>