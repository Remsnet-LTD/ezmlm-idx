#$Id$
#
# English ---> polish translation by Sergiusz Paw�owicz, 1998.
# Translation (C) to Free Software Foundation, 1998.
# Wszelkie uwagi dotycz�ce t�umaczenia prosz� przesy�a� na adres
#                                        cheeze@hyperreal.art.pl
# Troche opisow po polsku znajdziecie pod adresem
#                        http://www.arch.pwr.wroc.pl/~ser/lists/
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
ISO-8859-2
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
|<#B#>/ezmlm-issubn -n '<#D#>/deny' || { echo "Przykro mi, ale nakazano mi odrzuca� Twoje listy... Skontaktuj si�, prosz�, z opiekunem listy, osi�galnym pod adresem: <#L#>-owner@<#H#>, je�eli masz jakiekolwiek w�tpliwo�ci co do tego stanu rzeczy (#5.7.2)"; exit 100 ; }
# switch -u=> restrict to subs of list & digest. If not m
# do it with ezmlm-issubn, if 'm' do it with ezmlm-gate
</#uM/>
|<#B#>/ezmlm-issubn '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod' || { echo "Przykro mi, ale tylko prenumeratorzy mog� wysy�a� poczt� na list�... Jesli jeste� pewna/pewien prenumerowania tej w�a�nie listy, prze�lij, prosz�, kopi� tego listu opiekunowi: <#L#>-owner@<#H#>, aby dopisa� on Tw�j nowy adres pocztowy (#5.7.2)"; exit 100 ; }
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
Wypisanie?     wy�lij list: <#L#>-unsubscribe@<#H#>
Wi�cej pomocy? wy�lij list: <#L#>-help@<#H#>
</text/bottom/>

--- Poni�ej znajduj� si� komendy menad�era list dyskusyjnych "ezmlm".

Spe�niam komendy administracyjne automatycznie.
Wy�lij jedynie pusty list pod kt�rykolwiek z tych adres�w:

   <<#L#>-subscribe@<#H#>>:
   Zapisanie si� na list� o nazwie <#L#>.

   <<#L#>-unsubscribe@<#H#>>:
   Wypisanie si� z listy o nazwie <#L#>.

Wy�lij list pod nast�puj�ce adresy, je�li chcesz uzyka� kr�tk� notk�
informacyjn� o li�cie dyskusyjnej lub jej FAQ (czyli 'najcz�ciej
zadawana pytania na temat listy wraz z odpowiedziami'):
   <<#L#>-info@<#H#>>
   <<#L#>-faq@<#H#>>

</#d/>
I odpowiadaj�ce powy�szemu adresy, je�li chodzi ci o przegl�d listy:
   <<#L#>-digest-subscribe@<#H#>>
   <<#L#>-digest-unsubscribe@<#H#>>

# ezmlm-make -i needed to add ezmlm-get line. If not, we can't do
# multi-get!
</text/bottom#ai/>
   <<#L#>-get.12_45@<#H#>>:
   Ch�� otrzymania kopii list�w od nr 12 do 45 z archiwum.
   Jednym listem mo�esz otrzyma� maksymalnie 100 list�w.

</text/bottom#aI/>
   <<#L#>-get.12@<#H#>>:
   Ch�� otrzymania kopii listu nr 12 z archiwum.
</text/bottom#i/>
   <<#L#>-index.123_456@<#H#>>:
   Ch�� otrzymania tytu��w list�w od nr 123 do 456 z archiwum.
   Tytu�y s� wysy�ane do Ciebie w paczkach po sto na jeden list.
   Mo�esz maksymalnie zam�wi� 2000 tytu��w na jeden raz.

# Lists need to be both archived and indexed for -thread to work
</text/bottom#ai/>
   <<#L#>-thread.12345@<#H#>>:
   Ch�� otrzymania wszystkich kopii list�w z tym samym tytu�em
   jaki posiada list o numerze 12345.

# The '#' in the tag below is optional, since no flags follow.
# The name is optional as well, since the file will always be open
# at this point.
</text/bottom#/>

NIE WYSY�AJ POLECE� ADMINISTRACYJNYCH NA LIST� DYSKUSYJN�!
Jesli to zrobisz, administrator listy ich nie zobaczy, natomiast
wszyscy prenumeratorzy nie�le si� na Ciebie wkurz� i zostaniesz
uznany(a) za internetowego ��todzioba, z kt�rym nie warto gada�.

Aby okresli� adres B�g@niebo.prezydent.pl jako sw�j adres subskrybcyjny,
wy�lij list na adres:
<<#L#>-subscribe-B�g=niebo.prezydent.pl@<#H#>>.
Wy�l� Ci wtedy potwierdzenie na ten w�asnie adres; kiedy je otrzymasz,
po prostu odpowiedz na nie, aby sta� si� prenumeratorem.

</text/bottom#x/>
Je�eli instrukcje, kt�rych Ci udzieli�em, s� zbyt trudne, albo
nie jeste� zadowolony z ich efekt�w, skontaktuj si� z opiekunem listy
pod adresem <#L#>-owner@<#H#>. 
Prosz� by� cierpliwym, opiekun listy jest o wiele wolniejszy
od komputera, kt�rym ja jestem ;-)
</text/bottom/>

