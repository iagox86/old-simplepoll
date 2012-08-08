#!/usr/bin/perl

print "Content-type: text/html\n\n";

require "subs.pl";

&GetInput;

if($action eq "changepassword") {
	@settings = &GetSettings;
	$oldpassword = @settings[13];

	chomp($oldpassword);
	#$oldpassword = substr($oldpassword, 0, length($oldpassword)-1);

	if($oldpassword ne $password) {
		print "<font size=+2>ERROR: Incorrect Password";
	} else {

		if($passwordnew eq $newpassword) {
			@settings[13] = $newpassword . "\n";
			open(FILE, ">poll.dat");
			 print FILE join("\n", @settings);
			close(FILE);
			print "Password changed successfully<br><br>";
			$action = "";
		} else {
			print "<font size=+2>ERROR: The Passwords Don't Match!";
		}
	}
}



if($action eq "") {

print "<form action=polladmin.pl method=post>";
print "Username: <input type=textbox name=username><br>";
print "Password: <input type=password name='password'><br>";
print "<input type=hidden name=action value=checkpassword>";
print "<input type=submit value=Submit>";
print "</form><br>";

print "<form action=polladmin.pl method=post>";
print "<table>";
print "<tr><td>Change Password:</td></tr><br>";
print "<tr><td>Username:</td><td> <input type=textbox name=username></td></tr>";
print "<tr><td>Old Password: </td><td><input type=password name='password'></td></tr>";
print "<tr><td>New Password: </td><td><input type=password name='newpassword'></td></tr>";
print "<tr><td>Type Again: </td><td><input type=password name='passwordnew'></td></tr>";
print "<input type=hidden name=action value=changepassword>";
print "<tr><td><input type=submit value=Change it></td></tr><table><br>";
print "<font size=-2>Disclaimer: There is no guarentee that the password you give here will be 100% secure from hackers so please don't use a password that you are using elsewhere, since I am not responsible for the security at your web site.<br>-<a href=mailto:iago\@d2backstab.com>iago</a>";
print "</form>";
} 


if($action eq "erase") {
	&ClearLogs;
	$action = "checkpassword";
}

if($action eq "makechanges") {

	@settings = &GetSettings;

	if($password ne @settings[13]) {
		print "<font size=+2>ERROR: Incorrect Password";
	} else {
		open(FILE, ">poll.dat");
		 print FILE "$bcol\n";
		 print FILE "$fcol\n";
		 print FILE "$border\n";
		 print FILE "$bordercolor\n";
		 print FILE "$bordercolorlight\n";
		 print FILE "$bordercolordark\n";
		 print FILE "$cellpadding\n";
		 print FILE "$cellspacing\n";
		 print FILE "$width\n";
		 print FILE "$size\n";
		 print FILE "$beforetags\n";
		 print FILE "$aftertags\n";
		 print FILE "$barcolor\n";
		 print FILE "$password\n";
		close(FILE);

		open(FILE, ">questions.dat");
		 print FILE "$question\n";
		 print FILE "$answers";
		close(FILE);
	
		$action = "checkpassword";
	}

	
}		

if($action eq "checkpassword") {
	@settings = &GetSettings;

	if($password ne @settings[13]) {
		print "<font size=+2>ERROR: Incorrect Password</font>";
	} else {
		 @settings = GetSettings();
		 @questions = GetQuestions();
		($bgcolor, $color, $border, $bordercolor, $bordercolorlight, $bordercolordark, $cellpadding, $cellspacing, $width, $size, $beforetags, $aftertags, $barcolor) = @settings;

		print "<Form action=polladmin.pl method=post name=form>";
		print "<input type=hidden name=password value=\"$password\">";
		print "<input type=hidden name=action value=makechanges>";
		
		print "For the following options, blank means default<br><br>";
		print "<table border=0>";
		print "<tr><td>Background color (Hex) </td><td> <Input type=text name=bgcolor value=\"$bgcolor\"></td></tr>";
		print "<tr><td>Foreground color (Hex)  </td><td> <Input type=text name=color value=\"$color\"></td></tr>";
		print "<tr><td>Font size  </td><td> <Input type=text name=size value=\"$size\"></td></tr>";
		print "<tr><td>Border width  </td><td> <Input type=text name=border value=\"$border\"></td></tr>";
		print "<tr><td>Border color  </td><td> <Input type=text name=bordercolor value=\"$bordercolor\"></td></tr>";
		print "<tr><td>Border color (light)  </td><td> <Input type=text name=bordercolorlight value=\"$bordercolorlight\"></td></tr>";
		print "<tr><td>Border color (dark)  </td><td> <Input type=text name=bordercolordark value=\"$bordercolordark\"></td></tr>";
		print "<tr><td>Cell padding  </td><td> <Input type=text name=cellpadding value=\"$cellpadding\"></td></tr>";
		print "<tr><td>Cell spacing  </td><td> <Input type=text name=cellspacing value=\"$cellspacing\"></td></tr>";
		print "<tr><td>Table width (##% or just ##)  </td><td> <Input type=text name=width value=\"$width\"></td></tr>";
		print "<tr><td>Tags before title </td><td> <Input type=text name=beforetags value=\"$beforetags\"></td></tr>";
		print "<tr><td>Tags after title </td><td> <Input type=text name=aftertags value=\"$aftertags\"></td></tr>";
		print "<tr><td>Bar Color (on results) </td><td> <Input type=text name=barcolor value=\"$barcolor\"></td></tr>";
		print "</table>";
		print "<a href=\"rgb.gif\" target=\"_blank\">Help with colors</a><br>";
		print "<input type=submit value='Save & Preview'><br><br>";

		print "Question:<br><input type=text value=\"@questions[0]\" length=100 name=question><br>";
		print "Possible Answers (1 per line):<br>";
		print "<textarea name=answers rows=5 cols=60>";

		$a = -1;
		foreach $answer(@questions) {
			$a++;
			unless($a eq 0) {
				print "$answer";
			}
		}
		
		print "</textarea><br>";
		print "<input type=submit value='Save & Preview'><br><br>";
		print "</form>";

		print "<form method=post action=polladmin.pl>";
		print "<input type=hidden name=action value=erase>";
		print "<input type=hidden name=password value=$password>";
		print "<input type=submit value='Erase Results/IP Log'>";
		print "</form>";

		print "<form>";
		print "Preview:<br>";
		&DoTable;
		print "<br>";
		&ShowResults;
		print "</form>";
	} 
} 

