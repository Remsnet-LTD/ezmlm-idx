#$Id$
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
# Explicitly specify character-set, when this ezmlmrc was used.
# Use Quoted-Printable to make averyone happy.
iso-8859-2:Q
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
|<#B#>/ezmlm-issubn -n '<#D#>/deny' || { echo "Omlov�m se, ale m�m p��kaz odm�tnout p��sp�vky od v�s. Kontaktujte <#L#>-owner@<#H#>, m�te-li dotazy k tomuto faktu (#5.7.2)"; exit 100 ; }
# switch -u=> restrict to subs of list & digest. If not m
# do it with ezmlm-issubn, if 'm' do it with ezmlm-gate
</#uM/>
|<#B#>/ezmlm-issubn '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod' || { echo "Omlouv�m se, ale do tohoto listu sm�j� p�isp�vat pouze p�ihl�en� u�ivatel�. Jste-li p�ihl�en�m u�ivatelem, p�epo�lete tuto zpr�vu na adresu <#L#>-owner@<#H#>, aby akceptoval va�i novou adresu (#5.7.2)"; exit 100 ; }
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
---------------------------------------------------------------------
Pro odhl�en�, po�lete mail na <#L#>-unsubscribe@<#H#>
Dal�� p��kazy vyp�e e-mail: <#L#>-help@<#H#>
</text/bottom/>

--- Administrativn� p��kazy pro list <#l#> ---

Um�m automaticky obsluhovat administrativn� p��kazy. Nepos�lejte
je pros�m do listu! Po�lete zpr�vu na adresu p��slu�n�ho p��kazu:

Pro p�ihl�en� do listu, po�lete e-mail na adresu:
   <<#L#>-subscribe@<#H#>>

Pro odhl�en� se z listu pou�ijte adresu
   <<#L#>-unsubscribe@<#H#>>

Informace o listu a FAQ (�asto kladen� dotazy) z�sk�te zasl�n�m dopisu
na n�sleduj�c� adresy:
   <<#L#>-info@<#H#>>
   <<#L#>-faq@<#H#>>

</#d/>
Podobn� adresy existuj� i pro list digest�:
   <<#L#>-digest-subscribe@<#H#>>
   <<#L#>-digest-unsubscribe@<#H#>>

# ezmlm-make -i needed to add ezmlm-get line. If not, we can't do
# multi-get!
</text/bottom#ai/>
Zpr�vy ��slo 123 a� 145 z arch�vu (maxim�ln� 100 zpr�v na jeden mail)
z�sk�te zasl�n�m zpr�vy na n�sleduj�c� adresu:
   <<#L#>-get.123_145@<#H#>>

</text/bottom#aI/>
Zpr�vu ��slo 12 z�sk�te pomoc� n�sleduj�c� adresy:
   <<#L#>-get.12@<#H#>>

</text/bottom#i/>
Seznam zpr�v se subjectem a autorem zpr�v 123-456 - e-mail:
   <<#L#>-index.123_456@<#H#>>

Tyto adresy v�dy vrac� seznam 100 zpr�v, maxim�ln� 2000 na jeden po�adavek.
Tak�e ve v��e uveden�m p��klad� ve skute�nosti dostanete seznam zpr�v 100-499.

# Lists need to be both archived and indexed for -thread to work
</text/bottom#ai/>
Pro z�sk�n� zpr�v se stejn�m subjectem jako zpr�va 12345 po�lete
pr�zdn� mail na adresu:
   <<#L#>-thread.12345@<#H#>>

# The '#' in the tag below is optional, since no flags follow.
# The name is optional as well, since the file will always be open
# at this point.
</text/bottom#/>
Zpr�vy ve skute�nosti nemus� b�t pr�zdn� - budu jejich obsah ignorovat.
Jedin� d�le�it� v�c je ADRESA na kterou mail pos�l�te.

M��ete se tak� do listu p�ihl�sit pod jinou adresou - nap��klad
"pepa@domena.cz". Sta�� p�idat poml�ku a novou adresu s rovn�tkem (=)
nam�sto zavin��e:
<<#L#>-subscribe-pepa=domena.cz@<#H#>>