--- Za��cznik jest kopi� polecenia, kt�re otrzyma�em.

</text/bounce-bottom/>

--- Za��cznik jest kopi� odrzuconego listu, kt�ry dosta�em.

</text/bounce-num/>

Na wszelki wypadek przechowuj� odrzucone listy z twojego adresu,
wys�ane na list� o nazwie <#L#>. Aby dosta� kopi� tych list�w
z archiuwm, np. listu o numerze 12345, wyslij pust� wiadomos�
na adres: <#L#>-get.12345@<#H#>.

</#ia/>
Aby zam�wi� list� tytu��w i autor�w stu ostatnich wiadomo�ci,
wy�lij pusty list na adres: <#L#>-index@<#H#>.

Aby dosta� p�czek list�w od 123 do 131 (maksymalnie 100 na jeden raz),
wy�lij pust� wiadomos� na adres:
<#L#>-get.123_145@<#H#>.

<//>
Poni�ej znajduj� sie numery list�w:

</text/dig-bounce-num/>

Trzymam indeks przesy�ek, kt�re nie zosta�y prawid�owo dor�czone
pod Tw�j adres z listy <#L#>-digest. Mam zachowany numer pierwszego
listu ka�dego przegl�du, z kt�rym mia�e� k�opoty. Mo�esz wi�c
spr�bowa� dosta� listy z archiwum g��wnego.

Aby dosta� list nr 12345 z archiwum, wy�lij pusty list na
adres: <#L#>-get.12345@<#H#>.

</#ia/>
Aby dosta� list� tytu��w i autor�w ostatnich stu list�w, wy�lij
pust� wiadomosc na adres: <#L#>-index@<#H#>.

Aby dosta� p�czek list�w od numeru 123 do 145 (maksymalnie sto naraz)
wy�lij pust� wiadomos� pod adres: <#L#>-get.123_145@<#H#>.

<//>
Poni�ej znajdziesz numery przegl�d�w listy:

</text/bounce-probe/>

Jeste� zapisany(a) na list� dyskusyjn� o nazwie <#l#>,
niestety listy z niej nie mog� do Ciebie dotrze�, gdy� s� odrzucane
przez tw�j serwer. Wys�a�em Ci ostrze�enie o tym fakcie,
ale i ono przepad�o... Nie miej wi�c do mnie �alu, je�li
zmuszony b�d� wykresli� Ci� z listy prenumerator�w, a nast�pi
to w przypadku, je�li i ten list nie zostanie przyj�ty przez Tw�j
serwer pocztowy.

</text/bounce-warn/>

Poczta kierowana do Ciebie z listy <#l#> jest odrzucana przez Tw�j serwer.
Za��czam kopi� pierwszej przesy�ki, z dostarczeniem kt�rej mia�em k�opoty.

