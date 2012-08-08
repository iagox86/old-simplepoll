
sub GetInput {
	use CGI; 
	$req = new CGI; 
	$action = $req->param("action"); 
	$password = $req->param("password"); 
	$username = $req->param("username"); 
	$answers = $req->param("answers"); 
	$question = $req->param("question"); 
	$bcol = $req->param("bgcolor"); 
	$fcol = $req->param("color"); 
	$border = $req->param("border"); 
	$bordercolor = $req->param("bordercolor"); 
	$bordercolorlight = $req->param("bordercolorlight"); 
	$bordercolordark = $req->param("bordercolordark"); 
	$cellpadding = $req->param("cellpadding"); 
	$cellspacing = $req->param("cellspacing"); 
	$width = $req->param("width"); 
	$size = $req->param("size"); 
	$selection = $req->param("selection"); 
	$beforetags = $req->param("beforetags"); 
	$aftertags = $req->param("aftertags"); 
	$barcolor =  $req->param("barcolor"); 
	$newpassword =  $req->param("newpassword"); 
	$passwordnew =  $req->param("passwordnew"); 
}



sub DoTable {

	@questions = GetQuestions();
	@settings = GetSettings();

	($bgcolor, $color, $border, $bcolor, $blightborder, $bdarkborder, $cellpadding, $cellspacing, $tablewidth, $fontsize, $beforetags, $aftertags, $barcolor) = @settings;
	my $a = "";
	my $font = "";
	
	if($bgcolor) { $a = $a . "bgcolor=$bgcolor "; }
	if($color) { $font = $font . "color=$color "; }
	if($fontsize) { $font = $font . "size=$fontsize "; }
	if($border) { $a = $a . "border=$border "; }
	if($bcolor) { $a = $a . "bordercolor=$bcolor "; }
	if($blightborder) { $a = $a . "bodercolorlight=$blightborder "; }
	if($bdarkborder) { $a = $a . "bordercolordark=$bdarkborder "; }
	if($cellpadding) { $a = $a . "cellpadding=$cellpadding "; }
	if($cellspacing) { $a = $a . "cellspacing=$cellspacing "; }
	if($tablewidth) { $a = $a . "width=$tablewidth "; }
	

	print "<table $a>\n";
	print "<tr><td>&nbsp</td><td><font $font>$beforetags @questions[0] $aftertags</font></td></tr>";
	
	$a=-1;
	
	foreach $thisquestion(@questions) {
	
		$a++;
		unless($a==0) {
	
		print <<"EOT";
	
		<tr valign=center>\n
		 <td width=25>\n
		  <input type="radio" name="selection" value=$a>\n
		 </td>\n
		 <td width=500>\n
		   <font $font>$thisquestion</font>\n
		 </td> \n
		</tr>\n
	
EOT
		}
	}
	print "<tr><td colspan=\"2\"><input type=\"submit\" value=\"Submit\"><font size=-2><br><a href=polladmin.pl>Admin Only!</a></font></td></tr>";
	print "</table>";
}

sub GetSettings {
	open(FILE, "poll.dat") || print "ERROR: Can't open data file";
		my @settings = <FILE>;
	close(FILE);

	my $a=-1;
	foreach $this(@settings) {
		$a++;
		chomp($this);
		@settings[$a] = $this;
	}
		

	return(@settings);

}

sub GetQuestions {
	open(FILE, "questions.dat") || print "ERROR: Can't open questions file";
		my @questions = <FILE>;
	close(FILE);
	return(@questions);

}

sub HasHeBeenHere {
	open(FILE, "ip.dat");
	 @ips = <FILE>;
	close(FILE);
	
	$ip = $ENV{REMOTE_ADDR};
	@subnets = split(/\./, $ip);

	foreach $loggedip(@ips) {
		if($loggedip eq (@subnets[0] . "&" . @subnets[1] . "\n")) {
			return(1);
		} 
	}
	return(0);
}

