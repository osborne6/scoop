INSERT INTO blocks VALUES ('special_edit_form','<form name=\"special\" action=\"%%rootdir%%/admin/special\" method=\"post\" enctype=\"multipart/form-data\">\r\n<div class=\"title\">Edit Special Pages</div>\r\n\r\n<div class=\"error\">%%msg%%</div>\r\n\r\n<div>%%preview%%</div>\r\n\r\n<div>\r\n<b>Page:</b> %%page_list%% <input type=\"submit\" name=\"get\" value=\"Get Page\" />\r\n<br /><br />\r\n<b>Page ID:</b><br />\r\n<input type=\"text\" name=\"pageid\" value=\"%%pageid%%\" size=\"25\" />\r\n<br /><br />\r\n<b>Title:</b><br />\r\n<input type=\"text\" name=\"title\" value=\"%%title%%\" size=\"40\" />\r\n<br /><br />\r\n<b>Description:</b><br />\r\n<textarea cols=\"50\" rows=\"3\" name=\"description\" wrap=\"soft\">%%description%%</textarea>\r\n<br /><br />\r\n<b>Content:</b><br />\r\n<textarea cols=\"50\" rows=\"25\" name=\"content\" wrap=\"soft\">%%content%%</textarea><br />\r\n%%upload_page%%\r\n<br /><br />\r\n<b>Options:</b><br />\r\n<input type=\"checkbox\" name=\"direct_link\" value=\"1\"%%directlink_checked%% /> Create direct page link (i.e. http://example.com/pageid)<br />\r\n<input type=\"checkbox\" name=\"html_check\" value=\"1\"%%chkhtml_checked%% /> Check the HTML of this page<br />\r\n%%spellcheck%%\r\n%%delete%%\r\n<br /><br />\r\n<input type=\"submit\" name=\"write\" value=\"Save Page\"> <input type=\"reset\" />\r\n</div>\r\n</form>','1','The special page editing form.\r\n<p>\r\nKeys:\r\n<ul>\r\n<li> |msg|: For error or success messages\r\n<li> |preview|: When looking at a page, the view page link. Formatted with special_edit_preview\r\n<li> |page_list|: Select list of special pages. \r\n<li> |delete|: Delete page checkbox item. Formatted with special_edit_delete\r\n<li> |pageid|: The current page ID\r\n<li> |title|: The current page title\r\n<li> |description|: The current page description\r\n<li> |content|: the current page content\r\n<li> |upload_page|: The upload content form, if available\r\n<li> |directlink_checked|: Selected indicator for the direct-link options\r\n<li> |chkhtml_checked|: Selected indicator for the check html option\r\n<li> |spellcheck|: Spellcheck option form, if available\r\n</ul>','Admin Templates','default','en');
INSERT INTO blocks VALUES ('special_edit_preview','View <a href=\"%%rootdir%%/special/%%pageid%%\" target=\"new\">%%title%%</a> (opens in new window)\r\n<br /><br />','1','Preview line for special page editing form.\r\n<p>\r\nKeys:\r\n<ul>\r\n<li> |pageid|: The page\'s ID for linking.\r\n<li> |title|: The page\'s title.\r\n</ul>','Admin Pages','default','en');
INSERT INTO blocks VALUES ('special_edit_delete','<input type=\"checkbox\" name=\"delete\" value=\"1\" /> Delete this page<br />\r\n','1','Delete page line for Special page edit form.','Admin Pages','default','en');
INSERT INTO blocks VALUES ('special_edit_upload','%%upload_form%%','1','Formatting for upload form for special page edit form.\r\n<p>\r\nKeys:\r\n<ul>\r\n<li> |upload_form|: The actual form to include.\r\n</ul>','Admin Pages','default','en');
INSERT INTO blocks VALUES ('special_edit_spellcheck','<input type=\"checkbox\" name=\"spell_check\" value=\"1\"%%splchk_checked%% /> Spellcheck this page<br />','1','Spellcheck option for special page edit form.\r\n<p>\r\nKeys: \r\n<ul>\r\n<li> |splchk_checked|: Checked indicator\r\n</ul>','Admin Pages','default','en');

UPDATE ops SET urltemplates = 'EVAL{\r\n  my $caller = $S->cgi->param(\'caller_op\');\r\n  my $p = {};\r\n  $p->{op}  = \'special\';\r\n  \r\n  if ($caller eq \'special\') {\r\n	$p->{page} = $path[0];\r\n  } else {\r\n    $p->{page} = $caller;\r\n  }\r\n  \r\n  return $p\r\n}' WHERE op = 'special';