Je�eli niniejszy list ostrzegawczy r�wnie� przepadnie, wy�l� Ci
przesy�k� testow�, kt�rej odbicie si� od Twojego adresu spowoduje
trwa�e wypisanie z pocztowej listy dyskusyjnej.

</text/digest#ia/>
Aby zaprenumerowa� przegl�d listy, napisz pod adres:
	<#L#>-digest-subscribe@<#H#>

Aby wykre�li� swo�j adres pocztowy z listy subskrybent�w, napisz pod adres:
	<#L#>-digest-unsubscribe@<#H#>

Aby wys�a� cokolwiek na list�, pisz pod adres:
	<#L#>@<#H#>

</#iax/>
	Opiekun listy pocztowej - 
        - <<#L#>-owner@<#H#>>

</text/get-bad/>
Przykro mi, tego listu nie ma w archiwum.

</text/help/>
Niestety nie poda�e� prawid�owego adresu prenumeraty.
List, kt�ry otrzyma�e�, jest niczym innym, jak standardow� instrukcj�
obs�ugi menad�era list dyskusyjnych zainstalowanego na naszym serwerze.
Mam nadziej�, �e teraz ju� sobie poradzisz.

</text/mod-help/>
Dzi�kuj� za zgod� na zostanie moderatorem listy o adresie:
<#L#>@<#H#>.

Moje komendy s� nieco inne, ni� bywaj� w programach obs�uguj�cych
pocztowe listy dyskusyjne. Mo�esz nawet na pocz�tku stwierdzi�, �e s�
niezwyk�e, ale jak tylko zaczniesz ich u�ywa�, docenisz prostot� systemu
oraz szybko��, z jak� obs�uguj� twoje �yczenia.

Poni�ej kilka s��w o tym, jak dzia�a moderowanie: 

Zdalne wpisanie na list� prenumerator�w
---------------------------------------
B�d�c moderatorem, mo�esz zapisa� lub wypisa� internaut�
o adresie janek@komputer-janka.domena poprzez wys�anie listu na adres:

<#L#>-subscribe-janek=komputer-janka.domena@<#H#>
<#L#>-unsubscribe-janek=komputer-janka.domena@<#H#>

</#g/>
Odpowiednio dla przegl�du listy:

<#L#>-digest-subscribe-janek=komputer-janka.domena@<#H#>
<#L#>-digest-unsubscribe-janek=komputer-janka.domena@<#H#>

<//>
To wszystko. Nie musisz nadawa� listowi tytu�u, nie musisz
r�wnie� pisa� nic w jego tre�ci!

</#r/>
Wy�l� Ci pro�b� o potwierdzenie 
Co zrobi� z moim listem?
Po prostu odpowiedz na niego i gotowe.
</#R/>
Wy�l� pro�b� o potwierdzenie ch�ci uczestnictwa na adres
autora listu.
Wystarczy, ze na te pro�be odpowie, a bedzie zapisany.
<//>

Zawiadomi� subskrybenta, je�eli jego/jej dane dotyczace
jego subskrybcji zostan� zmienione.

Prenumerata
-----------

Ka�dy mo�e zapisa� si� na list�, albo z niej wypisa�, poprzez
wys�anie listu na adres:

<#L#>-subscribe@<#H#>
<#L#>-unsubscribe@<#H#>

</#g/>
Obs�uga przegl�du listy:

<#L#>-digest-subscribe@<#H#>
<#L#>-digest-unsubscribe@<#H#>

Ch�tny otrzyma pro�be o potwierdzenie �yczenia wypisania si� z listy,
aby si� upewni� czy �yczenie to zosta�o rzeczywiscie przez niego
wys�ane. Je�eli zostanie to potwierdzone, zostanie usuni�ty 
z listy prenumerator�w.
Podobna procedura obowi�zuje podczas zapisywania si� na list�.

</#s/>
Podczas procedury zapisywania si� na list�, pro�ba
o potwierdzenie zapisu jest wysy�ana r�wnie� do moderatora listy.
Pozytywna odpowied� moderatora dope�ni zapisu na list�.
</#S/>
Zapisy funkcjonuj� w ten sam spos�b.
<//>

