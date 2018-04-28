
#
# Table structure for table 'box'
#
DROP TABLE IF EXISTS box;
CREATE TABLE box (
  boxid varchar(50) DEFAULT '' NOT NULL,
  title varchar(50) DEFAULT '' NOT NULL,
  content text NOT NULL,
  description text,
  template varchar(39) DEFAULT '' NOT NULL,
  PRIMARY KEY (boxid)
);

LOCK TABLES box WRITE;
#
# Dumping data for table 'box'
#

INSERT INTO box VALUES ('user_box','Login','my $content;\r\nif ($S->{UID} > 0) {\r\n\r\n    my $new_stories = $S->_count_new_sub();\r\n    if ($S->have_perm(\'moderate\')) {\r\n        $content .= qq|\r\n        + <A CLASS="light" HREF="%%rootdir%%/?op=modsub">Choose Stories</A> (<FONT color="FF0000">$new_stories</FONT> new)<BR>|;
    }\r\n    $content .= qq|\r\n+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=user&tool=info\">User Info</A><BR>\r\n        + <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=user&tool=prefs\">User Preferences</A><BR>\r\n        + <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=interface&tool=prefs\">Display Preferences</A><BR>\r\n       + <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=logout\">Logout $S->{NICK}</A><BR>|;\r\n\r\n    $title = \"$S->{NICK}\";\r\n} else {\r\n    $content = $S->{UI}->{BLOCKS}->{login_box};\r\n    $content =~ s/%%LOGIN_ERROR%%/$S->{LOGIN_ERROR}/;\r\n}\r\nreturn $content;','the login box','box');
