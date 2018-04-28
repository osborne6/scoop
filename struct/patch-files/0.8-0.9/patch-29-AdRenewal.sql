alter table ad_info change column cash_cache impression_cache int(11) default 0;

update blocks set block = CONCAT(block, '\r\nrenew,') WHERE bid = 'opcodes';

INSERT INTO blocks VALUES ('renewad_template','<HTML>\r\n<HEAD>\r\n<TITLE>%%sitename%% || %%subtitle%%</TITLE>\r\n</HEAD>\r\n<BODY bgcolor=\"#FFFFFF\" text=\"#000000\" link=\"#006699\" vlink=\"#003366\">\r\n\r\n%%header%%\r\n\r\n<!-- Main layout table -->\r\n<TABLE BORDER=0 WIDTH=\"99%\" ALIGN=\"center\" CELLPADDING=0 CELLSPACING=10>\r\n	<!-- Main page block -->\r\n	<TR>\r\n		\r\n		<!-- Center content section -->\r\n		<TD VALIGN=\"top\" width=\"73%\">\r\n			%%BOX,renewad_box%%\r\n		</TD>\r\n		<!-- X center content section -->\r\n		\r\n		<!-- Right boxes column -->\r\n		<TD VALIGN=\"top\" WIDTH=\"27%\">\r\n\r\n			%%BOX,main_menu%%\r\n			%%BOX,hotlist_box%%\r\n			%%BOX,user_box%%\r\n			%%BOX,admin_tools%%\r\n		\r\n		</TD>\r\n		<!-- X Right boxes column -->\r\n	</TR>\r\n	<!-- X main page block -->\r\n</TABLE>\r\n<!-- X Main layout table -->\r\n<P>\r\n%%footer%%\r\n<P>\r\n<CENTER>%%BOX,menu_footer%%</CENTER>\r\n</BODY>\r\n</HTML>\r\n',NULL,NULL);
INSERT INTO blocks VALUES ('renew_ad_message','Renew an ad.  Right here!  Today!',NULL,NULL);
INSERT INTO blocks VALUES ('renew_choose_ad','%%norm_font%% You need to choose an ad to renew.  Check <a href=\"%%rootdir%%/my/ads\">your ad listing page</a> to \r\nchoose an ad to renew. %%norm_font_end%%',NULL,NULL);
INSERT INTO blocks VALUES ('renew_ad_no_permission','%%norm_font%% Sorry, but you cannot renew another person\'s advertisement.  Please choose an ad from <a href=\"%%rootdir%%/my/ads\">your ad list</a> to renew.%%norm_font_end%%',NULL,NULL);
INSERT INTO blocks VALUES ('renew_confirm_message','%%norm_font%% Be sure that you entered the correct amount of impressions to buy, and click confirm below when you are satisfied and ready to purchase. %%norm_font_end%%',NULL,NULL);
INSERT INTO blocks VALUES ('confirm_ad_renew','%%norm_font%% Be sure this is the number of impressions you want to purchase, and hit \"Purchase\" below when you are ready to renew your ad %%norm_font_end%%',NULL,NULL);
INSERT INTO box VALUES ('renewad_box','Renew Advertisement','my $content = \'\';\r\nmy $err = \'\';\r\nmy $ad_id = $S->cgi->param(\'ad_id\') || 0;\r\nmy $confirm = $S->cgi->param(\'confirm\') || \'nope\';\r\nmy $purchase = $S->cgi->param(\'purchase\') || \'nope\';\r\nmy $cgi_amount = $S->cgi->param(\'amount\') || \'0.00\';\r\nmy $confirm_amt = $S->cgi->param(\'confirm_amt\') || \'1.11\'; # 1.11 so that it != $cgi_amount\r\n\r\n# first get the page set up\r\n$content = qq{\r\n<form name=\"buyimpressions\" action=\"%%rootdir%%/renew\" method=\"POST\" enctype=\"multipart/form-data\">\r\n<input type=\"hidden\" name=\"confirm_amt\" value=\"$cgi_amount\" />\r\n<table border=\"0\" cellpadding=\"1\" cellspacing=\"1\" width=\"99%\"> \r\n<tr><td colspan=\"2\" bgcolor=\"%%title_bgcolor%%\">%%title_font%% Renew Advertisement %%title_font_end%%</td></tr>\r\n<tr><td colspan=\"2\"> <input type=\"hidden\" name=\"ad_id\" value=\"$ad_id\"> &nbsp; </td></tr>\r\n};\r\n\r\n###########################################\r\n### Check to make sure they can renew the ad, then renew\r\n###  else show error message.  SEt up links on user ad list\r\n###  make sure they all direct to the right box\r\n###  get cron from rusty to set up to handle renewals right\r\n###  make sure db fields are there.\r\n###  maybe write some functions to handle renewals\r\n\r\nmy $ad_hash = $S->get_ad_hash($ad_id, \'db\');\r\n\r\n# first make sure they have chosen an ad\r\nunless( $ad_id ) {\r\n	$content .= qq{ <tr><td colspan=\"2\">%%norm_font%% %%renew_choose_ad%% %%norm_font_end%%</td></tr>\r\n</table></form>};\r\n	return { content => $content };\r\n}\r\n\r\nunless( $ad_hash->{sponsor} eq $S->{UID} ) {\r\n	$content .= qq{ <tr><td colspan=\"2\">%%norm_font%% %%renew_ad_no_permission%% %%norm_font_end%%</td></tr>\r\n</table></form>};\r\n	return { content => $content };\r\n}\r\n\r\n# check if confirm, and if so, change the action \r\nif( $purchase && $purchase eq \'Purchase\' && ($confirm_amt == $cgi_amount) ) {\r\n	warn \"sucessful purchase\" if $DEBUG;\r\n	return qq[%%BOX,submit_ad_pay_box,renew,$ad_hash->{ad_id},$confirm_amt%%];\r\n}\r\nelsif( $purchase && $purchase eq \'Purchase\' && ($confirm_amt != $cgi_amount) )  {\r\n	# they changed their amount, let them know why they\'re at the same page again.\r\n	$err = qq|<font color=\"ff0000\"> You have changed the amount you wanted to purchase, please click Purchase again to purchase the new amount</font>|;\r\n}\r\n\r\n\r\n# if we get here, and they clicked either button, then mark it as confirmed.\r\n# its possible that they changed their amount w/out confirming again.\r\nmy $purchase_button = \'\';\r\nmy $confirmed = 0;\r\nif( ($confirm && $confirm eq \'Confirm\') or ($purchase && $purchase eq \'Purchase\') ) {\r\n	$purchase_button = q{<input type=\"submit\" name=\"purchase\" value=\"Purchase\" />};\r\n	$confirmed = 1;\r\n}\r\n\r\n# need to check the input a little and generate the amount to populate the form with\r\nmy $ad_type = $S->get_ad_tmpl_info( $ad_hash->{ad_tmpl} );\r\nmy $min_impressions = $ad_type->{min_purchase_size};\r\nmy $cpm = $ad_type->{cpm};\r\nmy $amount = \'\';\r\nif( $confirmed && $cgi_amount && $cgi_amount !~ /^\\d+$/ ) {\r\n	$err = qq{<font color=\"ff0000\"> \'$cgi_amount\' is not a valid number of ads to purchase, you must purchase at least $min_impressions ad impressions</font>};\r\n	$purchase_button = \'\';\r\n}\r\nelsif( $confirmed && $cgi_amount && ($cgi_amount < $min_impressions) ) {\r\n	$err = qq{<font color=\"ff0000\"> $cgi_amount is not a valid purchase amount, the minimum amount you may purchase is $min_impressions ad impressions</font>};\r\n	$purchase_button = \'\';\r\n}\r\nelsif( $confirmed ) {\r\n	$amount = $cgi_amount;\r\n}\r\n\r\nmy $confirm_msg = $S->{UI}->{BLOCKS}->{confirm_ad_renew};\r\n$confirm_msg = \'\' unless $confirmed;\r\n\r\n$content .= qq{\r\n<tr><td colspan=\"2\"> &nbsp; </td></tr>\r\n<tr><td colspan=\"2\"> %%BOX,show_ad,$ad_id%% </td></tr>\r\n<tr><td colspan=\"2\"> %%norm_font%% $err %%norm_font_end%% </td></tr>\r\n<tr><td colspan=\"2\"> %%norm_font%% %%renew_ad_message%% %%norm_font_end%% </td></tr>\r\n<tr><td colspan=\"2\"> &nbsp; </td></tr>\r\n<tr><td align=\"left\" valign=\"top\"> %%norm_font%% <b>Order Size:</b> %%norm_font_end%% </td>\r\n<td align=\"left\" valign=\"top\"> %%norm_font%% <input type=\"text\" name=\"amount\" value=\"$amount\" /> %%norm_font_end%%</td>\r\n</tr>\r\n<tr><td colspan=\"2\"> %%norm_font%% <i>Minimum order size is $min_impressions impressions</i> %%norm_font_end%%</td></tr>\r\n<tr><td colspan=\"2\"> %%norm_font%% $confirm_msg %%norm_font_end%% </td></tr>\r\n<tr><td colspan=\"2\"> &nbsp; </td></tr>\r\n<tr><td colspan=\"2\" align=\"center\"> %%norm_font%% <input type=\"submit\" name=\"confirm\" value=\"Confirm\" /> $purchase_button </td></tr>\r\n};\r\n\r\n$content .= q{</table></form>};\r\n\r\n\r\n\r\n\r\nreturn { content => $content };\r\n','A page to let users renew the impressions on their ads.','blank_box',0);
INSERT INTO special VALUES ('adlist','Advertisement Types','This is just a list of all the types of advertisements.','%%BOX,ad_types%%');
INSERT INTO templates VALUES ('renewad_template','renew');
INSERT INTO vars VALUES ('allow_ad_renewal','0','If this is on people can renew the impressions left in their ads via /renew, and a link from their ad listing page.','bool','Advertising');