U�ytkownik mo�e r�wnie� u�ywa� adres�w:

<#L#>-subscribe-janek=komputer-janka.domena@<#H#>
<#L#>-unsubscribe-janek=komputer-janka.domena@<#H#>

aby poczta z listy w�drowa�a na inny adres bed�cy jego w�asno�ci�.
Tylko w�wczas, kiedy u�ytkownik dostaje listy na adres
janek@komputer-janka.domena, b�dzie w stanie odpowiedzie�
na �yczenie potwierdzenia skierowanego od menad�era listy.

Wszystkie powy�sze kroki s� przedsi�brane po to, by unika�
z�o�liwo�ci typu zapisanie kogo� wbrew jego woli na list�
oraz aby moderator m�g� by� pewnym, �e adres prenumeratora
rzeczywi�cie istnieje.

Tw�j rzeczywisty adres pocztowy nie b�dzie ujawniony prenumaratorowi.
Pozwoli to zachowa� Ci anonimowo��.

</#rl/>
Aby uzyska� list� prenumerator�w <#L#>@<#H#>, 
wy�lij list na adres:
   <<#L#>-list@<#H#>>

Chc�c uzyska� dziennik pok�adowy listy <#L#>@<#H#>,
wy�lij list na adres:
   <<#L#>-list@<#H#>>

</#rld/>
Adresy w�a�ciwe dla przegl�du listy:
   <<#L#>-digest-list@<#H#>>
i:
   <<#L#>-digest-log@<#H#>>

</#rn/>
Mo�esz zdalnie zmienia� pliki tekstowe, kt�rymi pos�uguje si� automat
podczas obs�ugi listy dyskusyjnej. Aby uzyska� zbi�r plik�w oraz
instrukcje, jak je zmienia�, napisz pod adres:
   <<#L#>-edit@<#H#>>

</#m/>
Przesy�ki moderowane
--------------------
Je�eli przesy�ki podlegaj� moderowaniu, umieszczam wys�ane listy
w kolejce pocztowej i wysy�am �yczenie przyjrzenia sie listowi do
moderatora.

Wystarczy, aby� odpowiedzia� na adres zwrotny tego listu, u�ywaj�c
funkcji "odpowiedz (reply)", aby zaakceptowa� tre�� listu. 

Je�eli natomiast chcesz odm�wi� zgody na wys�anie listu, wy�lij
poczt� na adres wzi�ty z nag��wka "From:" (mo�na zwykle tego
dokona� poprzez u�ycie opcji "reply-to-all/odpowiedz-na-wszystkie-
-adresy" i skasowanie z tej listy w�asnego adresu oraz adresu 
akceptuj�cego). Mo�esz r�wnie� doda� jak�� notk� do wysy�aj�cego
odrzucony przez Ciebie list, aby wyt�umaczy� mu, dlaczego to
uczyni�e�. Notk� dodajesz umieszczaj�c j� w tre�ci powy�szego listu
odrzucaj�cego, wstawiaj�c j� pomi�dzy dwie linie, zawieraj�ce
trzy znaki '%'.

Wezm� pod uwag� pierwszy list, kt�ry od Ciebie dostan�.
Je�eli wy�lesz najpierw potwierdzenie akceptacji listu, kt�ry
wcze�niej odrzuci�e�, lub odwrotnie, oczywi�cie Ci o tym powiem.

Je�eli nie dostan� odpowiedzi od moderatora przez okre�lony czas,
zwykle jest to pi�� dni, zwr�c� list nadawcy z opisem zaistnia�ej
sytuacji.
<//>

Wakacje
-------
Je�eli korzystasz tymczasowo z innego adresu, po prostu przekieruj
wszystkie listy z nag��wkiem 'Mailing-List:',
albo te, kt�rych tematy zaczynaj� si� s�owami
"MODERATE for <#L#>@<#H#>",
lub
"CONFIRM subscribe to <#L#>@<#H#>",
na nowy adres.
Mo�esz wtedy moderowa� z nowego adresu. Innym sposobem jest
przekierowanie tych list�w do przyjaciela, kt�ry mo�e Ci� zast�pi�.
Musisz oczywi�cie uzgodni� przedtem wszystko z opiekunem listy.