Odhl�sit tuto adresu lze pomoc� mailu na adresu
<<#L#>-unsubscribe-pepa=domena.cz@<#H#>>

V obou p��padech po�lu ��dost o souhlas na tuto adresu. Kdy� ji dostanete,
jednodu�e na ni odpov�zte a va�e p�ihl�en�/odhl�en� se dokon��.

</text/bottom/>
Pokud nedos�hnete po�adovan�ch v�sledk�, kontaktujte m�ho spr�vce
na adrese <#L#>-owner@<#H#>. Pros�m o trp�livost, m�j spr�vce je
podstatn� pomalej�� ne� j� ;-)
</text/bottom/>

--- P�ipojuji kopii po�adavku, kter� jsem dostal.

</text/bounce-bottom/>

--- P�ipojuji kopii zpr�vy, kter� se mi vr�tila.

</text/bounce-num/>

Uschoval jsem si seznam zpr�v z listu <#L#>, kter� se z va�� adresy
vr�tily.

</#a/>
Kopie t�chto zpr�v m��ete z�skat v arch�vu.
</#aI/>
Pro z�sk�n� zpr�vy 12345 z arch�vu, po�lete pr�zdn� mail na adresu
   <<#L#>-get.12345@<#H#>>

</#ia/>
Zpr�vy ��slo 123 a� 145 z�sk�te z arch�vu (maxim�ln� 100 zpr�v na jeden mail)
z�sk�te zasl�n�m zpr�vy na n�sleduj�c� adresu:
   <<#L#>-get.123_145@<#H#>>

Seznam zpr�v se subjectem a autorem zpr�v 123-456 - e-mail:
   <<#L#>-index@<#H#>>

<//>
N�sleduj� ��sla zpr�v:

</text/dig-bounce-num/>

Uschoval jsem ��sla digest� z listu <#L#>-digest, kter� se vr�tily
z va�� adresy. Pro ka�d� takov� digest jsem si zapamatoval ��slo
prvn� zpr�vy v digestu. Nearchivuji si digesty samotn�, ale
m��ete si vy��dat jednotliv� zpr�vy z arch�vu hlavn�ho listu.

</#aI/>

Pro z�sk�n� zpr�vy 12345 z arch�vu, po�lete pr�zdn� mail na adresu
   <<#L#>-get.12345@<#H#>>

</#ia/>
Zpr�vy ��slo 123 a� 145 z�sk�te z arch�vu (maxim�ln� 100 zpr�v na jeden mail)
z�sk�te zasl�n�m zpr�vy na n�sleduj�c� adresu:
   <<#L#>-get.123_145@<#H#>>

Seznam zpr�v se subjectem a autorem zpr�v 123-456 - e-mail:
   <<#L#>-index@<#H#>>

<//>
N�sleduj� ��sla prvn�ch zpr�v v digestech:

</text/bounce-probe/>

Vracej� se mi zpr�vy pro v�s z listu <#l#>.
Poslal jsem v�m varovnou zpr�vu, ale ta se tak� vr�tila.
P�ipojuji kopii varovn� zpr�vy.

Toto je testovac� zpr�va pro ov��en�, jestli je va�e adresa dosa�iteln�.
Pokud se tato zpr�va vr�t�, zru��m va�i adresu z listu <#l#>@<#H#>
bez dal��ho upozorn�n�. M��ete se p�ihl�sit znovu posl�n�m pr�zdn� zpr�vy
na adresu
   <<#l#>-subscribe@<#H#>>

</text/bounce-warn/>

Vracej� se mi zpr�vy pro v�s z listu <#l#>.
P�ipojuji kopii prvn� vr�cen� zpr�vy, kterou jsem dostal.

Pokud se tato zpr�va tak� vr�t�, po�lu testovac� zpr�vu.
Pokud se vr�t� i testovac� zpr�va, zru��m va�i adresu z listu <#l#>
bez dal��ho upozorn�n�.

</text/digest#d/>
Pro p�ihl�en� do digestu po�lete mail na adresu
	<#L#>-digest-subscribe@<#H#>