INSERT INTO box VALUES ('hotlist_box','overwritethis','if ($S->{HOTLIST} && $#{$S->{HOTLIST}} >= 0) {\r\n	my $box_content;\r\n\r\n	foreach my $sid (@{$S->{HOTLIST}}) {\r\n        	my $stories = $S->getstories(\r\n                	{-type => \'fullstory\',\r\n                	  -sid => $sid});\r\n        	my $story = $stories->[0];\r\n\r\n        	$box_content .= qq|\r\n                	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=displaystory;sid=$sid\">$story->{title}</A> ($story->{commentcount} comments)<BR>|;\r\n	}\r\n\r\n	$title = \"$S->{NICK}\'s Hotlist\";\r\n	return $box_content;\r\n}','the hotlist box','box');
INSERT INTO box VALUES ('menu_footer','','my $submit = \'\';\r\n\r\nif ( $S->have_perm(\'story_post\') ) {\r\n    $submit = \'<A HREF=\"%%rootdir%%/?op=submitstory\">submit story</A> |\';\r\n}\r\n\r\nmy $content = qq{\r\n%%norm_font%%\r\n$submit\r\n<A HREF=\"%%rootdir%%/?op=newuser\">create account</A> |\r\n<A HREF=\"%%rootdir%%/?op=special&page=faq\">faq</A> |\r\n<A HREF=\"%%rootdir%%/?op=search\">search</A>\r\n%%norm_font_end%%};\r\n\r\nreturn $content;','Text-mode main menu','blank_box');
INSERT INTO box VALUES ('features_box','Features','$S->{UI}->{BLOCKS}->{features}','','box');
INSERT INTO box VALUES ('older_list_box','Older Stories','my $stories = $S->getstories({-type => \'titlesonly\'});\r\nmy $box_content;\r\n\r\nmy $date = undef;\r\nforeach my $story (@{$stories}) {\r\n    if (($story->{ftime} ne $date) || !$date) {\r\n        $date = $story->{ftime};\r\n        $box_content .= qq|\r\n                <P>\r\n                <B>$story->{ftime}</B>|;\r\n    }\r\n    $box_content .= qq|\r\n    <BR>+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=displaystory&sid=$story->{sid}\">$story->{title}</A> ($story->{commentcount} comments)|;\r\n    \r\n	if ($S->have_perm(\'story_list\')) {\r\n        $box_content .= qq| [<A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=story&sid=$story->{sid}\">edit</A>]|;\r\n    }\r\n}\r\n\r\nmy $offset = $S->{UI}->{VARS}->{maxstories} + $S->{UI}->{VARS}->{maxtitles};\r\n$box_content .= qq|\r\n            <P>\r\n            <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=search&offset=$offset\">Older Stories...</A>|;\r\n\r\nreturn $box_content;','','box');
INSERT INTO box VALUES ('fortune_box','Inspiration','my $content = `/usr/games/fortune -s`;\r\n$content =~ s/\\n\\s+-/%%norm_font_end%%<\\/I><\\/TD><\\/TR><TR><TD ALIGN=\"right\" BGCOLOR=\"%%box_content_bg%%\">%%norm_font%%<I>/g;\r\n\r\nreturn \"%%norm_font%%<I>$content</I>%%end_norm_font%%\";\r\n','Output of the fortune program, for kicks.','box');
INSERT INTO box VALUES ('login_box','Login','$template =~ s/|LOGIN_ERROR|/$S->{LOGIN_ERROR}/;\r\nreturn 0;\r\n','the login box','login_box');
INSERT INTO box VALUES ('admin_tools','Admin Tools','my $content;\r\n\r\nif ($S->have_perm(\'story_admin\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=story\">New Story</A><BR>|;\r\n}\r\nif ($S->have_perm(\'story_list\')) {\r\n	$content .= qq|	\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=storylist\">Story List</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_polls\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=editpoll\">New Poll</A><BR>|;\r\n}\r\nif ($S->have_perm(\'list_polls\')) {\r\n	$content .= qq|\r\n    + <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=listpolls\">Poll List</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_vars\') || $S->have_perm(\'edit_blocks\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=vars\">Vars/Blocks</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_topics\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=topics\">Topics</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_sections\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=sections\">Sections</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_special\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=special\">Special Pages</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_boxes\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=boxes\">Boxes</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_templates\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=optemplates\">Templates</A><BR>|;\r\n}\r\nif ($S->have_perm(\'edit_groups\')) {\r\n	$content .= qq|\r\n	+ <A CLASS=\"light\" HREF=\"%%rootdir%%/?op=admin&tool=groups\">Groups</A><BR>|;\r\n}\r\n\r\nreturn \'\' unless $content;\r\n\r\nreturn qq|$content|;','Admin Tools box','box');
INSERT INTO box VALUES ('main_menu','Menu','my $submit = \'\';\r\n\r\nif ( $S->have_perm(\'story_post\') ) {\r\n    $submit = \'+<A HREF=\"%%rootdir%%/?op=submitstory\">submit story</A><BR>\';\r\n}\r\n\r\nmy $content = qq{\r\n%%smallfont%%\r\n$submit\r\n+<A HREF=\"%%rootdir%%/?op=newuser\">create account</A><BR>\r\n+<A HREF=\"%%rootdir%%/?op=special&page=faq\">faq</A><BR>\r\n+<A HREF=\"%%rootdir%%/?op=special&page=mission\">mission</A><BR>\r\n+<A HREF=\"%%rootdir%%/?op=search\">search</A>\r\n%%smallfont_end%%};\r\n\r\nreturn $content;','The menu block-- variable for perms','left_box');
INSERT INTO box VALUES ('poll_box','Poll','my $pollqid = shift @ARGS;\r\n\r\n# Check for a story with attached poll\r\nif (my $sid = $S->{CGI}->param(\'sid\')) {\r\n    $sid = $S->{DBH}->quote($sid);\r\n    my ($rv, $sth) = $S->db_select({\r\n        WHAT => \'attached_poll\',\r\n        FROM => \'stories\',\r\n        WHERE => qq|sid = $sid|});\r\n    if (my $att_poll = $sth->fetchrow()) {\r\n        $pollqid = $att_poll;\r\n    } else {\r\n    return \'\';\r\n    }\r\n} \r\n\r\nreturn \'\' unless $S->{UI}->{VARS}->{current_poll};\r\n\r\nmy $poll_hash = $S->get_poll_hash( $pollqid );\r\n\r\n# first get the poll form all set up except for the answers\r\nmy $poll_form = qq|\r\n	<!-- begin poll form -->\r\n	<FORM ACTION=\"%%rootdir%%/\" METHOD=\"POST\">\r\n    <INPUT TYPE=\"hidden\" NAME=\"op\" VALUE=\"view_poll\">\r\n    <INPUT TYPE=\"hidden\" NAME=\"qid\" VALUE=\"$poll_hash->{\'qid\'}\">\r\n    <INPUT type=\"hidden\" name=\"ispoll\" value=\"1\">|;\r\n\r\n$poll_form .= \"<b>$poll_hash->{\'question\'}</b><br>\";\r\n\r\n# here is where all the answer fields get filled in\r\nmy $answer_array = $S->get_poll_answers($poll_hash->{\'qid\'});\r\n\r\n# now check if they have already voted or havn\'t logged in\r\n\r\nmy $row;\r\nif ( $S->_can_vote($poll_hash->{\'qid\'}) ) {\r\n    foreach $row ( @{$answer_array} ) {	\r\n        $poll_form .= qq|\r\n   	        <INPUT TYPE=\"radio\" NAME=\"aid\" VALUE=\"$row->{\'aid\'}\"> $row->{\'answer\'}<BR>|;\r\n   	}\r\n} else {\r\n    my $total_votes = $poll_hash->{\'voters\'};\r\n\r\n    if($total_votes == 0) {\r\n        $total_votes = 1;  # so we don\'t get a divide by 0 error\r\n    }\r\n\r\n	$poll_form .= qq|\r\n		<TABLE BORDER=0 CELLPADDING=2 CELLSPACING=0>|;\r\n\r\n	foreach $row ( @{$answer_array} ) {\r\n		my $percent = int($row->{\'votes\'} / $total_votes * 100);\r\n		$poll_form .= qq|\r\n			<TR>\r\n				<TD valign=\"top\">%%norm_font%%%%dot%%%%norm_font_end%%</TD>\r\n				<TD valign=\"top\">%%norm_font%%$row->{\'answer\'}%%norm_font_end%%</TD>\r\n				<TD valign=\"top\">%%norm_font%% $percent% %%norm_font_end%%</TD>\r\n			</TR>|;\r\n   	}\r\n	$poll_form .= qq|\r\n		</TABLE>|;\r\n		\r\n}\r\n\r\n# get the # of comments\r\nmy $comment_num = $S->poll_comment_num($poll_hash->{\'qid\'});\r\n   \r\n# only show the vote button if they havn\'t voted\r\nif ( $S->_can_vote($poll_hash->{\'qid\'}) ) {\r\n	$poll_form .= qq|<BR><INPUT TYPE=\"submit\" name=\"vote\" VALUE=\"Vote\">|;\r\n}\r\n\r\n\r\n# now finish up the form\r\n$poll_form .= qq{\r\n	</FORM>\r\n	<!-- end poll form -->\r\n	<P>\r\n	%%norm_font%%\r\n    <TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 ALIGN=\"center\">\r\n	<TR>\r\n	<TD>%%norm_font%%[ Votes: <b>$poll_hash->{\'voters\'}</b>%%norm_font_end%%</TD>\r\n	<TD ALIGN=\"center\" WIDTH=15>%%norm_font%%|%%norm_font_end%%</TD>\r\n	<TD ALIGN=\"right\">%%norm_font%% Comments: <b>$comment_num</b> ]%%norm_font_end%%</TD></TR>\r\n	<TR>\r\n	<TD>%%norm_font%%[ <a href=\"%%rootdir%%/?op=view_poll&qid=$poll_hash->{\'qid\'}\">Results</a>%%norm_font_end%%</TD>\r\n	<TD ALIGN=\"center\" WIDTH=15>%%norm_font%%|%%norm_font_end%%</TD>\r\n    <TD ALIGN=\"right\">%%norm_font%% <a href=\"%%rootdir%%/?op=poll_list&qid=$poll_hash->{\'qid\'}\">Other Polls</a> ]%%norm_font_end%%</TD></TR>\r\n	</TABLE>\r\n	%%norm_font_end%%\r\n	<!-- end poll content -->};\r\n\r\n\r\nif ($poll_form) {\r\n	return qq|%%norm_font%%$poll_form%%norm_font_end%%|;\r\n} else {\r\n	return \'\';\r\n}','Box to display polls.','box');
INSERT INTO box VALUES ('related_links','Related Links','my $sid = $S->{CGI}->param(\'sid\');\r\n\r\nmy $related = $S->related_box($sid);\r\n\r\nmy $content;\r\nmy $i = 0;\r\nwhile ($i <= $#{$related}) {\r\n  $content .= qq|+ $related->[$i+1]$related->[$i]</A><BR>|;\r\n  $i += 2;\r\n}\r\n\r\nreturn $content;','The Related links box which appears with stories','box');
INSERT INTO box VALUES ('comment_controls','Comment Controls','my $sid = $S->{CGI}->param(\'sid\');\r\nmy $pid = $S->{CGI}->param(\'pid\');\r\nmy $cid = $S->{CGI}->param(\'cid\');\r\n\r\nmy $commentmode_select = $S->_comment_mode_select();\r\nmy $comment_order_select = $S->_comment_order_select();\r\nmy $comment_rating_select = $S->_comment_rating_select();\r\nmy $rating_choice = $S->_comment_rating_choice();\r\nmy $comment_type_select = $S->_comment_type_select();\r\n\r\nmy $form_op = \'op\';\r\nmy $form_op_value = \'displaystory\';\r\nmy $id = \'sid\';\r\n\r\nif ($S->_does_poll_exist($sid)) {\r\n	$form_op       = \'op\';\r\n	$form_op_value = \'view_poll\';\r\n	$id 		   = \'qid\';\r\n}\r\n	\r\nmy $comment_sort = qq|\r\n		<FORM NAME=\"commentmode\" ACTION=\"%%rootdir%%/\" METHOD=\"post\">\r\n	<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0 BGCOLOR=\"%%box_content_bg%%\">\r\n		<INPUT TYPE=\"hidden\" NAME=\"$form_op\" VALUE=\"$form_op_value\">\r\n		<INPUT TYPE=\"hidden\" NAME=\"$id\" VALUE=\"$sid\">\r\n	\r\n		<TR>\r\n			<TD VALIGN=\"middle\">\r\n				%%smallfont%%\r\n					View:\r\n				%%smallfont_end%%\r\n			</TD>\r\n			<TD VALIGN=\"top\">\r\n				%%smallfont%%<SMALL>\r\n					$comment_type_select\r\n				</SMALL>%%smallfont_end%%\r\n			</TD>\r\n		</TR>\r\n	\r\n	<TR>\r\n		<TD VALIGN=\"middle\">\r\n			%%smallfont%%\r\n				Display:\r\n			%%smallfont_end%%\r\n		</TD>\r\n		<TD>\r\n		%%smallfont%%<SMALL>\r\n			$commentmode_select\r\n		</SMALL>%%smallfont_end%%\r\n		</TD>\r\n	</TR>\r\n	\r\n	<TR>\r\n		<TD VALIGN=\"middle\">\r\n			%%smallfont%%\r\n				Sort:\r\n			%%smallfont_end%%\r\n		</TD>\r\n		<TD VALIGN=\"top\">\r\n			%%smallfont%%<SMALL>\r\n				$comment_rating_select\r\n			</SMALL>%%smallfont_end%%\r\n		</TD>\r\n	</TR>\r\n	<TR>\r\n		<TD>\r\n			%%smallfont%%&nbsp;%%smallfont_end%%\r\n		</TD>\r\n		<TD>\r\n			%%smallfont%%<SMALL>\r\n				$comment_order_select\r\n			</SMALL>%%smallfont_end%%\r\n		</TD>\r\n	</TR>\r\n|;\r\n	\r\n		\r\nif ($S->have_perm( \'comment_rate\' )) {\r\n	$comment_sort .= qq|\r\n	<TR>\r\n	<TD VALIGN=\"middle\">%%smallfont%%\r\n	Rate?\r\n	%%smallfont_end%%\r\n	</TD>\r\n	<TD VALIGN=\"top\">%%smallfont%%\r\n	<SMALL>$rating_choice</SMALL>\r\n	%%smallfont_end%%\r\n	</TD>\r\n	</TR>|;\r\n}\r\n\r\n$comment_sort .= qq|\r\n<TR><TD COLSPAN=2 ALIGN=\"right\">%%smallfont%%<INPUT TYPE=\"submit\" NAME=\"setcomments\" VALUE=\"Set\">%%smallfont_end%%</TD></TR>\r\n</TABLE>\r\n</FORM>|;\r\n','Comment display prefs','box');
INSERT INTO box VALUES ('mod_stats','Moderation Stats','my $sid = $ARGS[0];\r\nmy ($totalvotes, $score) = $S->_get_total_votes($sid);\r\nmy $sth = $S->_get_story_mods($sid);\r\n\r\nmy $head = $S->{UI}->{BLOCKS}->{moderate_head};\r\n\r\n$head =~ s/%%votes%%/$totalvotes/g;\r\n$head =~ s/%%score%%/$score/g;\r\n\r\nmy ($this_row, $user);\r\n\r\nmy $for = qq|%%norm_font%%<B>Voted for:</B> (%%for%%)<BR>|;\r\nmy $against = qq|<P><B>Voted against:</B> (%%against%%)<BR>|;\r\nmy $neutral = qq|<P><B>Didn\'t care:</B> (%%neutral%%)<BR>|;\r\nmy ($f, $a, $n) = 0;\r\n\r\nwhile (my $mod_rec = $sth->fetchrow_hashref) {\r\n	my $nick = $S->get_nick($mod_rec->{uid});\r\n	my $link = qq|\r\n	<A CLASS=\"light\" HREF=\"%%rootdir%%/?op=user&tool=info&uid=$mod_rec->{uid}\">$nick</A>|;\r\n	if ($mod_rec->{vote} == 1) {\r\n		$for .= qq|\r\n		$link<BR>|;\r\n		$f++;\r\n	} elsif ($mod_rec->{vote} == 0) {\r\n		$neutral .= qq|\r\n		$link<BR>|;\r\n		$n++;\r\n	} elsif ($mod_rec->{vote} == -1) {\r\n		$against .= qq|\r\n		$link<BR>|;\r\n		$a++;\r\n	}\r\n}\r\n$sth->finish;\r\n\r\n$for =~ s/%%for%%/$f/;\r\n$against =~ s/%%against%%/$a/;\r\n$neutral =~ s/%%neutral%%/$n/;\r\n\r\nmy $content = $head.$for.$against.$neutral.\'%%norm_font_end%%\';\r\nreturn $content;','Show the stats for story mod','box');
UNLOCK TABLES;