Je�eli chcesz automatycznie aprobowa� wszelkie przesy�ki kierowane
na list�, skonfiguruj sw�j program pocztowy tak, aby automatycznie
odpowiada� na listy maj�ce tematy zgodne z powy�szymi kryteriami.

</#r/>
Uwa�aj, je�eli b�dziesz pr�bowa� zdalnie zarz�dza� list� z adresu,
kt�ry nie jest wpisany jako adres administratora, prenumerator,
a nie Ty, zostanie poproszony o potwierdzenie, kt�re zostanie
potem przekazane do moderator�w.
Robi� tak, gdy� nie ma sposobu upewni� si� czy to rzeczywi�cie Ty
kryjesz si� za poczt� przychodz�c� z nieznanego adresu.

Pami�taj, �e w powy�szym wypadku Twoje �ycznie skierowane do serwera
i r�wnie� Tw�j adres s� przesy�ane do prenumeratora! Przestajesz by�
w�wczas anonimowy.
<//>

Powodzenia!

PS: Skontaktuj si�, prosz�, z opiekunem listy pod adresem
<#L#>-owner@<#H#>
je�eli masz jakie� pytania, lub napotkasz na problemy.

</text/mod-reject/>
Przykro mi, ale Tw�j list nie zosta� zaakceptowany przez moderatora.
Je�eli moderator uczyni� jakie� uwagi, zamieszczam je poni�ej.
</text/mod-request/>
Prosz� o decyzj� czy b�d�c moderatorem zgadzasz si� na wys�anie
za��czonej przesy�ki na list� o nazwie <#L#>.

Aby zgodzi� si� na natychmiastowe wys�anie listu do wszystkich
prenumerator�w, wy�lij, prosz�, list na adres:

# This does the default !A for normal setups, but puts in a 'mailto:address'
# for lists created with the -x switch.
!A
</#x/>

mailto:<#A#>
# Below is a minimalist tag. It just means that succeeding lines should be
# added to the currently open file in all cases.
<//>

Aby odm�wi� wys�ania listu, i zwr�ci� go nadawcy, prosz�
przes�a� wiadomos� na adres: 

!R
</#x/>

mailto:<#R#>
<//>

Nie musisz za��cza� kopii listu, kt�ry akceptujesz (lub nie) do
wys�ania na list�. Je�eli chcesz przes�a� jak�� notk� do nadawcy
odrzuconego listu, zawrzyj j� pomi�dzy dwie linie zaczynaj�ce si�
trzema znakami procentu ("%").

%%% Pocz�tek notki
%%% Koniec notki

Dzi�kuj� za pomoc!

--- W za��czniu mo�esz znale�� wys�any list.

</text/mod-sub#E/>
--- zapisa�em Ci� (lub wypisa�em) z listy
<#l#>@<#H#>
na �yczenie jej moderatora.

Je�li nie jest to dzia�anie, kt�rego pragn��e�, mo�esz
przes�a� swoje w�tpliwo�ci do opiekuna listy:
<#l#>-owner@<#H#>

Je�eli potrzebujesz informacji o tym, jak dosta� si� do archiwum
listy <#L#>, prze�lij pusty list na adres:
<#L#>-help@<#H#>

</text/mod-timeout/>
Przykro mi, ale moderatorzy nie zareagowali na Tw�j list.
Dlatego zwracam go Tobie, je�eli uwa�asz, �e kryje si� za tym
jaki� b��d maszyny, wy�lij list ponownie, albo skontaktuj si�
bezpo�rednio z moderatorem listy.

--- W za��czeniu Twoja oryginalna przesy�ka na list�.

</text/mod-sub-confirm/>
Bardzo prosz� o zgod� na dodanie internauty o adresie:

<#A#>