Pro odhl�en� z digestu pou�ijte adresu
	<#L#>-digest-unsubscribe@<#H#>

Chcete-li poslat zpr�vu do listu, pi�te na adresu
	<#L#>@<#H#>

</text/get-bad/>
Promi�te, ale tato zpr�va v arch�vu nen�.

</text/help/>
Toto je zpr�va se v�eobecnou n�pov�dou. Zpr�va, kterou jsem dostal,
nebyla posl�na na ��dnou z adres platn�ch pro zas�l�n� p��kaz�.

</text/mod-help/>
D�kuji, �e jste se uvoli moderovat nebo spravovat list <#L#>@<#H#>.

Moje p��kazy jsou pon�kud odli�n�j�� od jin�ch list�, ale mysl�m,
�e je sezn�te intuitivn�mi a p��jemn�mi k pou�it�.

Tady jsou instrukce pro �innosti, kter� p��padn� m��ete vykon�vat
jako spr�vce listu nebo moder�tor.

Vzd�len� p�ihl�en�
-------------------

Jako moder�tor m��ete p�ihla�ovat a odhla�ovat libovolnou adresu
do sv�ho listu. Pro p�ihl�en� u�ivatele "pepa@domena.cz" jednodu�e
dopl�te poml�ku za n�zev p��kazu a pak tuto adres s rovn�tkem
m�sto zavin��e. Nap��klad pro p�ihl�en� v��e uveden� adresy
po�lete mail na adresu
   <<#L#>-subscribe-pepa=domena.cz@<#H#>>

Podobn� m��ete odhla�ovat u�ivatele pomoc� mailu na adresu
   <<#L#>-unsubscribe-pepa=domena.cz@<#H#>>

</#d/>
Pro digestov� list:
   <<#L#>-digest-subscribe-pepa=domena.cz@<#H#>>
   <<#L#>-digest-unsubscribe-pepa=domena.cz@<#H#>>

<//>
To je v�echno. ��dn� speci�ln� subject ani obsah zpr�vy nen� pot�eba!

</#r/>
Po�lu v�m ��dost o potvrzen�, abych se ujistil, �e po�adavek
opravdu poch�z� od v�s. Jednodu�e odpov�zte na mail,
kter� obdr��te a v� p��kaz se vykon�.
</#R/>
Po�lu ��dost o potvrzen�, v tomto p��pad� na adresu <pepa@domena.cz>.
V�echno co bude muset ud�lat u�ivatel je odpov�d�t na tuto
��dost.
<//>

Potvrzen� jsou nezbytn�, aby se t�et�m stran�m co nejv�ce
zt�ila mo�nost p�id�vat a ru�it ciz� adresu do/z listu.

Uv�domuji u�ivatele, kdy� se stav jeho p�ihl�en� zm�n�.

P�ihl�en�
----------

Libovoln� u�ivatel se sm� p�ihla�ovat a odhla�ovat do/z listu
zasl�n�m zpr�vy na adresu

<#L#>-subscribe@<#H#>
<#L#>-unsubscribe@<#H#>

</#d/>
Pro digestov� list:

<#L#>-digest-subscribe@<#H#>
<#L#>-digest-unsubscribe@<#H#>

U�ivatel obdr�� ��dost o potvrzen�, abych se ujistil,
�e mu skute�n� dan� adresa pat��. Jakmile se toto ov���,
u�ivatel je odhl�en.

</#s/>
Proto�e toto je list s moderovan�m p�ihl�en�m, po�lu dal��
��dost o potvrzen� moder�torovi. Proto�e u�ivatel ji� potvrdil
p��n� b�t na listu, m��ete si jako moder�tor b�t dostate�n� jist,
�e adresa p�ihla�ovan�ho je skute�n�. Pokud chcete p�ijmout
u�ivatelovu ��dost, jednodu�e po�lete odpov�� na tuto zpr�vu.
Pokud ne, sma�te tuto zpr�vu a p��padn� kontaktujte u�ivatele
pro dal�� informace.
</#S/>
P�ihl��en� funguje stejn�.
<//>

