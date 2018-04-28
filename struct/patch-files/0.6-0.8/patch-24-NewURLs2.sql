DELETE FROM blocks WHERE bid = 'op_aliases' OR bid = 'op_templates';
INSERT INTO blocks VALUES ('op_aliases','queue=modsub,\r\nmoderate=modsub,\r\nforumzilla=fz,\r\nstory=displaystory,\r\nsubmit=submitstory,\r\nwhois=user,\r\nmy=user,\r\ncomment=comments,\r\nfind=search,\r\nviewpoll=view_poll,\r\npoll=view_poll,',NULL,NULL);
INSERT INTO blocks VALUES ('op_templates','displaystory.length=6:/mode/sid{5}/,\r\ndisplaystory=/sid{5}/,\r\n\r\nuser=EVAL{\r\n  my $p = {};\r\n  if ($S->cgi->param(\'caller_op\') eq \'my\') {\r\n    unshift @path\\, $S->{NICK};\r\n  }\r\n  my $uid;\r\n  if ($path[0] =~ /uid:/) {\r\n    $path[0] =~ s/^uid://;\r\n    $uid = $path[0];\r\n    $path[0] = $S->get_nick_from_uid($uid);\r\n  } else {\r\n    $uid=$S->get_uid_from_nick($path[0]); \r\n  }\r\n  if ($path[1] eq \'edit\') { $path[1] = \'prefs\' }\r\n  if ($path[1] eq \'diary\') {\r\n    $p = {\r\n      op      => \'section\'\\,\r\n      user    => \"diary_$uid\"\\,\r\n      section => \'Diary\'\\,\r\n      page    => $path[2]\r\n    };\r\n  } elsif ($path[1] =~ /comment/) {\r\n    $p->{op}      = \'search\';\r\n    $p->{type}    = \'comment_by\';\r\n    $p->{string}  = $path[0];\r\n  } elsif ($path[1] eq \'stories\' || $path[1] eq \'story\') {\r\n    $p->{op}      = \'search\';\r\n    $p->{type}    = \'author\';\r\n    $p->{string}  = $path[0];\r\n  } else {\r\n    $p->{op}      = \'user\';\r\n    $p->{tool}    = $path[1];\r\n    $p->{nick}    = $path[0];\r\n  }\r\n  return $p;\r\n},\r\n\r\nsearch.length=2:/type/string/,\r\nsearch=/string/,\r\n\r\nsection=/section/page/,\r\n\r\nspecial=/page/,\r\n\r\nsubmitstory=/section/,\r\n\r\ninterface=/tool/,\r\n\r\nview_poll=/qid/,\r\n\r\nhotlist=/tool/sid{5}/new_op/page/section/,\r\n\r\ncomments.1=poll:/null/sid/cid/tool/,\r\ncomments.length=2:/sid/cid/,\r\ncomments.length=3:/sid/cid/tool/,\r\ncomments=/sid{5}/cid/tool/,\r\n\r\nadmin.1=story:/tool/sid{5}/,\r\nadmin.1=editpoll:/tool/editqid/option/,\r\nadmin.1=vars:/tool/cat/,\r\nadmin.1=blocks:/tool/bid/,\r\nadmin.1=topics:/tool/tid/,\r\nadmin.1=sections:/tool/section/,\r\nadmin.1=special:/tool/id/,\r\nadmin.1=boxes:/tool/id,\r\nadmin.1=optemplates:/tool/opcode,\r\nadmin.1=groups:/tool/perm_group_id/,\r\nadmin.1=rdf:/tool/action/write=1/,\r\nadmin.1=cron:/tool/action/which/write=1/,\r\nadmin=/tool/,\r\n\r\nprint=/sid{5}/,\r\n\r\nfzdisplay=/action/sid{5}/cid/,\r\n\r\nnewuser=/tool/uname/confirm/,\r\n\r\nmain=/page/,',NULL,NULL);