jako prenumeratora listy dyskusyjnej <#l#>.
Poniewa� powy�sze �yczenie mog�o nie pochodzi� od Ciebie (patrz
koniec listu), ju� zd��y�em potwierdzi�, �e internauta o adresie:
<#A#>
rzeczywiscie podobne �yczenie wys�a�.

Aby udzieli� zgody, prosz� wys�a� pust� odpowiedz na adres:

!R
</#x/>

mailto:<#R#>
<//>

Tw�j program pocztowy powienien automatycznie prawid�owo zaadresowa�
list, je�eli u�yjesz opcji "Odpowiedz/Reply".

Je�eli natomiast si� nie zgadzasz, po prostu zignoruj ten list.

Dziekuj� za pomoc!

</text/mod-unsub-confirm/>
Bardzo prosz� o Twoj� zgod� na usuni�cie internauty o adresie:

!A

z listy prenumerator�w listy <#l#>. 
Je�eli si� zgadzasz, wyslij, prosz�, pust� odpowiedz na adres:

!R
</#x/>

mailto:<#R#>
<//>

Tw�j program pocztowy powienien automatycznie prawid�owo zaadresowa�
list, je�eli u�yjesz opcji "Odpowiedz/Reply".

Dziekuj� za pomoc!

</text/sub-bad/>
Hmmm, numer potwierdzenia wydaje mi si� nieprawid�owy.

Najcz�stsz� przyczyn� nieprawid�owo�ci jest jego przeterminowanie.
Musz� dosta� potwierdzenie ka�dego �ycznia w ci�gu dziesi�ciu dni.
Mo�esz r�wnie� upewni� si� czy za��czy�e�(a�) ca�y numer potwierdzenia
w poprzednim liscie, niekt�re programy pocztowe maj� z�y nawyk
ucinania adres�w, kt�re wydaj� im si� zbyt d�ugie.

Przygotowa�em nowy numer potwierdzenia. Aby ponownie potwierdzi�
ch�� zapisania si� z adresu:

!A

na list� dyskusyjn� <#L#>, wy�lij pust� odpowied�
pod adres:

!R
</#x/>

mailto:<#R#>
<//>

Pami�taj, sprawd� dok�adnie czy zalaczy�e�(a�) pe�ny numer, oczywi�cie
uczy� to przed wys�aniem listu ;-)

Przepraszam za k�opoty.
Opiekun listy -
</#x/>
<#L#>-owner@<#H#>
<//>

</text/sub-confirm/>
Aby potwierdzi� ch�� zapisania si� z adresu:

!A

na list� dyskusyjn� o nazwie <#L#>,
wy�lij, prosz�, pust� odpowied� pod adres:

!R
</#x/>

mailto:<#R#>
<//>

Tw�j program pocztowy powienien automatycznie zaadresowa� przesy�k�,
je�eli u�yjesz opcji "odpowiedz/reply".

Potwierdzenie ma na celu
a) sprawdzenie si� czy potrafi� wysy�a� listy na adres przez Ciebie podany,
b) upewnienie si� czy ktos nie zrobi� Ci g�upiego dowcipu, zapisuj�c Ci�
   bez twojej wiedzy na nasz� list�.

</text/sub-confirm#s/>
Lista jest moderowana. Kiedy wys�a�e� ju� potwierdzenie, ch�� prenumeraty
zosta�a przes�ana moderatorowi. Zawiadomi� Ci� odr�bnym listem, je�li
zostaniesz wpisany(a) na list� prenumerator�w.

</text/sub-nop/>

Potwierdzenie: Adres poczty elektronicznej:

!A

jest ju� na li�cie prenumerator�w <#L#>. By� on ju� na li�cie
przed wys�aniem ponownej pro�by, a wi�c j� zignoruj�.

</text/sub-ok#E/>
Potwierdzenie: Doda�em adres

!A

do listy prenumerator�w <#L#>.

**** WITAJ NA LI�CIE <#L#>@<#H#>!

