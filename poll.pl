#!/usr/bin/perl

#/usr/local/bin/perl

require "subs.pl";

print "Content-type: text/html\n\n";

&GetInput;

if(!&HasHeBeenHere) {
	if ($action eq "") { $action = "questions"; }
	
	if ($action eq "questions") {
		open(FILE, "questions.dat") || print "ERROR: Can't open questions file";
			@questions = <FILE>;
		close(FILE);
		
		print "<form method=post action=poll.pl>\n";
		print "<input name=action type=hidden value='Vote'>\n";
		
		&DoTable;
	
		print "</form>";
		
	}
	
	
	if ($action eq "Vote") {
	
		&TagIP;
		&Vote;
		&ShowResults;
	}
} else {
	&ShowResults;
}