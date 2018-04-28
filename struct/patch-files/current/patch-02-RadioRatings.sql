INSERT INTO `box` VALUES ('rating_type_selectbox','','my $choice = $ARGS[0];\r\n\r\nmy %choices = ( \"dropdown\", \"Drop Down box\", \"radio\", \"Radio Buttons\" );\r\n\r\nmy $select = qq{\r\n      <SELECT name=\"rating_type\" size=\"1\">};\r\n\r\nforeach my $c (sort keys %choices) {\r\n  my $checked = ($c eq $choice) ? \' SELECTED\' : \'\';\r\n  $select .= qq{\r\n        <OPTION value=\"$c\"$checked>$choices{$c}</OPTION>};\r\n}\r\n\r\n$select .= qq{\r\n      </SELECT>};\r\n\r\nreturn $select;','Rating type select box for user preferences','empty_box',0);
UPDATE `pref_items` SET `display_order` = `display_order` + 1 WHERE `display_order` > 7 AND `page` = 'Comments';
INSERT INTO `pref_items` VALUES ('rating_type','Rating Selection','',0,0,'','','',0,'radio',0,'(radio|dropdown)','Comments','%%BOX,rating_type_selectbox,%%value%%%%',8,'selectbox_pref','',1,'normal');