Prosz� o zachowanie tej przesy�ki, b�dziesz dzi�ki niej pami�ta�,
z kt�rego dok�adnie adresu jestes zapisany(a), informacja ta b�dzie
niezb�dna, je�li chcia�(a)by� kiedy� z listy si� wypisa� lub zmieni�
adres korespondencyjny.

</text/top/>
Czes�! Nazywam si� "ezmlm" i zarz�dzam serwerem pocztowych
list dyskusyjnych, mi�dzy innymi list� o nazwie:
<#L#>@<#H#>

</#x/>
Jestem komputerem, bezdusznym s�ug� opiekuna listy, cz�owieka :-),
kt�rego mo�na znale�� pod adresem:
<#L#>-owner@<#H#>.

</text/unsub-bad/>
Hmmm, numer potwierdzenia wydaje mi si� nieprawid�owy.

Najcz�stsz� przyczyn� nieprawid�owo�ci jest przeterminowanie,
musz� dosta� potwierdzenie ka�dego �ycznia w ci�gu dziesi�ciu dni.
Mo�esz r�wnie� upewni� si� czy za��czy�e�(a�) ca�y numer potwierdzenia
w poprzednim li�cie, niekt�re programy pocztowe maj� z�y nawyk
ucinania adres�w, kt�re wydaj� im si� zbyt d�ugie.

Przygotowa�em nowy numer potwierdzenia. Aby ponownie potwierdzi�
�e mam usun�� adres

!A

z listy prenumerator�w <#l#>, wy�lij pust� odpowiedz na adres:

!R
</#x/>

mailto:<#R#>
<//>

Pami�taj, sprawd� dokladnie czy za�aczy�e�(a�) pe�ny numer potwierdzenia,
uczy� to oczywi�cie przed wys�aniem listu ;-)

Przepraszam za k�opoty.
Opiekun -
<#L#>-owner@<#H#>

</text/unsub-confirm/>
Aby potwierdzi�, �e chcesz usunac adres

!A

z listy prenumarator�w <#L#>, prze�lij, prosz�, pust�
odpowied� na ten list pod adres:

!R
</#x/>

mailto:<#R#>
<//>

Tw�j program pocztowy powienien automatycznie zaadresowa� przesy�k�,
je�eli u�yjesz opcji "odpowiedz/reply".

Nie sprawdzi�em jednak czy tw�j adres znajduje si� na li�cie
prenumerator�w. Aby sprawdzi�, kt�rego adresu u�ywasz jako koresponde-
cyjnego, spojrzyj na jak�kolwiek wiadomos� z listy dyskusyjnej.
Ka�dy list ma schowany Tw�j adres w scie�ce zwrotnej; np.
B�g@niebo.prezydent.pl dostaje listy ze scie�k� zwrotn�:
<<#l#>-return-<number>-B�g=niebo.prezydent.pl@<#H#>.

</text/unsub-nop/>
Powiadomienie: Adresu pocztowego

!A

nie ma na li�cie prenumerator�w <#l#>. Nie by�o go r�wnie�
przed dosteniem Twojego �yczenia wykre�lenia z listy.. 

Je�eli wypisa�e�(a�) si�, lecz nadal dostajesz listy, jeste� po prostu
zapisany(a) z innego adresu, ni� ten, kt�rego w�a�nie u�ywasz.
Spojrzyj, prosz�, ma nag��wki kt�regokolwiek listu z prenumeraty,
znajdziesz tam fraz�:

'Return-Path: <<#l#>-return-1234-user=host.dom@<#H#>>'

W�a�ciwy adres, na kt�ry powinno wi�c trafi� twoje �yczenie wypisania to:
'<#l#>-unsubscribe-user=host.dom@<#H#>'.
Po prostu napisz na powy�szy adres, zamieniaj�c user=host.dom na twoje
prawdziwe dane, odpowiedz po�niej na pro�b� potwierdzenia, 
powieniene�(a�) w�wczas dosta� list, �e jeste� wykre�lony(a)
z listy prenumerator�w.

Je�eli moje rady nie skutkuj�, niestety nie mog� Ci ju� wi�cej pom�c.
Prze�lij, prosz�, jak�kolwiek przesy�k� z listy wraz z kr�tk� informacj�,
co chcesz osi�gn��, do opiekuna listy, pod adres:

</#x/>
mailto:<#L#>-owner@<#H#>
</#X/>
    <#l#>-owner@<#H#>
<//>

kt�ry to opiekun si� tym zajmie. We� pod uwag�, �e cz�owiek jest nieco
wolniejszy od komputera :-), wi�c b�d� cierpliwy(a).

</text/unsub-ok/>
Zawiadomienie: usun��em adres pocztowy

!A

z listy prenumerator�w <#l#>.
Na adres ten nie b�d� ju� przychodzi�y przesy�ki z listy.

</text/edit-do#n/>
Przer�b, prosz�, za��czony tekst i wy�lij go na adres:

!R

Tw�j program powienien uczyni� to automatycznie, je�eli u�yjesz
funkcji "reply/odpowiedz".

Mog� bez k�opotu usun�� dodatki jakie mo�e dodawa� do tekst�w
Tw�j program pocztowy, je�eli zachowasz linie znacznik�w.

Linie znacznik�w s� to linie rozpoczynaj�ce si� "%%%".
Nie mog� one by� zmienione, dodatkowe znaki dodane przez program
pocztowy na pocz�tku linii s� dozwolone.


</text/edit-list#n/>
Pliki <#L#>-edit.nazwa_pliku mog� by� stosowane przez zdalnego
administratora do edycji tekst�w zarz�dczych listy dyskusyjnej.

Tabela pod spodem jest list� plik�w wraz z kr�tkim opisem
ich dzia�ania. Aby zamieni� okre�lony plik, po prostu wy�lij
pusty list na adres <#L#>-edit.nazwa_pliku ,
zamieniaj�c wyra�enie 'nazwa_pliku' nazw� zamienianego pliku.
Instrukcja sposobu zamiany pliku zostanie dostarczona wraz ze
starym plikiem poczt� zwrotn�.

File                Use

bottom              sp�d ka�dej odpowiedzi administracyjnej. G��wne komendy.
digest              administracyjna cz�� przegl�du listy.
faq                 najcz�ciej zadawane pytania na naszej li�cie.
get_bad             tekst w miejsce listu nie znalezionego w archiwum.
help                g��wna tre�� pomocy.
info                informacje o naszej li�cie.
mod_help            pomoc dla moderator�w list.
mod_reject          list przesy�any nadawcy przesy�ki nie zaakceptowanej.
mod_request         tekst przesy�any razem z pro�b� moderowania.
mod_sub             tekst przesy�any prenumeratorowi po zaakceptowaniu.
mod_sub_confirm     tekst do moderatora z pro�b� o wpisanie na list�.
mod_timeout         do nadawcy przterminowanego listu.
mod_unsub_confirm   do zdalnego opiekuna z pro�b� o potwierdzenie wypisu.
sub_bad             do prenumaratora, je�eli potwierdzenie by�o z�e.
sub_confirm         do prenumeratora z pro�b� dokonania potwierdzenia.
sub_nop             tre�� listu powitalnego dla ponownie subskrybuj�cego.
sub_ok              tre�� listu powitalnego dla nowozapisanego.
top                 pocz�tek ka�dego listu, ostro�nie!
</#tn/>
trailer             tekst dodawany do ka�dego listu, ostro�nie!
</#n/>
unsub_bad           do prenumeratora, je�li jego potwierdzenie jest z�e.
unsub_confirm       tre�� potwierdzenia po �yczeniu wypisania si� z listy.
unsub_nop           do osoby nie b�d�cej prenumeratorem, wypisuj�cej si�.
unsub_ok            list po�egnalny do rezygnuj�cego z prenumeraty.

</text/edit-done#n/>
Plik tekstowy zosta� szcz�liwie zamieniony.

</text/info#E/>
Nie mam �adnych informacji na temat listy :-(
</text/faq#E/>
FAQ - najcz�ciej zadawane pytania na li�cie
<#l#>@<#H#>.

Jeszcze nic tu nie ma :-(, przepraszamy!