LOCK TABLES blocks WRITE;
delete from blocks where bid = 'box';
delete from blocks where bid = 'blank_box';
INSERT INTO blocks VALUES ('box','<TABLE WIDTH=100% BORDER=0 CELLPADDING=2 CELLSPACING=0>\r\n<TR>\r\n<TD BGCOLOR=\"%%box_title_bg%%\">%%box_title_font%%%%title%%</B></FONT></TD>\r\n</TR>\r\n<TR>\r\n<TD bgcolor=\"%%box_content_bg%%\">%%smallfont%%\r\n%%content%%\r\n%%smallfont_end%%</TD></TR>\r\n</TABLE>\r\n',NULL,NULL);
INSERT INTO blocks VALUES ('blank_box','<TABLE BORDER=0 CELLPADDING=0 CELLSPACING=0>\r\n    <TR>\r\n        <TD>%%content%%</TD>\r\n    </TR>\r\n</TABLE>',NULL,NULL);
INSERT INTO blocks VALUES ('login_box','<TABLE BORDER=0 width=\"100%\" align=\"center\" CELLPADDING=1 CELLSPACING=0 BGCOLOR=\"%%box_content_bgcolor%%\">\r\n	<TR>\r\n		<TD COLSPAN=2>\r\n			<CENTER>%%LOGIN_ERROR%%</CENTER>\r\n		</TD>\r\n	</TR>\r\n	<TR>\r\n		<TD COLSPAN=2>\r\n			<CENTER>\r\n			%%norm_font%%\r\n			<B><A CLASS=\"light\" HREF=\"%%rootdir%%/?op=newuser\">Make a new account</A></B>\r\n			%%norm_font_end%%\r\n			</CENTER>\r\n		</TD>\r\n	</TR>\r\n	<TR>\r\n		<TD align=\"right\">\r\n			<FORM NAME=\"login\" ACTION=\"%%rootdir%%/\" METHOD=\"post\">\r\n			%%norm_font%%<SMALL>Username:</SMALL>%%norm_font_end%%\r\n		</TD>\r\n		<TD>\r\n			%%norm_font%%<SMALL><INPUT TYPE=\"text\" SIZE=12 NAME=\"uname\"></SMALL>%%norm_font_end%%\r\n		</TD>\r\n	</TR>\r\n	<TR>\r\n		<TD align=\"right\">\r\n			%%norm_font%%<SMALL>Password:</SMALL>%%norm_font_end%%\r\n		</TD>\r\n		<TD>\r\n			%%norm_font%%<SMALL><INPUT TYPE=\"password\" SIZE=12 NAME=\"pass\"></SMALL>%%norm_font_end%%\r\n		</TD>\r\n	</TR>\r\n	<TR>\r\n		<TD align=\"right\" COLSPAN=2>\r\n    		%%norm_font%%\r\n			<INPUT TYPE=\"submit\" NAME=\"mailpass\" VALUE=\"Mail Password\">\r\n    		<INPUT TYPE=\"submit\" NAME=\"login\" VALUE=\"Login\">\r\n			%%norm_font_end%%</FORM>\r\n    	</TD>\r\n	</TR>\r\n</TABLE>\r\n\r\n',NULL,NULL);
UNLOCK TABLES;

