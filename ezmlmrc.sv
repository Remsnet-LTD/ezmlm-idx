0.40 - This version identifier must be on line 1 and start in pos 1.
#
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
# -3 is for the new from header if we want that header replaced
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
X:<#X#>
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
</-indexed#eA/>
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
</manager#ab/>
|<#B#>/ezmlm-get -P '<#D#>' <#C#>
</manager#aGB/>
|<#B#>/ezmlm-get '<#D#>' <#C#>
</manager#agB/>
|<#B#>/ezmlm-get -s '<#D#>' <#C#>
</manager#q/>
|<#B#>/ezmlm-request '<#D#>'
# Ok to add -l/-d even for non-mod lists, since ezmlm-manage
# won't allow it unless there are remote admins. The lack of logic other than
# AND makes this very tedious ...
# first lists with normal confirmation:
</manager#LNHJ/>
|<#B#>/ezmlm-manage '<#D#>'
</manager#lNHJ/>
|<#B#>/ezmlm-manage -l '<#D#>'
</manager#LnHJ/>
|<#B#>/ezmlm-manage -e '<#D#>'
</manager#lnHJ/>
|<#B#>/ezmlm-manage -le '<#D#>'
# ... now no confirmation for subscribe ...
</manager#LNhJ/>
|<#B#>/ezmlm-manage -S '<#D#>'
</manager#lNhJ/>
|<#B#>/ezmlm-manage -lS '<#D#>'
</manager#LnhJ/>
|<#B#>/ezmlm-manage -eS '<#D#>'
</manager#lnhJ/>
|<#B#>/ezmlm-manage -leS '<#D#>'
# ... now no confirmation for unsubscribe ...
</manager#LNHj/>
|<#B#>/ezmlm-manage -U '<#D#>'
</manager#lNHj/>
|<#B#>/ezmlm-manage -lU '<#D#>'
</manager#LnHj/>
|<#B#>/ezmlm-manage -eU '<#D#>'
</manager#lnHj/>
|<#B#>/ezmlm-manage -leU '<#D#>'
# ... and finally no confirmation at all ...
</manager#LNhj/>
|<#B#>/ezmlm-manage -US '<#D#>'
</manager#lNhj/>
|<#B#>/ezmlm-manage -lUS '<#D#>'
</manager#Lnhj/>
|<#B#>/ezmlm-manage -eUS '<#D#>'
</manager#lnhj/>
|<#B#>/ezmlm-manage -leUS '<#D#>'
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
|<#B#>/ezmlm-issubn -n '<#D#>/deny' || { echo "Jag till�ter inte dina meddelanden. Kontakta <#L#>-owner@<#H#> ifall du har n�gra fr�gor ang�ende det (#5.7.2)"; exit 100 ; }
# switch -u=> restrict to subs of list & digest. If not m
# do it with ezmlm-issubn, if 'm' do it with ezmlm-gate
</#uM/>
|<#B#>/ezmlm-issubn '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod' || { echo "Tyv�rr, endast prenumeranter f�r posta. Ifall du �r en prenumerant, orward this message to <#L#>-owner@<#H#> to get your new address included (#5.7.2)"; exit 100 ; }
</#um/>
|<#B#>/ezmlm-gate '<#D#>' '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod'
# For message moderation, editor has store/clean
</#mUO/>
|<#B#>/ezmlm-store '<#D#>'
</#mUo/>
|<#B#>/ezmlm-store -P '<#D#>'
</#mU/>
|<#B#>/ezmlm-clean '<#D#>' || exit 0
</#mu/>
|<#B#>/ezmlm-clean -R '<#D#>' || exit 0
# for non-message moderated lists, it has send
</#M/>
|<#B#>/ezmlm-send '<#D#>'
# ezmlm-archive here for normal lists. Put into moderator for mess-mod lists
</#Mi/>
|<#B#>/ezmlm-archive '<#D#>' || exit 0
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
# bouncer for list and digest
</bouncer/>
|<#B#>/ezmlm-weed
|<#B#>/ezmlm-return -D '<#D#>'
</digest/bouncer#d/>
|<#B#>/ezmlm-weed
|<#B#>/ezmlm-return -d '<#D#>'
# moderator is set up only for message moderated lists. However, '-e' does
# not remove it since we can't remove the symlinks to it (they're outside
# of the list dir.
</moderator#m/>
|<#B#>/ezmlm-moderate '<#D#>'
</#mi/>
|<#B#>/ezmlm-archive '<#D#>' || exit 0
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
list-subscribe
list-unsubscribe
list-help
</headerremove#E^0/>
# For sublists, these should be left in
list-post
# remove from header if -3 'new_from_line'
</#3E/>
from
</lock/>
</lockbounce/>
</digest/lockbounce#d/>
</digest/lock#d/>
</public#p/>
</archived#a/>
</indexed#a/>
</inhost/>
<#H#>
</outhost/>
<#H#>
</outlocal/>
<#L#>
</mailinglist/>
kontakta <#L#>-help@<#H#>; k�rs med ezmlm
# Headeradd needs to always exist but leave out stuff for sublists
</headeradd#E^0/>
# Good for mailing list stuff (and vacation program)
Precedence: bulk
# To prevent indexing by findmail.com
X-No-Archive: yes
# rfc2369, first from main list only, others from sublist only
List-Post: <mailto:<#L#>@<#H#>>
</headeradd#E/>
List-Help: <mailto:<#l#>-help@<#h#>>
List-Unsubscribe: <mailto:<#l#>-unsubscribe@<#h#>>
List-Subscribe: <mailto:<#l#>-subscribe@<#h#>>
# add new from line "From: arg" if -3 'arg'
</#3E/>
From: <#3#>
# max & min message size
</msgsize#x/>
30000:2
# remove mime parts if -x
</mimeremove#xE/>
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
</prefix#fE/>
[<#L#>]
</text/trailer#tE/>
---------------------------------------------------------------------
F�r att avsluta prenumerationen skicka e-mail till:
<#L#>-unsubscribe@<#H#>
F�r ytterligare kommandon, skicka e-mail till:
<#L#>-help@<#H#>
</text/bottom#E/>

--- Administrativa kommandon f�r <#l#> listan ---

Administrativa f�rfr�gningar kan hanteras automatiskt. Skicka
dem inte till listans adress! Skicka ist�llet ditt meddelande
till r�tt "kommando adress":

F�r hj�lp och en beskrivning �ver tillg�ngliga kommandon,
skicka ett brev till:
   <<#L#>-help@<#H#>>

F�r att prenumerera p� listan, skicka ett brev till:
   <<#L#>-subscribe@<#H#>>

F�r att avsluta din prenumeration, skicka ett meddelande till
adressen som st�r i "List-Unsubscribe" raden i brevhuvudet
fr�n ett brev som kom fr�n listan. Ifall du inte bytt adress
sen du p�b�rjade din prenumeration, skicka ett brev till:
   <<#L#>-unsubscribe@<#H#>>

</#dE/>
eller f�r "digest" versionen:
   <<#L#>-unsubscribe@<#H#>>

</#E/>
F�r nya/avslutade prenumerationer, skickar jag ett bekr�ftelse
brev till adressen. N�r du f�r brevet, svara bara p� det f�r
att genomf�ra prenumerationsf�r�ndringen.

Ifall du beh�ver komma i kontakt med en m�nniska ang�ende
listan, skicka ett brev till:

    <<#L#>-owner@<#H#>>

Var v�nlig och VIDARESKICKA (forward) ett meddelande fr�n listan
inklusive HELA brevhuvudet s� vi l�ttare kan hj�lpa dig.

--- Nedan finner du en kopia p� f�rfr�gan jag fick.

</text/bounce-bottom#E/>

--- Nedan finner du en kopia p� det "studsade" meddelandet jag fick.

</text/bounce-num#E/>

Jag har skapat en lista p� de meddelanden fr�n <#L#> listan som
har "studsat" p� v�g till dig.

</#aE/>
Kopior av dessa meddelanden kan du finna i arkivet.

</#aE/>
F�r att h�mta meddelande 123-145 (max 100 per f�rfr�gan), skicka
ett brev till:
   <<#L#>-get.123_145@<#H#>>

F�r att f� en lista p� titlar och f�rfattare f�r de senaste 100
meddelandena, skicka ett brev till:
   <<#L#>-index@<#H#>>

</#E/>
Detta �r meddelande nummren:

</text/dig-bounce-num#E/>

Jag har skapat en lista p� "digest" meddelanden fr�n <#L#>-digest
listan, som har "studsat" till din adress. F�r varje "digest" brev
som du missat, har jag skrivit upp f�rsta meddelandenummret i det
brevet.

</#aE/>
"Digest" meddelanden arkiveras inte, men du kanske kan finna dem
i akrivet f�r huvudlistan.

F�r att ta emot brev 123-145 (max 100 per f�rfr�gan),
skicka ett brev till:
   <<#L#>-get.123_145@<#H#>>

F�r en lista �ver f�rfattare och titlar p� de senaste 100
meddelandena, skicka ett brev till:
   <<#L#>-index@<#H#>>

</#E/>
H�r �r "digest" meddelande nummren:

</text/bounce-probe#E/>

Meddelanden till dig fr�n <#l#> listan, verkar ha "studsat".
Jag skickade ett varningsbrev till dig om det, men det "studsade".
Nedan f�ljer en kopia p� det meddelandet.

Detta testbrev kontrollerar om din adress �r n�bar. Ifall detta
brev ocks� studsar, plockas din adress bort fr�n
<#l#>@<#H#> listan, utan ytterligare varningar.

Du kan prenumerera p� nytt genom att skicka ett brev
till denna adressen:
   <<#l#>-subscribe@<#H#>>

</text/bounce-warn#E/>

Meddelanden till dig fr�n <#l#> listan har "studsat".
Jag bifogar en kopia p� det f�rsta brevet till dig d�r
det intr�ffade.

Ifall detta meddelande ocks� "studsar", kommer ett testbrev skickas
till dig. Ifall det brevet ocks� studsar, plockas din adress bort
fr�n <#l#> listan utan ytterligare varning.

</text/digest#dE/>
F�r prenumeration p� "digest" versionen, skicka ett brev till:
	<#L#>-digest-subscribe@<#H#>

F�r att avsluta prenumerationen p� "digest" versionen,
skicka ett brev till:
	<#L#>-digest-unsubscribe@<#H#>

F�r att skicka ett brev till listan, skicka brevet till:
	<#L#>@<#H#>

</text/get-bad#E/>
Tyv�rr, det meddelandet finns inte i arkivet.

</text/help#E/>
Detta �r ett alm�nt hj�lp meddelande. Brevet som kom var inte
skickat till n�gon av kommando adresserna.

Detta �r en lista p� de kommando adresser som st�ds:

Skicka brev till n�got av f�ljande adresser f�r information
och "FAQn" f�r listan:
   <<#L#>-info@<#H#>>
   <<#L#>-faq@<#H#>>

</#dE/>
Liknande adresser finns f�r "digest" versionen av listan:
   <<#L#>-digest-subscribe@<#H#>>
   <<#L#>-digest-unsubscribe@<#H#>>

# ezmlm-make -i needed to add ezmlm-get line. If not, we can't do
# multi-get!
</#aE/>
F�r att f� meddelande 123 till 145 (max 100 per f�rfr�gan),
skicka ett brev till:
   <<#L#>-get.123_145@<#H#>>

F�r att f� ett index med f�rfattare och titel f�r meddelande
123-456, skicka ett brev till:
   <<#L#>-index.123_456@<#H#>>

F�r att f� alla meddelanden med samma titel som meddelande 12345,
skicka ett brev till:
   <<#L#>-thread.12345@<#H#>>

</#E/>
Meddelandena beh�ver inte inneh�lla n�got s�rskilt, det �r
bara adressen som �r viktig.

Du kan starta en prenumeration till en alternativ adress,
t ex "john@host.domain", addera bara ett bindestr�ck
och din adress (med '=', ist�llet f�r '@') efter kommando
ordet. Dvs:
<<#L#>-subscribe-john=host.domain@<#H#>>

F�r att avsluta prenumerationen till denna adressen,
skicka ett brev till:
<<#L#>-unsubscribe-john=host.domain@<#H#>>

</text/mod-help#E/>
Tack f�r att du vill moderera <#L#>@<#H#> listan.

Kommandona �r lite anorlunda mot andra listor,
men de �r l�tta att l�ra och anv�nda.

H�r �r lite instruktioner ang�ende de saker du kan beh�va
g�ra som list�gare/moderator.

Allm�na kommandon f�ljer efter detta meddelande.

Fj�rr prenumeration.
--------------------
Som moderator kan du prenumerera och avprenumerera vilken adress
som helst p� listan. F�r att prenumerera "john@host.domain",
skriv bara ett bindestr�ck efter "kommando ordet", d�refter
adressen med ett '=' tecken ist�llet f�r '@'. I detta fallet skulle
du skickat ett brev till:
   <<#L#>-subscribe-john=host.domain@<#H#>>

Du kan p� samma s�tt ta bort en adress med ett meddelande till:
   <<#L#>-unsubscribe-john=host.domain@<#H#>>

</#dE/>
F�r "digest" versionen av listan:
   <<#L#>-digest-subscribe-john=host.domain@<#H#>>
   <<#L#>-digest-unsubscribe-john=host.domain@<#H#>>

</#E/>
Det �r allt. Titel och inneh�ll spelar ingen roll!

</#rE/>
Ett bekr�ftelse brev kommer skickas f�r att vara s�ker
p� att det verkligen var du som skickade brevet.
Svara bara p� det brevet och det hela �r klart.
</#RE/>
Jag kommer skicka ett bekr�ftelsebrev till prenumerantens adress,
i detta fallet <john@host.domain>. Allt prenumeranten beh�ver
g�ra �r att svara p� brevet.
</#E/>

Bekr�ftelserna �r n�dv�ndiga f�r att g�ra det sv�rt f�r
en tredje part till att l�gga till/ta bort adresser till
listan.

Jag kommer underr�tta prenumeranten n�r dennes status
har �ndrats.

Prenumeration
--------------

Alla kan prenumerera/sluta prenumerera p� listan genom
att skicka ett brev till:

<#L#>-subscribe@<#H#>
<#L#>-unsubscribe@<#H#>

</#dE/>
F�r "digest" versionen av listan:

<#L#>-digest-subscribe@<#H#>
<#L#>-digest-unsubscribe@<#H#>

</#E/>
Prenumeranten kommer f� ett bekr�ftelse brev f�r
att vara s�ker p� att personen har den adressen.
N�r det �r klart blir personen borttagen ur listan.

</#sE/>
Eftersom denna listan �r sluten, kommer jag skicka en andra
f�rfr�gan till moderatorerna. Eftersom prenumeranten redan har
bekr�ftat att den vill vara med p� listan, kan du som
moderator vara s�ker p� att det �r r�tt adress. Ifall du vill
ha med personen p� listan, svara p� bekr�ftelse (CONFIRM)
meddelandet. Ifall du inte vill ha med personen, radera bara
meddelandet ist�llet (eller kontakta personen f�r ytterligare
information).
</#SE/>
Prenumeration fungerar p� samma s�tt.
</#E/>

Anv�ndaren kan ocks�:

   <<#L#>-subscribe-mary=host.domain@<#H#>>
   <<#L#>-unsubscribe-mary=host.domain@<#H#>>

f�r att f� brev skickad till "mary@host.domain". Bara om hon kan
ta emot brev p� den adressen, f�r hon bekr�ftelse meddelandet
och kan svara p� det.

Din adress och identitet kommer att vara hemlig f�r prenumeranten
om du inte skickar brev direkt till denne.

</#rlE/>
F�r att f� en lista p� prenumeranter p� <#L#>@<#H#>,
skicka ett brev till:
   <<#L#>-list@<#H#>>

F�r att f� en "transaktionslog" f�r <#L#>@<#H#>,
skicka ett brev till:
   <<#L#>-log@<#H#>>

</#rldE/>
F�r "digest" prenumeranter:
   <<#L#>-digest-list@<#H#>>
och:
   <<#L#>-digest-log@<#H#>>

</#rnE/>
Du kan �ndra textfilerna, som listan anv�nder, p� distans. F�r att
f� en lista p� filerna och instruktioner om hur du �ndrar dem,
skicka ett e-mail till:
   <<#L#>-edit@<#H#>>

</#mE/>
Modererade utskick
------------------
N�r utskick �r modererade, kommer ett brev att skickas till dig
med en kopia p� utskick och instruktioner som ber�ttar hur
utskicket skall godk�nnas f�r att komma med p� listan. Det
brevet kommer att ha "MODERATE for ..." som titel.

F�r att acceptera ett utskick, skicka bara ett svar till 'Reply-To:'
adressen (sker vanligtvis med "svara" knappen). Du beh�ver inte
skicka med brevet du fick skickat till dig, det �r bara adressen
som �r viktig.

Ifall du vill avvisa utskicket, skicka ett brev till avs�ndar-
adressen ("From:" f�ltet), d�r r�tt avvisningsadress �r inskrivning.
"Svara alla" brukar anv�nda den adressen. Om du vill skriva ett
meddelande till f�rfattaren, skriv den mellan tv� rader som b�rjar
med tre '%' tecken. Detta kommer att ske anonymt och bara skickas
till f�rfattaren.

Utskicket kommer att behandlas beroende p� vilket svar som kommer
in f�rst. Om en moderator redan har avvisat ett brev som du godk�nner
s� kommer brevet �nd� att vara avvisat och vice versa.

Ifall ingen moderator svarar inom en viss tid (vanligtvis 5 dagar),
kommer brevet att returneras till f�rfattaren med en f�rklaring
om vad som h�nde.
</#E/>

Semestrar
---------
Ifall du tempor�rt har en annan adress, vidareskicka alla brev som
har korrekt "Mailing-List:" f�lt i brevhuvudet (eller alla brev som
har titeln "MODERATE for <#L#>@<#H#>"
eller "CONFIRM subscribe to <#L#>@<#H#>")
till den nya adressen. Du kan d�refter moderera listan fr�n den
adressen. Alternativt kan du vidareskicka brevet till n�gon annan
som modererar listan �t dig. Fr�ga list�garen f�rst om det �r OK.

Ifall du vill att allt skall godk�nnas automatiskt medan du �r
borta, st�ll iordning ditt e-mail system s� den g�r ett autosvar
p� brev med ovan n�mnda titlar.

</#rE/>
Ifall du f�rs�ker administrera listan fr�n en adress som inte �r din
egen, prenumeranten, inte du, kommer fr�gas efter en bekr�ftelse.
D�refter kommer en bekr�ftelsef�rfr�gan skickas till moderatorerna.
Detta g�rs eftersom det �r om�jligt att veta ifall det var du som
skickade originalfr�gan.

Observera att originalf�rfr�gan, inklusive din adress, skickas till
prenumeranten i detta fallet.
</#E/>

Lycka till!

PS. Kontakta list�garen (<#L#>-owner@<#H#>) ifall du
har n�gra fr�gor eller st�ter p� n�gra problem.

</text/mod-reject#E/>
Tyv�rr, meddelandet (bifogat) accepterades inte av moderatorn.
Ifall moderatorn har bifogat n�gra kommentarer, st�r de h�r nedan.
</text/mod-request#E/>
Det bifogade meddelandet skickades till <#L#>@<#H#> listan.
Ifall du vill godk�nna den f�r vidare distribution skicka e-mail till:

!A

Vanligtvis h�nder detta automatiskt om du trycker p� "svara" (reply)
knappen. Du kan kontrollera adressen att den b�rjar med:
"<#L#>-accept". Ifall det inte fungerar, kopiera adressen och
klistra in den i "Till" ("To:") f�ltet i ett nytt brev.
</#xE/>

Alternativt, tryck h�r:
	<mailto:<#A#>>
</#E/>

F�ra att skicka tillbaka brevet till avs�ndaren, skicka ett
meddelande till:

!R

Vanligtvis �r det enklare att trycka p� "svara alla" ("reply-to-all")
knappen och ta bort alla adresser som inte b�rjar med:
"<#L#>-reject".
</#xE/>

Alternativt, tryck h�r:
	<mailto:<#R#>>
</#E/>

Du beh�ver inte kopiera brevet i ditt svar. Ifall du vill skicka
med en kommentar till f�rfattaren till ett brev du inte accepterat,
inkludera kommentaren, i svarsbrevet, mellan tv� rader som b�rjar
med tre procenttecken ('%').

%%% Start kommenter
%%% Slut kommentar.

Tack f�r din hj�lp!

--- Nedan finner du utskicket.

</text/mod-sub#E/>
--- Du har blivit (av-)prenumererad av en moderator f�r
<#l#>@<#H#> listan.

Ifall du inte tycker om det, skicka ett klagom�l, eller annan
kommentar, till list�garen (<#l#>-owner@<#H#>) s� snart som
m�jligt.

</text/mod-timeout#E/>
Tyv�rr har <#L#> listans moderatorer inte
hanterat din postning, d�rf�r skickas den nu tillbaka till dig.
Ifall detta �r fel, skicka om ditt meddelande till listan
eller kontakta list�garen (<#L#>-owner@<#H#>).

--- Bifogat �r brevet du skickade.

</text/mod-sub-confirm#E/>
Vill du l�gga till

!A

till <#l#> listan? Antingen kom detta brevet som svar p�
att du vill l�gga till prenumeranten till listan eller
s� har prenumeranten redan bekr�ftat sin prenumeration.

F�r att bekr�fta, skicka ett tomt brev till denna adress:

!R

Vanligtvis g�rs det genom "svara" ("reply") knappen.
Ifall det inte fungerar, kopiera adressen och klistra in den i
"To:" f�ltet i ett nytt meddelande.
</#xE/>

eller tryck h�r:
	<mailto:<#R#>>
</#E/>

Ifall du inte godk�nner detta, ignorera detta meddelande.

Tack f�r din hj�lp!

</text/mod-unsub-confirm#E/>
N�gon �nskar ta bort:

!A

fr�n <#l#> listan. Ifall du h�ller med, skicka ett brev
till denna adress:

!R

Enklast g�r du det genom att trycka p� "svara" ("reply") knappen.
Ifall det inte fungerar, kopiera adressen och klistra in den i
"Till" ("To:") f�ltet i det nya meddelandet.
</#xE/>

eller tryck h�r:
	<mailto:<#R#>>
</#E/>

Ifall du inte h�ller med, ignorera detta brev.

Tack f�r din hj�lp!

</text/sub-bad#E/>
Oops, det bekr�ftelsenummret verkar vara felaktigt.

Den vanligaste orsaken till felaktiga bekr�ftelsenummer �r
att de blivit f�r gamla. De g�ller i max 10 dagar. Var ocks�
s�ker p� att du anv�nde hela bekr�ftelsenummret i ditt svar,
vissa program kan i vissa fel ta bort slutet p� adresser n�r
de �r l�nga.

Ett nytt bekr�ftelsenummer har skapats, f�r att bekr�fta att
du vill ha med

!A

p� <#l#> listan, skicka ett brev till denna adress:

!R
</#xE/>

eller tryck h�r:
	<mailto:<#R#>>
</#E/>

Var noga med att svarsadresser �r riktig n�r du bekr�ftar
prenumerationen.

Urs�kta detta extra besv�r.

	<#L#>-Owner <<#l#>-owner@<#H#>>

</text/sub-confirm#E/>
F�r att bekr�fta att du vill ha

!A

adderad till <#l#> listan, skicka ett brev till denna adress:

!R

Enklast g�rs det genom att trycka p� "svara" ("reply") knappen.
Ifall det inte fungerar, kopiera adressen och klistra in den i
"Till" ("To:") f�ltet i ett nytt brev.
</#xE/>

eller tryck h�r:
	<mailto:<#R#>>
</#E/>

Denna bekr�ftelse tj�nar tv� syften. Dels s�kerst�ller den att det g�r
att skicka brev till dig och dels skyddar den dig mot att andra f�rs�ker
prenumerera n�gon mot dess vilja.

</#qE/>
Det �r fel p� vissa e-mail program vilket g�r att de inte kan hantera
l�nga adresser. Ifall du inte kan svara p� denna f�rfr�gan, skicka
ist�llet ett meddelande till <<#L#>-request@<#H#>>
och skriva hela ovan n�mnda adress i titel ("Subject:") raden.

</#sE/>
Denna lista �r modererad. S� fort du har svarat p� denna bekr�ftelse
kommer din f�rfr�gan att skickas till moderatorerna f�r listan.
Du kommer att underr�ttas n�r din prenumeration �r aktiverad.

</text/sub-nop#E/>
Jag kunde inte utf�ra din f�rfr�gan.

!A

prenumererar redan p� <#l#> listan n�r jag fick din f�rfr�gan.
Adressen kommer vara kvar p� listan.

</text/sub-ok#E/>
Uppm�rksamma: Adressen

!A

har adderats till <#l#> listan.

V�lkommen till <#l#>@<#H#>!

Var v�nlig och spara detta meddelande s� du minns vilken adress
som prenumererar p� listan, ifall du senare vill avsluta din
prenumeration.

F�r att avsluta prenumerationen, skicka ett brev till:

    <<#l#>-unsubscribe-<#t#>@<#H#>>

</text/top/>
Detta �r ett meddelande fr�n ezmlm programmet som har hand om
<#l#>@<#H#> listan.

</#x/>
�garen till listan kan n�s p�:
<#l#>-owner@<#H#>.

</text/unsub-bad#E/>
Oops, det bekr�ftelsenummret verkar vara felaktigt.

Den vanligaste orsaken till felaktiga bekr�ftelsenummer �r
att de blivit f�r gamla. De g�ller i max 10 dagar. Var ocks�
s�ker p� att du anv�nde hela bekr�ftelsenummret i ditt svar,
vissa program kan i vissa fel ta bort slutet p� adresser n�r
de �r l�nga.

Ett nytt bekr�ftelsenummer har skapats, f�r att bekr�fta att
du vill ta bort

!A

fr�n <#l#> listan, skicka ett brev till denna adress:

!R
</#xE/>

eller klicka h�r:
	<mailto:<#R#>>
</#E/>

Var v�nligt att kontrollera svarsadressen noggrant s� att den �r
riktig innan du svarar p� detta brev.

Urs�kta allt besv�r.

	<#l#>-Owner <<#l#>-owner@<#H#>>

</text/unsub-confirm#E/>
F�r att bekr�fta att du vill ta bort

!A

fr�n <#l#> listan, skicka ett brev till denna adress:

!R

Vanligtvis g�r man det med "Svara" ("Reply") knappen.
Ifall det inte fungerar, kopiera adressen nedan och klistra
in den i "Till" ("To:") f�ltet i ett nytt brev.
</#xE/>

eller tryck h�r:
	<mailto:<#R#>>
</#E/>

F�r att se vilken adress din prenumeration g�r till, unders�k ett
meddelande fr�n listan. Varje meddelande har din adress dold i
dess "return path", t ex mary@xdd.ff.com har f�r meddelanden
med "return-path" satt till:
<<#l#>-return-<nummer>-mary=xdd.ff.com@<#H#>>.

</#qE/>
Vissa email program �r felaktiga och kan inte hantera l�nga adresser.
Ifall du inte kan svara p� detta meddelande, skicka ist�llet ett
meddelande till <<#L#>-request@<#H#>> och skriv hela ovan n�mnda
adress i titel ("Subject:") raden.

</text/unsub-nop#E/>
Tyv�rr kan inte din f�rfr�gan utf�ras eftersom adressen:

!A

var inte med p� <#l#> listan.

Ifall du har avslutat din prenumeration, men fortfarande f�r brev,
�r du prenumererad under en annan adress �n den du f�r n�rvarande
anv�nder. Titta i brevhuvudet (header) efter:

'Return-Path: <<#l#>-return-1234-user=host.dom@<#H#>>'

Det visar din prenumerationsadress som "user@host.dom".
F�r att avsluta din prenumeration med den adressen, skicka
ett brev till:
<#l#>-unsubscribe-user=host.dom@<#H#>

Gl�m inte att anpassa user=host.dom till din egen adress.

Ifall meddelandet har en "List-Unsubscribe:" f�lt i brevhuvudet,
kan du skicka ett meddelande till adressen i det f�ltet.
Det �r redan anpassat f�r din adress.

I vissa email program m�ste du g�ra vissa inst�llningar f�r att
se "return path" f�ltet i brevhuvudet:

I Eudora 4.0, klicka p� "Blah blah ..." knappen.
I PMMail, klicka p� "Window->Show entire message/header". 

Ifall det inte fungerar kan vi tyv�rr inte g�ra mer.
Vidares�nd ett brev fr�n listan, tillsammans med ett meddelande
om vad du vill ha gjort och en lista som du tror att du kan ha
prenumererat under till list�garen:

    <<#l#>-owner@<#H#>>

som kan ta hand om det. Det kan dock dr�ja en liten stund innan du f�r
ett svar.

</text/unsub-ok#E/>
Observera: Jag har tagit bort adressen

!A

fr�n <#l#> listan. Den adressen �r inte l�ngre en prenumerant.

</text/edit-do#nE/>
Var v�nlig och editera f�ljande textfil och skicka den till
denna address:

!R

Ditt mailprogram borde ha en svarsfunktiuon som anv�nder
denna address automatiskt. Ifall det inte fungerar, kan du
kopiera addressen och klistra in den i "To:"/"Till:" f�ltet
p� ett nytt medelande.
</#xE/>

eller klicka h�r:
        mailto:<#R#>
</#E/>

Jag kan ta bort citeringsmarkeringar (t ex "> ") som din
mailprogramvara l�gger till texten s� l�nge som du inte
�ndrar start och slutraderna.

Start och slutraderna �r rader som b�rjar med %%%. De f�r inte
�ndras. Ifall ditt mailprogram l�gger in tecken f�re dem s� skall
de st� kvar.


</text/edit-list#En/>
<#L#>-edit.fil kommandot kan anv�ndas av en fj�rradministrat�r
f�r att editera de textfiler som skapar de svaren jag skickar f�r
<#L#>@<#H#> listan.

H�r f�ljer en lista p� de filer som kan �ndras samt en
kort beskrivning om hur dess inneh�ll anv�nds. F�r att
�ndra en fil, skicka ett brev till <#L#>-edit.filnamn d�r
du byter ut filnamn mot filens namn. Editeringsinstruktioner
skickas till dig ihop med textfilen.

Fil                 Anv�ndninsomr�de.

bottom              slutet p� alla svar. Generell kommando information.
digest              'administrationsbiten' av en 'digest'.
faq                 Vanligt f�rekommande fr�gor p� denna lista.
get_bad             i st�llet f�r medelanden som inte hittas i arkivet.
help                generell hj�lp (mellan top och bottom).
info                list info. F�rsta raden skall kunna visas separat.
mod_help            specifik hj�lp f�r listmoderatorer.
mod_reject          s�nds till avs�ndaren av avvisade medelanden.
mod_request         till medelandemoderatorerna tillsammans med medelandet.
mod_sub             till prenumeranter efter att en moderator bekr�ftat prenumerationen.
mod_sub_confirm     till prenumerationsmoderatorn f�r att bekr�fta prenumerationer.
mod_timeout         till s�ndaren av ett medelande som ingen accepterat/avvisat.
mod_unsub_confirm   till en administrat�r f�r att bekr�fta avprenumerationer.
sub_bad             till prenumeranten ifall bekr�ftelsen var felaktig.
sub_confirm         till prenumeranten f�r att bekr�fta prenumerationer.
sub_nop             till prenumeranten efter en dubbel prenumeration.
sub_ok              till prenumeranten efter en lyckad prenumeration.
</#tnE/>
trailer             adderas till alla utskick innan de kommer till listan.
</#nE/>
top                 starten p� alla svar. Generell kommando information.
unsub_bad           till prenumeranten ifall avprenumerationen misslyckades.
unsub_confirm       till prenumeranten f�r att bekr�fta avprenumeration.
unsub_nop           till icke-prenumerant efter avprenumeration.
unsub_ok            till tidigare prenumeration efter avslutad prenumeration.

</text/edit-done#nE/>
Textfilen uppdaterades korrekt.
</text/info#E/>
Ingen information har antecknats om listan.
</text/faq#E/>
FAQ - vanligt f�rekommande fr�gor p� <#l#>@<#H#> listan.

Inga har nedtecknats �nnu.

