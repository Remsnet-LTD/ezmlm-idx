0.324 - This version identifier must be on line 1 and start in pos 1.
#
#$Id: ezmlmrc.ru,v 1.4 1999/12/23 23:08:19 lindberg Exp $
#$Name: ezmlm-idx-040 $
#
# ezmlmrc 
# #######
# Controls the actions of ezmlm-make as patched with ezmlm-idx-0.31 or later.
#
# The base directory 'DIR' is always created by ezmlm-make, as is DIR/key.
# Everything else is done from here.
#
# ezmlm-make looks for this file, first as .ezmlmrc in the directory that the
# lists .qmail files will be placed in (if you've used the -c command line
# switch), then /etc/ezmlmrc, then ezmlmrc in the ezmlm-make binary directory.
# Thus, you can customize ezmlm-make on a global level by placing a customized
# copy of ezmlmrc in /etc and on a user level by copying it to .ezmlmrc in
# the user's home directory AND use the ezmlm-make -c switch.
#
# Tags are:
#	</filename/>       : put succeeding text lines in DIR/filename
#	</-filename/>      : erase DIR/filename.
#	</+dirname/>       : create directory DIR/dirname
#	</:lname/dirname>  : symlink DIR/.qmail-list-lname -> DIR/dirname
#
# The name in the tag can be suffixed with '#' and any number of flags,
# corresponding to command line switches. The item will be created/extended
# only if all the flags listed are set. Files can be extended as long as they
# were the last one created, but not if another file has been started since
# then. Flags that are not recognized are silently ignored.
# 
# Thus, </filename#aP/> creates the file if and only if the list is archived
# (-a) and not public (-P). If the next tag is </filename#m/>, the file is
# extended with the lines up to the next tag if the list is message moderated
# (-m). If the next tag is </another/>, 'filename' is closed. Any further
# tags leading to the reopenining of 'filename' will overwrite the file, not
# extend it.
#
# A set of user-defined command line switches (xX, yY, zZ) are available for
# customization.
#
# Within the text, certain tags are substituted. Other tags are copied as
# is. <#A#> and <#R#> are substituted by ezmlm-manage and -store (see man pages)
# and <#l#> (lower case L) is replaced dynamically by the list name for
# programs handling both 'list' and 'list-digest'.
#
# Substitutions are:
# <#B#> ezmlm binaries path   <#C#> digest code         <#D#> dir
# <#H#> host                  <#L#> local               <#F#> flags
# <#T#> dot                   <#0#> arg for -0. <#3#>...<#9#> arg for -3..9
# <#1#> ext1                  <#2#> ext2 [if dot is /path/.qmail-ext1-ext2-name]
# The latter useful when a single user is controlling several virtual domains.
#
# -0 is used for the main list address when setting up sublists
# -4 for specifying the ezmlm-tstdig switches used in dir/editor. Default
#    -k64 -m30 -t24. Only used if -g is used.
# -5 for list-owner address. Mail to list-owner will be forwarded to this addr.
# -6 for sql connection info
# -7 for contents of DIR/modpost
# -8 for contents of DIR/modsub
# -9 for contents of DIR/remote
#
# For demonstration purposes, the '-x' switch results in the following
# non-standard actions:
# - Removal of many non-text MIME parts from messages.
# - Limit posts to 2 bytes <= msg body size <= 40000
#
# Attempts to create links or directories that already exist, will result
# in a FATAL error. Attempts to open files that have already been closed
# or already exits, will cause the old file to be overwritten.
#
# One of the major problems with ezmlm-lists is DIR/inlocal. For normal
# users, it is set up to the list name (user-list or so), which is correct.
# However, for user 'ezmlm' in control of virtual domain 'host.dom.com'
# the list name is 'list@host.dom.com', but inlocal should be 'ezmlm-list',
# not 'list'. Similarly, if ezmlm-domain1 is in control of 'host.dom.com,
# list@host.dom.com, should yield an inlocal of 'ezmlm-domain1-list'. To
# always get the lists correct, place this file as '.ezmlmrc' in the 
# users home directory (~ezmlm/.ezmlmrc) and change the inlocal text below
# to 'ezmlm-<#L#>' or 'ezmlm-<#1#>-<#L#>, respectively.
# config to support future editing without giving ezmlm-make command line
# arguments other than dir. Useful for GUI/WWW editing tools
</config/>
F:<#F#>
D:<#D#>
T:<#T#>
L:<#L#>
H:<#H#>
C:<#C#>
0:<#0#>
3:<#3#>
4:<#4#>
5:<#5#>
6:<#6#>
7:<#7#>
8:<#8#>
9:<#9#>
</charset/>
# Charset file is a must for russian mailing lists
koi8-r
</inlocal/>
<#L#>
</sublist#0/>
<#0#>
</+archive/>
</+subscribers/>
</+bounce/>
</+text/>
# dirs for digests
</+digest#d/>
</+digest/subscribers#d/>
</+digest/bounce#d/>
# for extra address db
</+allow/>
</+allow/subscribers/>
# for blacklist
</+deny#k/>
</+deny/subscribers#k/>
# moderator db & mod queue dirs. Needed for -m, -r -s, so we just
# make them by default.
</+mod/>
</+mod/subscribers/>
</+mod/pending/>
</+mod/accepted/>
</+mod/rejected/>
# links: dot -> dir/editor
</:/editor/>
</:-owner/owner/>
</:-digest-owner/owner#d/>
</:-return-default/bouncer/>
</:-digest-return-default/digest/bouncer#d/>
</:-default/manager/>
# for message moderation only
</:-accept-default/moderator#m/>
</:-reject-default/moderator#m/>
# Get rid of configuration flags for editing mode so we can start with a
# clean slate.
</-modpost#eM/>
</-modsub#eS/>
</-remote#eR/>
</-public#eP/>
</-indexed#eI/>
</-archived#eA/>
</-prefix#eF/>
</-text/trailer#eT/>
</-sublist#e^0/>
</-mimeremove#eX/>
# Not needed, except for message moderation.
</-moderator#eM/>
# We don't clean out text files to make it easier for users
# doing manual config by e.g. touching dir/remote.
# subscription moderation
</modsub#s/>
<#8#>
# remote admin
</remote#r/>
<#9#>
# message moderation
</modpost#m/>
<#7#>
# List owner mail
</owner#5/>
<#5#>
</owner#^5/>
<#D#>/Mailbox
</#W/>
|<#B#>/ezmlm-warn '<#D#>' || exit 0
# Handles subscription. Add flags if you want a non-default digest format.
# Service subject commands to the # request address if the -q switch is given.
# Also -l and -d enable subscriber listing/text file editing, for remote adms.
# -u gives subscriber only archive access
</manager#iG/>
|<#B#>/ezmlm-get '<#D#>' <#C#>
</manager#ig/>
|<#B#>/ezmlm-get -s '<#D#>' <#C#>
</manager#q/>
|<#B#>/ezmlm-request '<#D#>'
# Ok to add -l/-d even for non-mod lists, since ezmlm-manage
# won't allow it unless there are remote admins.
</manager#LN/>
|<#B#>/ezmlm-manage '<#D#>'
</manager#lN/>
|<#B#>/ezmlm-manage -l '<#D#>'
</manager#Ln/>
|<#B#>/ezmlm-manage -e '<#D#>'
</manager#ln/>
|<#B#>/ezmlm-manage -le '<#D#>'
</manager#W/>
|<#B#>/ezmlm-warn '<#D#>' || exit 0
</#dW/>
|<#B#>/ezmlm-warn -d '<#D#>' || exit 0
</editor/>
# reject shouldn't be configured for sublist.
</#^0/>
# full reject is now default, to get To/Cc: listaddress requirement
|<#B#>/ezmlm-reject '<#D#>'
# -k => reject posts from blacklisted addresses. Done for moderated
# lists as well - allows removal of unwanted noise.
</#k^0/>
|<#B#>/ezmlm-issubn -n '<#D#>/deny' || { echo "Sorry, I've been told to reject your posts. Contact <#L#>-owner@<#H#> if you have questions about this (#5.7.2)"; exit 100 ; }
# switch -u=> restrict to subs of list & digest. If not m
# do it with ezmlm-issubn, if 'm' do it with ezmlm-gate
</#uM/>
|<#B#>/ezmlm-issubn '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod' || { echo "Sorry, only subscribers may post. If you are a subscriber, please forward this message to <#L#>-owner@<#H#> to get your new address included (#5.7.2)"; exit 100 ; }
</#um/>
|<#B#>/ezmlm-gate '<#D#>' '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod'
# For message moderation, editor has store/clean
</#mU/>
|<#B#>/ezmlm-store '<#D#>'
|<#B#>/ezmlm-clean '<#D#>' || exit 0
</#mu/>
|<#B#>/ezmlm-clean -R '<#D#>' || exit 0
# for non-message moderated lists, it has send
</#M/>
|<#B#>/ezmlm-send '<#D#>'
# all lists have warn unless -w.
</#W/>
|<#B#>/ezmlm-warn '<#D#>' || exit 0
# for digest bounces
</#dW/>
|<#B#>/ezmlm-warn -d '<#D#>' || exit 0
</#d^4/>
|<#B#>/ezmlm-tstdig -m30 -k64 -t48 '<#D#>' || exit 99
</#d4/>
|<#B#>/ezmlm-tstdig <#4#> '<#D#>' || exit 99
</#d/>
|<#B#>/ezmlm-get '<#D#>' || exit 0
# bouncer is complicated. We use ezmlm-receipt if -6 AND -w, but ezmlm-return
# if (-6 and -W) OR (not -6 and -w). Since there is no or, we need 2 lines.
</bouncer/>
|<#B#>/ezmlm-weed
</#^6/>
|<#B#>/ezmlm-return -D '<#D#>'
</#6W/>
|<#B#>/ezmlm-return -D '<#D#>'
</#6w/>
|<#B#>/ezmlm-receipt -D '<#D#>'
</digest/bouncer#d/>
|<#B#>/ezmlm-weed
</#^6d/>
|<#B#>/ezmlm-return -d '<#D#>'
</#6Wd/>
|<#B#>/ezmlm-return -d '<#D#>'
</#6wd/>
|<#B#>/ezmlm-receipt -d '<#D#>'
# moderator is set up only for message moderated lists. However, '-e' does
# not remove it since we can't remove the symlinks to it (they're outside
# of the list dir.
</moderator#m/>
|<#B#>/ezmlm-moderate '<#D#>'
</#mU/>
|<#B#>/ezmlm-clean '<#D#>' || exit 0
</#mu/>
|<#B#>/ezmlm-clean -R '<#D#>' || exit 0
</headerremove#E/>
return-path
return-receipt-to
content-length
precedence
x-confirm-reading-to
x-pmrqc
# Only one allowed
list-help
list-unsubscribe
list-post
</lock/>
</lockbounce/>
</digest/lockbounce#d/>
</digest/lock#d/>
</public#p/>
</archived#a/>
</indexed#i/>
</inhost/>
<#H#>
</outhost/>
<#H#>
</outlocal/>
<#L#>
</mailinglist/>
contact <#L#>-help@<#H#>; run by ezmlm
# Headeradd needs to always exist
</headeradd#E/>
# Good for mailing list stuff (and vacation program)
Precedence: bulk
# To prevent indexing by findmail.com
X-No-Archive: yes
# rfc2369
List-Help: <mailto:<#l#>-help@<#h#>>
List-Unsubscribe: <mailto:<#l#>-unsubscribe@<#h#>>
List-Subscribe: <mailto:<#l#>-subscribe@<#h#>>
List-Post: <mailto:<#L#>@<#H#>>
X-Comment: <#l#> mailing list (Russian, KOI8-R)
# max & min message size
</msgsize#x/>
40000:2
# remove mime parts if -x
</mimeremove#x/>
application/excel
application/rtf
application/msword
application/ms-tnef
text/html
text/rtf
text/enriched
text/x-vcard
application/activemessage
application/andrew-inset
application/applefile
application/atomicmail
application/dca-rft
application/dec-dx
application/mac-binhex40
application/mac-compactpro
application/macwriteii
application/news-message-id
application/news-transmission
application/octet-stream
application/oda
application/pdf
application/postscript
application/powerpoint
application/remote-printing
application/slate
application/wita
application/wordperfect5.1
application/x-bcpio
application/x-cdlink
application/x-compress
application/x-cpio
application/x-csh
application/x-director
application/x-dvi
application/x-hdf
application/x-httpd-cgi
application/x-koan
application/x-latex
application/x-mif
application/x-netcdf
application/x-stuffit
application/x-sv4cpio
application/x-sv4crc
application/x-tar
application/x-tcl
application/x-tex
application/x-texinfo
application/x-troff
application/x-troff-man
application/x-troff-me
application/x-troff-ms
application/x-ustar
application/x-wais-source
audio/basic
audio/mpeg
audio/x-aiff
audio/x-pn-realaudio
audio/x-pn-realaudio
audio/x-pn-realaudio-plugin
audio/x-realaudio
audio/x-wav
image/gif
image/ief
image/jpeg
image/png
image/tiff
image/x-cmu-raster
image/x-portable-anymap
image/x-portable-bitmap
image/x-portable-graymap
image/x-portable-pixmap
image/x-rgb
image/x-xbitmap
image/x-xpixmap
image/x-xwindowdump
text/x-sgml
video/mpeg
video/quicktime
video/x-msvideo
video/x-sgi-movie
x-conference/x-cooltalk
x-world/x-vrml
# These can also be excluded, but for many lists it is desirable
# to allow them. Uncomment to add to mimeremove.
# application/zip
# application/x-gtar
# application/x-gzip
# application/x-sh
# application/x-shar
# chemical/x-pdb
# --------------------- Handle SQL connect info
</-sql#^6e/>
</-digest/sql#^6e/>
</-allow/sql#^6e/>
</sql#6W/>
<#6#>
</sql#6w/>
<#6#>:<#L#>@<#H#>
</digest/sql#6dW/>
<#6#>_digest
</digest/sql#6dw/>
<#6#>_digest:<#L#>_digest@<#H#>
</allow/sql#6/>
<#6#>_allow
# -------------------- End sql stuff
</prefix#f/>
[<#L#>]
</text/trailer#t/>
-- 
To unsubscribe, e-mail: <#L#>-unsubscribe@<#H#>
For additional commands, e-mail: <#L#>-help@<#H#>
</text/bottom/>

--- ������� ������ �������� <#l#>@<#H#> ---

��� ������� �������������� �������������. ����������,
�� ��������� �� �� ����� ������ ������, ��� ��� ����������
�� �����, � ��� �������� ����������. �������� ��������
������ (���������� �� ��� ����������), ��������� ��
���� �� ���������������� �������:

����� ��� ��������:
   <<#L#>-subscribe@<#H#>>

����� ��� ������ �� ��������:
   <<#L#>-unsubscribe@<#H#>>

��� ��������� ������ ������ �������� � FAQ:
   <<#L#>-info@<#H#>>
   <<#L#>-faq@<#H#>>

</#d/>
��� �� �������������� � ���������:
   <<#L#>-digest-subscribe@<#H#>>
   <<#L#>-digest-unsubscribe@<#H#>>

# ezmlm-make -i needed to add ezmlm-get line. If not, we can't do
# multi-get!
</text/bottom#ai/>
����� �������� ��������� � 123 �� 145 (max 100 �� ������), ������ ����:
   <<#L#>-get.123_145@<#H#>>

</text/bottom#aI/>
��� ��������� ������ #12 �� ������ ������� ������ �� ������:
   <<#L#>-get.12@<#H#>>

</text/bottom#i/>
����� ��� ��������� ������� � subject � �������� ����� 123-456:
   <<#L#>-index.123_456@<#H#>>

# Lists need to be both archived and indexed for -thread to work
</text/bottom#ai/>
����� ��� ��������� ��� �����, ��������� � ������� #12345:
   <<#L#>-thread.12345@<#H#>>

# The '#' in the tag below is optional, since no flags follow.
# The name is optional as well, since the file will always be open
# at this point.
</text/bottom#/>
���������� ����� ���� �� ������, ����� ���� �����, �� �������
�� ��������� ������.

</text/bottom/>
���� ������ �� ��������, �� ������ ��������� � ����������
������ �������� �� ������ <#L#>-owner@<#H#>. 
</text/bottom/>

--- ���� ��������� ����� �������

</text/bounce-bottom/>

--- ���� ��������� ����� ��������� �� ������

</text/bounce-num/>

�������� �������� ������ ����� �� <#L#>, ������� �� ����� ��
������ ������ (�.�. �� ��� ���� �������� ��������� �� ������)

</#a/>
����� ���� ����� ��������� � ������.
</#aI/>
����� �������� ������ 12345 �� ������, ������� ������ �� ������:
   <<#L#>-get.12345@<#H#>>

</#ia/>
����� ��� ��������� ��������� 123-145 (max 100 �� ������):
   <<#L#>-get.123_145@<#H#>>

����� ��� ��������� ������ ��������� 100 ��������� � subject � �������:
   <<#L#>-index@<#H#>>

<//>
H����� ���������:

</text/dig-bounce-num/>

�������� ��������� ������ ���������� <#L#>, ������� �� ����� �� ������
������ (�.�. �� ��� ���� �������� ��������� �� ������). ���� ���������
�� ��������, �� �������� ������ ����� � ����������. ����� �������
����� ��������� ����������� ������ �� ������.

</#aI/>
����� �������� ������ 12345 �� ������, ������� ������ �� ������:
   <<#L#>-get.12345@<#H#>>

</#ia/>
����� ��� ��������� ��������� 123-145 (max 100 �� ������):
   <<#L#>-get.123_145@<#H#>>

����� ��� ��������� ������ ��������� 100 ��������� � subject � �������:
   <<#L#>-index@<#H#>>

<//>
��������� ������ ����� � ����������:

</text/bounce-probe/>

��������� �� ������ �������� <#l#>@<#H#> �� ��� �����
�������� � ������� �������� (bounce). ��� ���� ������� ������ �
���������������, �� ��� ���� �� ���� ����������. � ����� ������
��������� ����� ��������� �� ������.

��� ������ �������� ������ �� ������������� � ���������� ������ 
������. ���� ������� ��������� ��� ��� ������ ��� �� ����� ��������,
��� ����� ����� ������ �� ������ �������� <#l#>@<#H#> ��� ����������
��������������. ����������� ������ ����� �� ������:
   <<#l#>-subscribe@<#H#>>

</text/bounce-warn/>

��������� �� ������ �������� <#l#>@<#H#> �� ��� �����
�������� � ������� �������� (bounce). � ����� ������ ��������� �����
��������� �� ������.

���� ��� ������ ��� �� �������� � ������, ��� ����� ������ ����. ����
���� ���� �������� � ������, ��� ����� ����� ������ �� ������ ��������
<#l#>@<#H#> ��� ���������� ��������������.

</text/digest#d/>
����� ��� �������� �� ��������:
	<#L#>-digest-subscribe@<#H#>

����� ��� ������� �� ���������:
	<#L#>-digest-unsubscribe@<#H#>

����� ��� �������� ����� � ������ ��������:
	<#L#>@<#H#>

</text/get-bad/>
��������, �� ������ ������ � ������ ���.

</text/help/>
��� ������ �������� ����� ��������� ������ ezmlm.

</text/mod-help/>
�������, ��� �� ����������� ������������ <#L#>@<#H#>.

������� ezmlm ������� ���������� �� ������ ������ �������
�������� ��� majordomo, listserver, etc, �� ��� �����
������������ � �� ����� ������������.

H��� ��������� ��������� �� ���������� �����, ����������� 
��������� ������ �/��� ����������.

��������� ��������
------------------
��� ���������, �� ������ ��������� ��� �������� ����� �����
� ������. ��� �������� ������ john@host.domain ��������
������� ����� �������, ����� ����� � = ������ @. H�������,
��� �������� �������������� ������, ������� ������� ������
�� ������
   <<#L#>-subscribe-john=host.domain@<#H#>>

����� ��� �� ����� ������� ����� �� ������:
   <<#L#>-unsubscribe-john=host.domain@<#H#>>

</#d/>
�� �� ����� ��� ����������:
   <<#L#>-digest-subscribe-john=host.domain@<#H#>>
   <<#L#>-digest-unsubscribe-john=host.domain@<#H#>>

<//>
��� � ���. H� ��������� ������ ��������� �� � subject, �� � ���� ������.

</#r/>
��� ����� ������ ������ �� �������������, ������������� �� �� ������
��������� ��������/�������. H��� ������ �������� �� ����.
</#R/>
����� ������ ������ �� ������������� �������� �� ������ <john@host.domain>.
������������ ���������� ����� �������� �� ������.
<//>

������� ������������� ��������� ����������, ����� �� ���� ���������������
����������� �������� ��� ������� ����� � ������ ��� ������� ���������
������.

��������
--------

����� ������������ ����� ����������� ��� ����������,
������ ������ �� ��������������� �����:

<#L#>-subscribe@<#H#>
<#L#>-unsubscribe@<#H#>

</#d/>
��� ����������:

<#L#>-digest-subscribe@<#H#>
<#L#>-digest-unsubscribe@<#H#>

<//>
������������ ������� ������ �� �������������, ����� ���������
� ���, ��� ������ ��� ������ ������ ��. 

</#s/>
��������� � ������ ������ �������������� ��������/�������,
����� ������ �������������� ������ ����������. ���������
������������ ��� ���������� ���� �������, ��, ��� ���������,
������ ���� �������, ��� ��� ������ ��� �������, � �����
����������. ���� �� �������� � ��������� ������� ������������,
������ ������� ����� �� ������ ������. ���� ���, �� �������
��� � ���.

</#S/>
������� �������� ����� �� �������.
<//>

������������ ��� �� ����� ������������ ������:

   <<#L#>-subscribe-mary=host.domain@<#H#>>
   <<#L#>-unsubscribe-mary=host.domain@<#H#>>

��� �������� mary@host.domain. ������ ����� ������� ������ ����
���-�� �� ���� ������ ������� �� ������.

��� ����� � ������ ���������� �� ����� �������� ����������, �����
��� �� ������� ��������� ������ ��� ��������.

</#rl/>
����� �������� ������ ����������� <#L#>@<#H#>, ������� ������ ����:
   <<#L#>-list@<#H#>>

����� �������� ��� ���������� <#L#>@<#H#>, ������ ����:
   <<#L#>-log@<#H#>>

</#rld/>
��� ����������:
   <<#L#>-digest-list@<#H#>>
�:
   <<#L#>-digest-log@<#H#>>

</#rn/>
�� ������ ������������� �� ����� ��������� ����� ������������
������ ��������. ��� ��������� ������ ������ � ���������� ��
��������������, ������ ����:
   <<#L#>-edit@<#H#>>

</#m/>
�������������
-------------
����� ������ �������� ������������, ������ ����������� � ����
����������� ���������� ����� ������ � �����������. Subject ��������
������ "MODERATE for ...".

������ �������� ��� ���������: "From:" � "Reply-To:". ����� �������,
����� �� �� ���� ���������, ���� �������� ��������� ������ ��������,
�� ����� �� ������� ��������. ����� �� ����� � Reply-To: ��������
� ����, ��� �������� ������ ����� ��������� � ������ ��������. 
����� �� "From:" �������� � ������. ������ ��������� ����������
"��/���", �.�. �� ������ �������, ���������� ��� ���, ���������
����� � ��������� "��" ��� "���". ���������� ������ ������
����������� ������������ -- �������� ����� ������ ������, ������
��� ������ ����� �������� � ���� ������ ����� ����� ����� ��������,
������������� � �������� %. ���� ����� ����� ������ ����������� 
������, �� �������� ��� �� ����������� ��� ������. H�������:

%%% Start comment
���� ������ �������� ���
%%% End comment

���� ���� �������� ��������� ����� �������� � ����������� (��������,
The Bat!), �� ��� ������ ����� �������� � �������� ������.

������� �� ������������� �������������� �� ������� ������ �� ����������,
��������������� ������. ���� ���-�� �� ����������� ����� ������ �����
� ��������������� ��������, ��� ����� �������� � ���, ��� ��� ���������
� ������ �������.

���� � ������� ���������� ���� �� ����� �������� ������ �� �� ������
����������, ����������� ����� ������� ����������� � ��������. ��� ��,
������������� ������ ����� ��������� ������� �������� �����������.
<//>

��������
--------
���� �� ������ ������ �������� ���� ������� �����, � ���, ����
�� ���������, ��������� ��� � �� �����������, �� ������ �� �����
�������� �������������� ������� ����� � ������. ������ �� ������
������� �������� �������� ����� �������� � �������.

��� ����� ���������� ��������� ������������ �� ����� ������,
������������ ��� ������ � subject "MODERATE for .." �� ����� � 
��������� "Reply-To:". H� ������H������. 

</#r/>
���� �� ���������� ������� ��������������� ������ �� � ������ ������,
�� ���������, � �� �� ����� �������, ����������� ��� ���. ��� �������
��� ����, ����� ����� �� ������ ���������� ������ �� �������� 
�� ������ ������, �������� ������ ����� �� ����������������� ������
��������.

<//>

�����!

PS: � ������ ������� ������������ � ���������� ������ 
�������� (<#L#>-owner@<#H#>).

</text/mod-reject/>
��������, �� ���� ������ (���� �����������) �� ���� ��������� �
������ �����������. ���� ��������� �����(�) �������� ���-���� ���
�� ������ ������ ������, ����������� ����� ��������� ����.
</text/mod-request/>
H�������������� ������ ���� ���������� � ������ <#L#>@<#H#>
���� �� �������� ��� ����������, ������� ������ �� ������:

!A

������ ��� ����� ���������� ������ ������ "reply" ��� "�����" ���
������� ������. ����������� ���������, ����� � ���� "To:" ��� ������
���� �����. ���� ��� �� ���������, ���������� ����� � clipboard �
�������� ��� � ���� "To:". 
</#x/>
<//>

��� ������ �� �������� ������ � ��������� �� ���� �������� �������
������ �� ������

!R
</#x/>
<//>

��� �� ����� ���������� ���� ��������� ������. ��� ����, ����� �������
��� ����������� �� ������ ����, ������ ������ �� ���� ���������,
�������� ��� ����� ����� ����� �������� � %%%.

%%% Start comment
%%% End comment

����������� ������ ���������� � ������ ������.

--- �������� ������ � ������.

</text/mod-sub#E/>
--- ��� ��������� ��� �������� �� ������� ���������� 
������ �������� <#l#>@<#H#>.

���� �� ����� �� ������, �� ������ �������� ������
��������� ������ �� ������ <#l#>-owner@<#H#>.

���� ��� ���������� ���������� � ������ �������� <#L#>,
������� ������ ������ �� ������ <#l#>-help@<#H#>.

</text/mod-timeout/>
��������, �� ���������(�) ������ �������� <#L#>@<#H#>
�� ������������� �������� ��� �������� ��� ������ �� ������ 
������ ������ � ������.

--- �������� ������.

</text/mod-sub-confirm/>
��� ������ ������ ���������� �� ���������� ������

!A

� ������ �������� <#l#>@<#H#>. 
������ ��������� ������, ��� �� (��� �� ��) ���������� 
��������� ��� ����� �� �������������� ������ ��������.

��� ������������� ��������, ������� ������ ������ �� ������:

!R

��� ����� ���������� ������ ������ "reply" ��� "�����".
���� ��� �� ���������, ���������� ����� � clipboard � 
�������� ��� � ���� "To:".
</#x/>
<//>

���� �� �� ������ �������������, ������ �� ��������� �� ��� ������.

</text/mod-unsub-confirm/>
������ �� ���������� ��������

!A

�� ������ �������� <#l#>@<#H#>. ���� �� ��������, 
������� ������ ������ �� ������:

!R

��� ����� ���������� ������ ������ "reply" ��� "�����".
���� ��� �� ��������, ���������� ����� � �������� ��� � 
���� "To:" ������ ������.
</#x/>
<//>

���� �� �� ��������, ����������� ��� ������.

</text/sub-bad/>
��. ��� ������������� �����������.

������ ����� ������ ������� ����� ������� ����� ��������� ����
�������. �������� 10 ����. ��� �� ��������, ��� ���� ��������
��������� ����� ����� ������, ������� � �������� ��� �������������.

��� ��� ������ ����� ��� �������������. ����� �������� ��������

!A

�� ������ �������� <#l#>@<#H#>, ������� ������
������ �� ������:

!R
</#x/>
<//>

����������� ��������� �����, �� ������� �� ��������� �������������.

</text/sub-confirm/>
��� ������������� �������� ������

!A

�� ������ �������� <#l#>@<#H#>, ������� ������ ������ �� ������:

!R

��� ����� ���������� ������ ������ "reply" ��� "�����".
</#x/>
<//>

��� ������������� ���������� �� ���� ��������. ��-������, �����������,
������� �� ����� �� ������ ������. ��-������, ��� �������� ��� ��
��������, ���� ���-�� ������ ������ � ����������� ����� �������� �������.

</#q/>
H�������� ������ �������� ��������� �� ����� ��������� � ��������
��������. ���� �� �� ������ ������� ����� �� ������ ������, �������
����� �� <<#L#>-request@<#H#>> � �������� 
���� ����� � ���� subject.

</text/sub-confirm#s/>
���� ������ ������������. ����� �� ������� �������������, ���������(�)
����� �������� �� ����. � ������ ��������� ����� �������� �����������
��� ����� ��������.

</text/sub-nop/>
�������������: �����

!A

��� �������� �� ������ �������� <#l#>@<#H#>.

</text/sub-ok#E/>
�������������: �����

!A

�������� �� ������ �������� <#l#>@<#H#>.

����� ����������!

����������, ��������� ��� ������, ����� �� ������ �����, �������
�� ��������� �� ������ ��������. ����� ������� �� ��� �����������
��������, � ���������� �� ��������, �� ���� �������� �����, �����
����� ������.

</text/top/>
������ ����/����/�����! ��� ��������� �� ��������� ezmlm,
���������� ������� �������� <#l#>@<#H#>.

</#x/>
��������� � ���������� ������ �������� ����� �� ������
<#l#>-owner@<#H#>.

</text/unsub-bad/>
��. ��� ������������� �����������.

������ ����� ������ ������� ����� ������� ����� ��������� ����
�������. �������� 10 ����. ��� �� ��������, ��� ���� ��������
��������� ����� ����� ������, ������� � �������� ��� �������������.

��� ��� ������ ����� ��� �������������. ����� �������� ��������
������

!A

�� ������ �������� <#l#>@<#H#>, ������� ������ ������ �� ������:

!R
</#x/>
<//>

����������� ��������� �����, �� ������� �� ��������� �������������.

</text/unsub-confirm/>
��� ������������� �������� ������

!A

�� ������ �������� <#l#>@<#H#>, ������� ������ ������ �� ������:

!R

��� ����� ���������� ������ ������ "reply" ��� "�����".
</#x/>
<//>

��������! ����� ������, ��� ����� ������� �� ��������� �� ������
��������, ��������� � ��������� ������ �� ����� �� ������. �
������ ������ ���� ��������� "Return-Path:", ������ �������
��������� ����� ����������. H�������, ��� ������ vassily.pupkin@usa.net
��������� ����� ��������� ���:
Return-Path: <<#l#>-return-<�����>-vassily.pupkin=usa.net@<#H#>

</#q/>
H�������� ������ �������� ��������� �� ����� ����������� � ��������
��������. ���� �� �� ������ ������� ����� �� ������ ������, �������
����� �� <<#L#>-request@<#H#>> � �������� 
���� ����� � ���� subject.

</text/unsub-nop/>
��������: �����

!A

�� �������� �� ������ �������� <#l#>@<#H#>!

���� �� ������������� �� ������, �� ����������� �������� ���������,
������ �� ��������� ��� ������ �������. H������ ��������� ����

'Return-Path: <<#l#>-return-1234-user=host.dom@<#H#>>'

� ����� �� ����� �����. ��� ������� ���� ����� ������� ������ �� ������
'<#l#>-unsubscribe-user=host.dom@<#H#>'. ������ ����������� �����
�����, ������� user=host.dom �� ���� �������� ������ (��������� ������
= ������ @) � �������� �� �������������.

</text/unsub-ok/>
�������������: �����

!A

������ �� ������ �������� <#l#>@<#H#>.

</text/edit-do#n/>
����������, �������������� ��������������� ���� � ��������� ���
�� ������:

!R

��� ����� ���������� ������ ������ "reply" ��� "�����".

������� �������� ����� ������� �� ������ �������������, ����
�� �� ������ ������� ������ � ���������. ������� -- ������,
������������ � %%%. 

</text/edit-list#n/>
����� <#L#>-edit.file ������������ ��� ���������� ��������������
��������� ������, ������� �������� ��������� ������� ������
�������� <#L#>@<#H#>.

���� �������� ������ ���� ������ � �������� �������� �������
������� �� ���. ��� �������������� ������-���� �� ���� ������
������ ������� ������ �� ������ #L#>-edit.��������. ��� �����
������� ������� ���������� ����� � ���������� ���������� �� 
��������������.

����                ����������

bottom              ������ ����� ������, ����� ����������.
digest              '����������������' ����� ��� ����������.
faq                 ����� ���������� ������� � ������ ��� ������ ��������.
get_bad             ��������� �� ���������� ������ � ������.
help                ����� ����� (����� 'top' � 'bottom').
info                ���������� � ������. ������ ������ �������� ����������.
mod_help            ��� ��� ������������� ������� ������ ��������.
mod_reject          ����� ������ � �������� ���������.
mod_request         ����� ������� �� ��������� ������.
mod_sub             ������������� ������������ ��������.
mod_sub_confirm     ������ ���������� � �������� ������������.
mod_timeout         ��������� � "���������" ������ � ������� �� ���������.
mod_unsub_confirm   ������ �� ��������� ������� ������������ ����������.
sub_bad             ����������, ��� ������������ ������-�������������.
sub_confirm         ������ �� ������������� �������� ������������.
sub_nop             ���� ������������ ��� ��������.
sub_ok              ��� �������� ��������.
top                 ������� ����� ���� �������.
</#tn/>
trailer             �����, ����������� � ����� ������� ������ � ������.
</#n/>
unsub_bad           ���������� ��� ��������� �������.
unsub_confirm       ������ �� ������������� ������� ������������.
unsub_nop           ��-���������� � ���, ��� ��� ������ � ������ ���.
unsub_ok            ��� �������� �������.

</text/edit-done#n/>
��������� ���� ��� ������� �������� �� �������.
</text/info#E/>
����� �������������� ������ ��������, ����� ���.
</text/faq#E/>
FAQ, ��� ���� -- ����� ���������� ������� � ������.

����� ���� �����. ����� ���-������ �������?