sub TagIP {
	$ip = $ENV{REMOTE_ADDR};
	@subnets = split(/\./, $ip);

	open(FILE, "ip.dat");
	 @loggedips = <FILE>;
	close(FILE);

	open(FILE, ">ip.dat");
	 print FILE @loggedips;
	 print FILE @subnets[0] . "&" . @subnets[1] . "\n";
	close(FILE);
}

sub ClearLogs {
	unlink('ip.dat', 'results.dat');
}


sub Vote {

	open(FILE, "results.dat");
	 my @results=<FILE>;
	close(FILE);

	my @questions = &GetQuestions;
	my $a = -1;
	foreach(@questions) {
		$a++;
		if(@results[$a] eq "\n" || @results[$a] eq "") { @results[$a] = "0\n"; }
	}

	$oldvote=@results[$selection];

	chomp($oldvote);
	$oldvote = $oldvote + 1;
	$oldvote = $oldvote . "\n";

	@results[$selection] = $oldvote;

	open(FILE, ">results.dat");
	 print FILE @results;
	close(FILE);

}


sub ShowResults {
	
	@settings = GetSettings();
	($bgcolor, $color, $border, $bcolor, $blightborder, $bdarkborder, $cellpadding, $cellspacing, $tablewidth, $fontsize, $beforetags, $aftertags, $barcolor) = @settings;

	open(FILE, "results.dat");
	 @results = <FILE>;
	close(FILE);

	@questions = &GetQuestions;

	$a = "";

	if($bgcolor) { $a = $a . "bgcolor=$bgcolor "; }
	if($color) { $font = $font . "color=$color "; }
	if($fontsize) { $font = $font . "size=$fontsize "; }
	if($border) { $a = $a . "border=$border "; }
	if($bcolor) { $a = $a . "bordercolor=$bcolor "; }
	if($blightborder) { $a = $a . "bodercolorlight=$blightborder "; }
	if($bdarkborder) { $a = $a . "bordercolordark=$bdarkborder "; }
	if($cellpadding) { $a = $a . "cellpadding=$cellpadding "; }
	if($cellspacing) { $a = $a . "cellspacing=$cellspacing "; }
	if($tablewidth) { $a = $a . "width=$tablewidth "; }
	
	if($barcolor eq "\n" || $barcolor eq "") { $barcolor="FF0000"; }

	print "<table $a>\n";
	print "<tr><td colspan=3><font $font>$beforetags @questions[0] $aftertags</font></td>";
	my $a=-1;

	
	foreach $thisquestion(@questions) {
	
		$a++;
		unless($a==0) {

		my $percent = &PercentResult($a);
		$double = $percent*2;
		unless($double == 0) {
			$bar = "<table border=0 bgcolor=$barcolor width=$percent><tr><td>&nbsp</td></tr></table>";
		} else {
			$bar = "&nbsp";
		}


		print <<"EOT";
	
		<tr valign=center>
		 <td>
		  <font $font>$thisquestion</font>
		 </td> 
		 <td width=100>
		  $bar
		 </tr>
		 <td>
		   $percent%&nbsp(@results[$a])
		 </td>
		</tr>

EOT
		}
	}
	print "<tr><td><font size=-2><a href=polladmin.pl>Admin Only!</a></font></td>";
	print "<td><table border=0 bgcolor=$barcolor width=100><tr><td>&nbsp</td></tr></table></td>";
	print "<td>Total: 100%&nbsp($total)</td></tr>";

	print "</table>";

}

sub PercentResult {
	my $question = @_[0];

	open(FILE, "results.dat");
	 my @results=<FILE>;
	close(FILE);

	$total=0;
	foreach $result(@results) {
		$thisone = $result;
		chomp($thisone);
		$total = $total + $thisone;
	}

	$ThisResult = @results[$question];

	unless($total eq "0") {
		my $percent = int(($ThisResult/$total) * 100);
		return($percent);
	} else {
		return(0);
	}
}

1;