U�ivatel tak� m��e pou��t adresu

   <<#L#>-subscribe-jana=domena.cz@<#H#>>
   <<#L#>-unsubscribe-jana=domena.cz@<#H#>>

pro zasl�n� mailu pro "jana@domena.cz". Pokud tato skute�n� m�
v��e uvedenou adresu, obdr�� ��dost o potvrzen� a m��e ji
potvrdit.

Va�e adresa a identita nen� otev�ena p�ihl�en�mu, pokud mu s�m
nepo�lete mail.

</#rl/>
Pro z�sk�n� seznamu p�ihl�en�ch pro list <#L#>@<#H#>, po�lete
zpr�vu na adresu
   <<#L#>-list@<#H#>>

Seznam proveden�ch transakc� listu <#L#>@<#H#> z�sk�te z adresy
   <<#L#>-list@<#H#>>

</#rld/>
Pro p�ihl�en� do digestu:
   <<#L#>-digest-list@<#H#>>
a
   <<#L#>-digest-log@<#H#>>

</#rn/>
M��ete vzd�len� editovat textov� soubory, ze kter�ch se sestavuj�
odpov�di, kter� pos�l�m. Chcete-li z�skat seznam editovateln�ch soubor�
a pokyny pro editaci, napi�te na adresu
   <<#L#>-edit@<#H#>>

</#m/>
Moderovan� p��sp�vky
--------------------

Pokud je list moderovan�, ulo��m si zpr�vy, kter� obdr��m a po�lu v�m
kopii a instrukce. Zpr�va pro v�s bude m�t subject "MODERATE for ...".

Chcete-li zpr�vu p�ijmout, sta�� poslat odpov�� (na adresu v "Reply-To:"),
kterou nastav�m na p��kaz pro p�ijet� zpr�vy do listu. Nemus�te 
pos�lat obsah p�vodn� zpr�vy. Ve skute�nosti ignoruji cokoli, co mi
po�lete, pokud bude adresa, na kterou to po�lete, korektn�.

Pokud chcete zpr�vu odm�tnout, po�lete odpov�� na adresu ve "From:",
kterou nastav�m na p��kaz pro odm�tnut� zpr�vy. Toto se obvykle ud�l�
p��kazem "Odpov�z v�em" ve va�em po�tovn�m klientovi, p�i�em�
sma�ete v�echny ostatn� adresy krom� adresy pro odm�tnut� (reject).
M��ete p�idat koment�� odes�lateli - napi�te jej mezi dva ��dky,
za��naj�c� t�ema znaky "%". Po�lu autorovi pouze tento koment��,
co� neprozrad� va�i identitu.

Se zpr�vou nalo��m podle prvn� odpov�di, kterou dostanu.
Uv�dom�m v�s, pokud mi po�lete po�adavek na potvrzen� ji�
odm�tnut� zpr�vy a naopak,

Pokud nedostanu odpov�� od moder�tora do ur�it� doby (implicitn� 5 dn�),
vr�t�m zpr�vu odes�lateli s vysv�tlen�m, �e byla odm�tnuta.
Jako administr�tor m��ete tak� list nastavit tak, �e ignorovan�
zpr�vy jsou jednodu�e smaz�ny bez upozorn�n� odes�lateli.
<//>

Dovolen�
--------
Pokud jste do�asn� na jin� adrese, sta�� si p�eposlat v�echny zpr�vy,
kter� maj� spr�vnou hlavi�ku "Mailing-List:" (nebo v�echny se subjectem
"MODERATE for <#L#>@<#H#>" (nebo "CONFIRM subscribe to <#L#>@<#H#>")
na novou adresu. M��ete tak� p�epos�lat tyto zpr�vy p��teli, kter�
bude moderovat za v�s. Pros�m uv�domte o tomto tak� spr�vce listserveru.

Pokud chcete automaticky potvrdit v�echny po�adavky b�hem sv� nep��tomnosti,
nastavte si po�tovn�ho klienta na pos�l�n� automatick�ch odpov�d� na zpr�vy,
kter� spl�uj� v��e uveden� krit�ria.

</#r/>
Pokud zkus�te d�lat vzd�lenou administraci z adresy, kter� nen�
va�e vlastn�, bude o potvrzen� po��d�n u�ivatel, nikoli vy.
Po schv�len� u�ivatelem po�lu ��dost o potvrzen� v�em moder�tor�m.
Toto d�l�m proto, �e nem�m zp�sob, jak zjistit, �e jste to skute�n� vy,
kdo poslal p�vodn� po�adavek.

Berte tak� na v�dom�, �e v tomto p��pad� je v� p�vodn� po�adavek
(v�etn� va�� adresy!) zasl�n u�ivateli s ��dost� o potvrzen�.
<//>

Mnoho �t�st�!

PS: Pros�m kontaktujte spr�vce listu (<#L#>-owner@<#H#>),
budete-li m�t dotazy nebo probl�my.

</text/mod-reject/>
Je mi l�to, ale va�e n�e citovan� zpr�va nebyla potvrzena moder�torem.
Pokud moder�tor p�ipojil n�jak� koment��, uv�d�m jej n�e.
</text/mod-request/>
N�e citovan� zpr�va byla zasl�na na adresu listu <#L#>@<#H#>.
Pokud souhlas�te s distribuc� t�to zpr�vy v�em p�ihl�en�m, po�lete
mail na adresu

!A

Toho obvykle dos�hnete pomoc� tla��tka "Odpov��/Reply". M��ete zkontrolovat
adresu, za��n�-li �et�zcem "<#L#>-accept". Pokud toto nefunguje, sta��
zkop�rovat adresu a ulo�it ji do pol��ka "To:" nov� zpr�vy.
</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#A#>
<//>

Chcete-li zpr�vu odm�tnout a zp�sobit jej� vr�cen� odes�lateli,
po�lete zpr�vu na adresu

!R

Toto se bvykle nejsn�ze ud�l� pomoc� tla��tka "Odpov�z v�em/Reply to all"
a n�sledn�ho vymaz�n� v�ech adres krom� t�, kter� za��n� "<#L#>-reject".
</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#R#>
<//>

Nen� t�eba kop�rovat zpr�vu ve sv�m potvrzen� nebo odm�tnut� t�to zpr�vy.
Chcete-li poslat koment�� odes�lateli odm�tnut� zpr�vy, dopl�te jej
mezi n�sleduj�c� ��dky za��naj�c� t�emi znaky "%":

%%% Za��tek koment��e
%%% Konec koment��e

D�kuji za spolupr�ci.

--- D�le uv�d�m zaslanou zpr�vu.

</text/mod-sub#E/>
--- P�ihl�sil nebo odhl�sil jsem v�s na ��dost moder�tora
listu <#l#>@<#H#>.

Pokud to nen� akce, se kterou souhlas�te, po�lete co nejd��ve
st�nost nebo dal�� koment��e spr�vci listu (<#l#>-owner@<#H#>).

Chcete-li z�skat podrobn�j�� n�vod pro pr�ci s listem <#L#>, po�lete
pr�zdnou zpr�vu na adresu
<#L#>-help@<#H#>.

</text/mod-timeout/>
Je mi l�to, ale moder�tor listu <#L#> nezareagoval na v� p��sp�vek.
Tento tedy pova�uji za odm�tnut� a vrac�m v�m jej. Pokud m�te pocit,
�e do�lo k chyb�, obra�te se p��mo na moder�tora listu.

--- D�le uv�d�m v�mi zaslanou zpr�vu.

</text/mod-sub-confirm/>
��d�m zdvo�ile opr�vn�n� p�idat adresu

!A

do seznamu �ten��� listu <#l#>. Po�adavek vze�el bu�to od v�s,
nebo ji� byl ov��en u potenci�ln�ho �ten��e.

Souhlas�te-li, po�lete pr�zdn� mail na adresu

!R

Toho obvykle dos�hnete pomoc� tla��tka "Odpov��/Reply". M��ete zkontrolovat
adresu, za��n�-li �et�zcem "<#L#>-sc". Pokud toto nefunguje, sta��
zkop�rovat adresu a ulo�it ji do pol��ka "To:" nov� zpr�vy.
</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#R#>
<//>

Nesouhlas�te-li, ignorujte tuto zpr�vu.

D�ky za spolupr�ci!

</text/mod-unsub-confirm/>
Obdr�el jsem po�adavek na zru�en� adresy

!A

z listu <#l#>. Souhlas�te-li, po�lete pr�zdnou odpov��
na tuto adresu:

!R

Toho obvykle dos�hnete pomoc� tla��tka "Odpov��/Reply". M��ete zkontrolovat
adresu, za��n�-li �et�zcem "<#L#>-sc". Pokud toto nefunguje, sta��
zkop�rovat adresu a ulo�it ji do pol��ka "To:" nov� zpr�vy.
</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#R#>
<//>

Nesouhlas�te-li, ignorujte tuto zpr�vu.

D�kuji za spolupr�ci!

</text/sub-bad/>
Hmmm, tohle ��slo potvrzen� nevypad� platn�.

Nej�ast�j��m d�vodem v�skytu neplatn�ch ��sel je vypr�en� �asu.
Mus�m dostat odpov�� na ka�d� po�adavek nejpozd�ji do deseti dn�.
Ujist�te se tak�, �e v odpov�di, kterou jsem obdr�el, bylo _cel�_
��slo potvrzen�. N�kter� e-mailov� programy mohou o��znout ��st
adresy pro odpov��, kter� m��e b�t i dosti dlouh�.

Pos�l�m novou ��dost o potvrzen�. Pro potvrzen�, �e chcete p�idat adresu

!A

do listu <#l#>, po�lete pr�zdnou odpov�� na adresu

!R
</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#R#>
<//>

Je�t� jednou: ujist�te se, �e adresa pro odpov�� je skute�n� v po��dku
p�edt�m, ne� potvrd�te tuto ��dost.

Omlouv�m se za pot�e.

	<#L#>-Owner <<#l#>-owner@<#H#>>

</text/sub-confirm/>
Chcete-li opravdu p�idat adresu

!A

do listu <#l#>, po�lete pr�zdnou zpr�vu na adresu

!R

Toho obvykle dos�hnete pomoc� tla��tka "Odpov��/Reply". M��ete zkontrolovat
adresu, za��n�-li �et�zcem "<#L#>-sc". Pokud toto nefunguje, sta��
zkop�rovat adresu a ulo�it ji do pol��ka "To:" nov� zpr�vy.

</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#R#>
<//>

Vy�adov�n� tohoto potvrzen� m� dva d�vody. Za prv� ov�uje, �e jsem
schopen zas�lat mail na va�i adresu. A za druh�, chr�n� v�s v p��pad�,
�e n�kdo zfal�uje ��dost o p�ihl�en� s va��m jm�nem.

</#q/>
N�kter� po�tovn� programy jsou chybn� a nemohou zpracov�vat dlouh�
adresy. Pokud nem��ete odpov�d�t na tuto adresu, po�lete
zpr�vu na adresu <<#L#>-request@<#H#>>
a vlo�te celou v��e uvedenou adresu do subjectu.

</text/sub-confirm#s/>
Tento list je moderovan�. Jakmile po�lete potvrzen�, po�adavek
bude posl�n moder�torovi tohoto listu. Uv�dom�m v�s, jakmile
bude p�ihl�en� hotovo.

</text/sub-nop/>
Potvrzen�: Adresa

!A

byla v ji� v listu <#l#>, kdy� jsem obdr�el va�i ��dost,
a z�st�v� p�ihl�ena.

</text/sub-ok#E/>
Potvrzen�: P�idal jsem adresu

!A

do listu <#l#>.

V�tejte v listu <#l#>@<#H#>!

Pros�m uschovejte si tuto zpr�vu pro informaci, z jak� adresy
bylo p�ihl�en� do listu provedeno. Budete ji pot�ebovat v p��pad�,
�e se budete cht�t odhl�sit nebo zm�nit svoji adresu.

</text/top/>
Zdrav�m, tady je program ezmlm. Spravuji diskusn� list
<#l#>@<#H#>.

</#x/>
Pracuji pro sv�ho spr�vce, kter� m��e b�t zasti�en na adrese
at <#l#>-owner@<#H#>.

</text/unsub-bad/>
Hmmm, tohle ��slo potvrzen� nevypad� platn�.

Nej�ast�j��m d�vodem v�skytu neplatn�ch ��sel je vypr�en� �asu.
Mus�m dostat odpov�� na ka�d� po�adavek nejpozd�ji do deseti dn�.
Ujist�te se tak�, �e v odpov�di, kterou jsem obdr�el, bylo _cel�_
��slo potvrzen�. N�kter� e-mailov� programy mohou o��znout ��st
adresy pro odpov��, kter� m��e b�t i dosti dlouh�.

Pos�l�m novou ��dost o potvrzen�. Pro potvrzen�, �e chcete zru�it adresu

!A

do listu <#l#>, po�lete pr�zdnou odpov�� na adresu

!R
</#x/>

M��ete tak� zkusit kliknout zde:
        mailto:<#R#>
<//>

Je�t� jednou: ujist�te se, �e adresa pro odpov�� je skute�n� v po��dku
p�edt�m, ne� potvrd�te tuto ��dost.

Omlouv�m se za pot�e.

        <#L#>-Owner <<#l#>-owner@<#H#>>

</text/unsub-confirm/>
Potvrzujete-li, �e chcete adresu

!A

zru�it z listu <#l#>, po�lete pr�zdnou odpov�� na adresu

!R

Toho obvykle dos�hnete pomoc� tla��tka "Odpov��/Reply". M��ete zkontrolovat
adresu, za��n�-li �et�zcem "<#L#>-sc". Pokud toto nefunguje, sta��
zkop�rovat adresu a ulo�it ji do pol��ka "To:" nov� zpr�vy.
</#x/>

M��ete tak� zkusit kliknout zde:
	mailto:<#R#>
<//>

Nekontroloval jsem, je-li va�e adresa v sou�asn� dob� na listu.
Chcete-li zjistit, ze kter� adresy bylo provedeno p�ihl�en�,
pod�vejte se do zpr�v, kter� dost�v�te z listu. Ka�d� zpr�va
m� adresu v n�vratov� cest�:
<<#l#>-return-<number>-jana=domena.cz@<#H#>.

</#q/>
N�kter� po�tovn� programy jsou chybn� a nemohou zpracov�vat dlouh�
adresy. Pokud nem��ete odpov�d�t na tuto adresu, po�lete
zpr�vu na adresu <<#L#>-request@<#H#>>
a vlo�te celou v��e uvedenou adresu do subjectu.

</text/unsub-nop/>
Potvrzen�: Adresa

!A

nebyla na listu <#l#> v dob�, kdy jsem obdr�el
v� po�adavek a nen� na n�m ani te�.

Pokud se odhl�s�te, ale st�le v�m budou chodit dopisy, je p�ihl�en�
provedeno pod jinou adresou, ne� kterou v sou�asn� dob� pou��v�te.
Pod�vejte se pros�m do hlavi�ek zpr�v na text

"Return-Path: <<#l#>-return-1234-pepa=domena.cz@<#H#>>'

Odhla�ovac� adresa pro tohoto u�ivatele pak bude
"<#l#>-unsubscribe-pepa=domena.cz@<#H#>".
Sta�� poslat mail na tuto adresu s t�m, �e pepa=domena.cz nahrad�te
skute�n�mi hodnotami. Pak odpov�te na ��dost o potvrzen� a m�la
by v�m doj�t zpr�va o odhl�en� z listu.

V n�kter�ch po�tovn�ch programech si mus�te zpr�vu zobrazit v�etn�
hlavi�ek, jinak nen� hlavi�ka "Return-Path" viditeln�.

Pokud toto st�le nefunguje, pak je mi l�to, ale nemohu v�m pomoci.
Pros�m PREPO�LETE (forward) zpr�vu z listu spolu s pozn�mkou o tom,
�eho se sna��te dos�hnout a seznamem adres, ze kter�ch potenci�ln�
m��ete b�t p�ihl�en[a] m�mu spr�vci:

    <#l#>-owner@<#H#>

Tento se bude sna�it v� probl�m �e�it. M�j spr�vce je tro�ku pomalej��
ne� j�, tak�e pros�m o trochu trp�livosti.

</text/unsub-ok/>
Potvrzen�: Zru�il jsem adresu

!A

z listu <#l#>. Tato adresa ji� d�le nen� v seznamu
p�ihl�en�ch.

</text/edit-do#n/>
Pros�m editujte n�sleduj�c� soubor a po�lete jej na adresu

!R

V� po�tovn� program by m�l m�t tla��tko "Odpov��/Reply",
kter� tuto adresu pou�ije automaticky.

Um�m dokonce s�m smazat citovac� zna�ky, kter� v� po�tovn� program
p�id� p�ed text, pokud ov�em ponech�te zna�kovac� ��dky samotn�.

Tyto ��dky za��naj� t�emi znaky procento. Nesm� b�t modifikov�ny
(s v�jimkou p��padn�ch znak� p�ed nimi, p�idan�ch p�ipadn� va��m
po�tovn�m klientem).

</text/edit-list#n/>
P��kaz <#L#>-edit.soubor m��e b�t pou�it vzd�len�m spr�vcem k editaci
textov�ch soubor�, ze kter�ch se skl�daj� odpov�di pro list <#L#>@<#H#>.

N�sleduje seznam p��slu�n�ch soubor� a kr�tk� popis toho, kdy je
jejich obsah vyu��v�n. Chcete-li editovat soubor, sta�� poslat
mail na adresu <#L#>-edit.soubor, p�i�em� je nutno "soubor"
nahradit skute�n�m jm�nem souboru. Obdr��te soubor spolu s instrukcemi,
jak tento soubor editovat.

Soubor              Pou�it�

bottom              p�id�v� se za ka�dou odpov��. V�eobecn� informace.
digest              "administrativn�" ��st digest�.
faq                 �asto kladen� dotazy, specifick� pro tento list.
get_bad             neni-li zpr�va nalezena v arch�vu.
help                v�eobecn� n�pov�da (mezi "top" a "bottom").
info                informace o listu. Prvn� ��dek by m�l d�vat smysl s�m o sob�.
mod_help            n�pov�da pro moder�tory.
mod_reject          odes�lateli odm�tnut� zpr�vy.
mod_request         moder�torovi spolu s p��sp�vkem.
mod_sub             p�ihla�ovan�mu, jakmile jeho p�ihl�en� potvrd� moder�tor.
mod_sub_confirm     moder�torovi s ��dost� o potvrzen� p�ihl�en�.
mod_timeout         odes�lateli, nestihne-li moder�tor potvrdit zpr�vu.
mod_unsub_confirm   administr�torovi s ��dost� o potvrzen� odhl�en�.
sub_bad             odes�lateli, bylo-li p�ihl�en� neplatn�.
sub_confirm         odes�lateli - ��dost potvrzen� p�ihl�en�.
sub_nop             odes�lateli - p�i pokusu o op�tovn� p�ihl�en�
sub_ok              odes�lateli - oznamuje p�ihl�en�.
top                 za��tek v�ech odpov�d�.
</#tn/>
trailer             p�id� se za ka�d� p��sp�vek do listu.
</#n/>
unsub_bad           odes�lateli, byla li ��dost o odhl�en� neplatn�.
unsub_confirm       odes�lateli - ��dost o potvrzen� odhl�en�.
unsub_nop           odes�lateli - nebyl-li p�ihl�en a sna�il-li se odhl�sit.
unsub_ok            odes�lateli po �sp�n�m odhl�en�.

</text/edit-done#n/>
Textov� soubor byl �sp�n� upraven.
</text/info#E/>
��dn� informace nebyla k tomuto listu poskytnuta.
</text/faq#E/>
FAQ - �asto kladen� dotazy v listu <#l#>@<#H#>.

[ ��dn� zat�m nejsou dostupn� ]


