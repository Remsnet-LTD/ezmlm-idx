0.40 - This version identifier must be on line 1 and start in pos 1.
#
#$Id$
#
# ezmlmrc- Traducci�n de: Vicent Mas, Francesc Alted, Sonia Lorente, Cyndy DePoy
# #######   Servicom2000
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
|<#B#>/ezmlm-issubn -n '<#D#>/deny' || { echo "Sorry, I've been told to reject your posts. Contact <#L#>-owner@<#H#> if you have questions about this (#5.7.2)"; exit 100 ; }
# switch -u=> restrict to subs of list & digest. If not m
# do it with ezmlm-issubn, if 'm' do it with ezmlm-gate
</#uM/>
|<#B#>/ezmlm-issubn '<#D#>' '<#D#>/digest' '<#D#>/allow' '<#D#>/mod' || { echo "Sorry, only subscribers may post. If you are a subscriber, please forward this message to <#L#>-owner@<#H#> to get your new address included (#5.7.2)"; exit 100 ; }
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
contact <#L#>-help@<#H#>; run by ezmlm
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
Para dar de baja la suscripci�n, mande un mensaje a:

   <#L#>-unsubscribe@<#H#>

Para obtener el resto de direcciones-comando, mande un mensaje a:

   <#L#>-help@<#H#>

</text/bottom#E/>

--- Comandos administrativos para la lista <#l#> ---

Puedo gestionar autom�ticamente peticiones administrativas. Por
favor, no env�e este tipo de peticiones a la lista. Env�elas a la
direcci�n-comando adecuada:

Para obtener ayuda y una descripci�n de los comandos disponibles,
mande un mensaje a:

   <<#L#>-help@<#H#>>

Para suscribirse a la lista, mande un mensaje a:

   <<#L#>-subscribe@<#H#>>

Para eliminar su direcci�n de la lista, simplemente mande un
mensaje a la direcci�n que hay en la cabecera
``List-Unsubscribe'' de cualquier mensaje de la lista. Si usted
no ha cambiado su direcci�n desde que se suscribi�, tambi�n puede
enviar un mensaje a:

   <<#L#>-unsubscribe@<#H#>>

</#dE/>
o, para los res�menes, a:

   <<#L#>-unsubscribe@<#H#>>

</#E/>

Para a�adir o eliminar direcciones, le enviar� un mensaje de
confirmaci�n a esa direcci�n. Cuando lo reciba, pulse el bot�n
'Responder' para completar la transacci�n.

Si necesita contactar con el propietario de la lista, por favor,
mande un mensaje a:

    <<#L#>-owner@<#H#>>

Por favor, incluya una lista de mensajes REENVIADOS con TODAS LAS
CABECERAS intactas para que sea m�s f�cil ayudarle.

--- Le adjunto una copia de la petici�n que he recibido.

</text/bounce-bottom#E/>

--- Le adjunto una copia del mensaje devuelto que he recibido.

</text/bounce-num#E/>

He guardado una lista de todos los mensajes de la lista de correo
<#L#> que han sido devueltos procedentes de su direcci�n.

</#aE/>

Una copia de estos mensajes puede estar en el archivo.

</#aE/>

Para recibir los mensajes desde el n�mero 123 al 145 (con un
m�ximo de 100 por petici�n), escriba a:

   <<#L#>-get.123_145@<#H#>>

Para recibir una lista por "Asunto" y "Autor" de los �ltimos 100
mensajes, env�e un mensaje en blanco a:

   <<#L#>-index@<#H#>>

</#E/>
Aqu� est�n los n�meros de los mensajes:

</text/dig-bounce-num#E/>

He guardado una lista de los res�menes de la lista de correo
<#L#> que han sido devueltos desde su direcci�n. Por cada uno de
los res�menes perdidos, he anotado el n�mero del primer mensaje
en el resum�n.

</#aE/>

No archivo los res�menes propiamente dichos, pero puede conseguir
los mensajes del archivo principal de la lista.

Para recuperar el grupo de mensajes del 123 al 145 (m�ximo 100
por petici�n), env�e un mensaje en blanco a:

   <<#L#>-get.123_145@<#H#>>

Para recibir una lista por "Asunto" y "Autor" de los �ltimos 100
mensajes, env�e un mensaje en blanco a:

   <<#L#>-index@<#H#>>

</#E/>
Estos son los n�meros de mensaje de los res�menes:

</text/bounce-probe#E/>

Parece que han sido devueltos algunos mensajes dirigidos a usted
de la lista de correo <#l#>. Le he enviado un mensaje de aviso,
pero tambi�n ha sido devuelto. Le adjunto una copia del mensaje
devuelto.

Esta es una prueba para comprobar si su direcci�n es accesible.
Si esta prueba me es devuelta, eliminar� su direcci�n de la lista
de correo <#l#>@<#H#>, sin m�s avisos. En ese caso, puede usted
volver a suscribirse mandando un mensaje a esta direcci�n:

   <<#l#>-subscribe@<#H#>>

</text/bounce-warn#E/>

Han sido devueltos algunos mensajes para usted de la lista de
correo <#l#>. Le adjunto una copia del primer mensaje devuelto
que recib�. Si tambi�n se devuelve este mensaje, le mandar� una
prueba. Si se devuelve la prueba, eliminar� su direcci�n de la
lista de correo <#l#> sin m�s avisos.

</text/digest#dE/>
Para suscribirse al resumen escriba a:

	<#L#>-digest-subscribe@<#H#>

Para cancelar su suscripci�n al resumen, escriba a:

	<#L#>-digest-unsubscribe@<#H#>

Para mandar un mensaje a la lista, escriba a:

	<#L#>@<#H#>

</text/get-bad#E/>
Lo siento, ese mensaje no est� en el archivo.

</text/help#E/>

Este es un mensaje gen�rico de ayuda. El mensaje que recib� no
fue mandado a ninguna de mis direcciones-comando.

Aqu� hay una lista de las direcciones comando disponibles:

Mande un correo a las siguientes direcciones-comando para obtener
informaci�n y FAQ de esta lista:

   <<#L#>-info@<#H#>>
   <<#L#>-faq@<#H#>>

</#dE/>
Para la lista de res�menes existen direcciones-comando an�logas:

   <<#L#>-digest-subscribe@<#H#>>
   <<#L#>-digest-unsubscribe@<#H#>>

# ezmlm-make -i needed to add ezmlm-get line. If not, we can't do
# multi-get!
</#aE/>

Para recibir los mensajes desde el n�mero 123 al 145 (con un
m�ximo de 100 por petici�n), escriba a:

   <<#L#>-get.123_145@<#H#>>

Para obtener un �ndice con los campos "Asunto" y "Autor" para los
mensajes del 123 al 456, debe escribir a:

   <<#L#>-index.123_456@<#H#>>

Para recibir todos los mensajes con el mismo "Asunto" que el
mensaje 12345, mande un mensaje en blanco a:

   <<#L#>-thread.12345@<#H#>>

</#E/>

En realidad no es necesario que los mensajes est�n en blanco,
pero si no lo est�n ignorar� su contenido. S�lo es importante la
DIRECCI�N a la que se env�a.

Usted puede suscribir una direcci�n alternativa, por ejemplo,
para "david@ordenador.dominio", simplemente a�ada un gui�n y su
direcci�n (con '=' en lugar de '@') despu�s del comando:

   <<#L#>-subscribe-david=ordenador.dominio@<#H#>>

Para cancelar la suscripci�n de esta direcci�n, escriba a:

<<#L#>-unsubscribe-david=ordenador.dominio@<#H#>>

</text/mod-help#E/>
Gracias por acceder a moderar la lista <#L#>@<#H#>.

Mis comandos son algo distintos a los de otras listas de correo,
pero creo que los encontrar� intuitivos y f�ciles de utilizar.

Estas son algunas instrucciones para las tareas que debe realizar
como propietario y/o moderador de una lista de correo.

Al final del mensaje se incluyen algunas instrucciones generales
para la lista.

Suscripci�n remota
-------------------

Como moderador, puede a�adir o quitar cualquier direcci�n de la
lista. Para suscribir "david@ordenador.dominio", basta con poner
un gui�n despu�s del comando, y despu�s su direcci�n con '=' en
lugar de '@'. Por ejemplo, para suscribir esa direcci�n, mande
correo a:

   <<#L#>-subscribe-john=host.domain@<#H#>>

De la misma manera puede eliminar la direcci�n de la lista
mandando un mensaje a:

   <<#L#>-unsubscribe-john=host.domain@<#H#>>

</#dE/>
Para suscribirse o darse de baja de la lista de res�menes:

   <<#L#>-digest-subscribe-john=host.domain@<#H#>>
   <<#L#>-digest-unsubscribe-john=host.domain@<#H#>>

</#E/>

Eso es todo. No es necesario poner "Asunto" o cuerpo principal en
el mensaje.

</#rE/>

Le mandar� una petici�n de confirmaci�n, para asegurarme que
usted me envi� la petici�n. Simplemente responda al mensaje, y se
cursar� su petici�n. </#RE/> Mandar� una petici�n de confirmaci�n
a la direcci�n del usuario, en este caso a
<david@ordenador.dominio>. El usuario simplemente debe responder
a este mensaje de confirmaci�n. </#E/>

Las confirmaciones son necesarias para impedir, en la medida de
lo posible, que un tercero a�ada o quite una direcci�n de la
lista.

Notificar� al usuario cualquier cambio en el estado de su
suscripci�n.

Suscripci�n
------------

Cualquier usuario puede suscribirse o darse de baja mandando un
correo a:

   <#L#>-subscribe@<#H#>
   <#L#>-unsubscribe@<#H#>

</#dE/>
Para la lista de res�menes:

   <#L#>-digest-subscribe@<#H#>
   <#L#>-digest-unsubscribe@<#H#>

</#E/>

El usuario recibir� una petici�n de confirmaci�n para asegurarse
que �l/ella posee la direcci�n de suscripci�n. Una vez
verificada, se proceder� a dar de baja al usuario.

</#sE/>

Como esta lista est� moderada para suscripciones, mandar� una
segunda petici�n de confirmaci�n al moderador. Como el usuario ya
ha confirmado su deseo de estar en la lista, usted, como
moderador, puede estar seguro de que la direcci�n del suscriptor
es real. Si quiere aprobar la petici�n del usuario, simplemente
responda a mi mensaje de confirmaci�n. En caso contrario, puede
simplemente borrar mi mensaje o contactar con el suscriptor para
pedir m�s informaci�n.

</#SE/>
Las suscripciones funcionan del mismo modo.
</#E/>

El usuario tambi�n puede utilizar:

   <<#L#>-subscribe-maria=ordenador.dominio@<#H#>>
   <<#L#>-unsubscribe-maria=ordenador.dominio@<#H#>>

para que le manden correo a: "maria@ordenador.dominio". Solo si
ella recibe correo en esta direcci�n, podr� recibir la petici�n
de confirmaci�n y mandar una contestaci�n.

Su direcci�n e identidad no ser�n reveladas al suscriptor, a no
ser que le mande correo directamente al usuario.

</#rlE/>

Para conseguir una lista de suscriptores para <#L#>@<#H#> env�e
un mensaje a:

   <<#L#>-list@<#H#>>

Para conseguir un log de la lista de transacciones para
<#L#>@<#H#> mande un mensaje a:

   <<#L#>-log@<#H#>>

</#rldE/>
Para suscriptores al resumen:

   <<#L#>-digest-list@<#H#>>

y:

   <<#L#>-digest-log@<#H#>>

</#rnE/>

Usted puede modificar remotamente los ficheros de texto que
componen las respuestas mandadas por la lista. Para conseguir una
lista de ficheros e instrucciones de edici�n, escriba a:

   <<#L#>-edit@<#H#>>

</#mE/>
Mensajes moderados.
-------------------

Cuando los mensajes est�n moderados, guardar� el mensaje enviado
y le mandar� una copia junto con instrucciones. El mensaje para
usted llevar� "MODERATE for ..." como "Asunto".

Para aceptar el mensaje, simplemente responda a la direcci�n que
figura en el campo 'Responder a:' , que ya he configurado con la
direcci�n correcta de aceptaci�n. No necesita incluir el mensaje
en s�. De hecho, ignorar� el contenido siempre y cuando la
direcci�n a la que escriba sea correcta.

Si quiere rechazar el mensaje, mande un correo a la direcci�n
'De:', que ya he configurado con la direcci�n correcta de
"rechazo". Eso normalmente se hace con 'Responder a todos', y
borrando despu�s todas las direcciones salvo la direcci�n
"rechazada". Puede a�adir un comentario al remitente insertando
dicho comentario entre dos l�neas que empiecen con tres '%'. Solo
mandar� este comentario al remitente con el mensaje rechazado.
Una vez m�s, no revelar� su identidad.

Procesar� el mensaje en funci�n de la primera respuesta que
recibo. Le avisar� si me manda una petici�n para aceptar un
mensaje que, Previamente, hab�a sido rechazado o viceversa.

Si no recibo respuestas del moderador dentro de un cierto periodo
de tiempo (normalmente 5 d�as), devolver� el mensaje al remitente
con una explicaci�n de lo que ha pasado. Su administrador tambi�n
puede configurar la lista para que estos mensajes "ignorados"
simplemente sean borrados sin notificaci�n, en lugar de ser
devueltos al remitente.

</#E/>

Vacaciones
----------

Si est� temporalmente en otra direcci�n, simplemente reenv�e
todos los mensajes que tienen el encabezamiento 'Mailing-List:'
(o todos los que tienen "Asunto" empezando con 'MODERATE for
<#L#>@<#H#>' o con 'CONFIRM subscribe to <#L#>@<#H#>') a la nueva
direcci�n. As� podr� leer la lista desde la nueva direcci�n. Como
alternativa, puede reenviar los mensajes a un amigo para que �l o
ella los lea en su lugar. Por favor, antes de hacerlo consiga el
permiso del propietario de la lista.

Si desea aprobar autom�ticamente todas las peticiones mientras
est� fuera, configure su programa de correo para responder
autom�ticamente a mensajes que tienen un "Asunto" que re�na los
criterios anteriormente expuestos.

</#rE/>

Si intenta administrar la lista remotamente, desde una direcci�n
que no es la suya, el suscriptor cuya direcci�n est� utilizando,
y no usted, recibir� la petici�n de confirmaci�n. Entonces, se
mandar� una petici�n de confirmaci�n a todos los moderadores.
Hago esto porque no tengo manera de saber que usted realmente ha
mandado la petici�n original.

En este caso, �Recuerde que se manda su petici�n original (y su
direcci�n) al suscriptor!

</#E/>

�Buena suerte!

PD: Por favor, p�ngase en contacto con el propietario de la lista
(<#L#>-owner@<#H#>) si tiene preguntas o problemas.

</text/mod-reject#E/>

Lo siento, el mensaje que le adjunto no fue aceptado por el
moderador. Si el moderador ha hecho alg�n comentario, aparecer�
en la parte inferior.

</text/mod-request#E/>

El mensaje adjunto fue mandado a la lista de correo <#L#>@<#H#>.

Si desea aprobar su distribucisn a todos los suscriptores, por
favor, escriba a:

!A

Normalmente esto ocurre al pulsar el bot�n "responder". Usted
puede comprobar la direcci�n para asegurarse de que empieza por
"<#L#>-accept" . Si esto no funciona, simplemente copie la
direcci�n y p�guela en el campo "Para:" de un nuevo mensaje.
</#xE/>

Como alternativa haga clic aqu�:

	mailto:<#A#>
</#E/>

Para rechazar el mensaje y hacer que sea devuelto al remitente,
por favor, mande un mensaje a:

!R

Normalmente, lo m�s f�cil es hacer clic en el bot�n "Responder a
todos" y luego quitar todas las direcciones menos la que empieza
con "<#L#>-reject".
</#xE/>

Como alternativa, haga clic aqu�:
	mailto:<#R#>
</#E/>

No es necesario copiar el mensaje en su respuesta para aceptarlo
o rechazarlo. Si desea mandar un comentario al remitente de un
mensaje rechazado, por favor, incl�yalo entre dos l�neas que
empiezan con tres signos de porcentaje ('%'):

%%% Inicio del comentario
%%% Fin del comentario

�Gracias por su ayuda!

--- Se adjunta el mensaje enviado.

</text/mod-sub#E/>

--- Le he suscrito o dado de baja por petici�n del moderador de
la lista de correo <#l#>@<#H#>.

Si no est� de acuerdo con esta acci�n, por favor, mande una queja
u otros comentarios al propietario de la lista
(<#l#>-owner@<#H#>) tan pronto como le sea posible.

</text/mod-timeout#E/>

Lo siento, los moderadores de la lista <#L#> no han procesado su
mensaje. Por esa raz�n, se lo devuelvo. Si cree que esto es un
error, por favor, vuelva a mandar el mensaje o p�ngase en
contacto con el moderador de la lista directamente.

--- Le adjunto el mensaje que mand�.

</text/mod-sub-confirm#E/>
Respetuosamente pido permiso para a�adir

!A

a los suscriptores de la lista de correo <#l#>. Esta petici�n o
procede de usted o ha sido ya verificada por el suscriptor.

Para confirmar, por favor, env�e un mensaje en blanco a esta
direcci�n:

!R

Normalmente esto ocurre al pulsar el bot�n "Responder". Si esto
no funciona, simplemente copie la direcci�n y p�guela en el campo
"Para:" de un nuevo mensaje. </#xE/>

o haga clic aqu�:

	mailto:<#R#>
</#E/>

Si no est� de acuerdo, simplemente ignore este mensaje. 

�Gracias por su ayuda!

</text/mod-unsub-confirm#E/>
Se ha hecho una petici�n para eliminar

!A

de la lista de correo <#l#>. Si est� de acuerdo, por favor, env�e
un mensaje en blanco a esta direcci�n:

!R

Normalmente, esto ocurre al pulsar el bot�n "Responder". Si esto
no funciona, simplemente copie la direcci�n y p�guela en el campo
"Para:" de un nuevo mensaje. 
</#xE/>

o haga clic aqu�:

	mailto:<#R#>
</#E/>

Si no est� de acuerdo, simplemente ignore este mensaje. 

�Gracias por su ayuda!

</text/sub-bad#E/>
�Vaya!, parece que el n�mero de confirmaci�n no es v�lido. 

La principal causa por la que los n�meros se invalidan es su
expiraci�n. Yo tengo que recibir confirmaci�n de cada petici�n en
un plazo de diez d�as. Adem�s, aseg�rese de que el n�mero de
confirmaci�n completo estaba incluido en la respuesta que me
mand�. Algunos programas de correo tienen la (mala) costumbre de
cortar parte de la direcci�n de respuesta, que puede ser muy
larga.

He configurado un nuevo n�mero de confirmaci�n. Para confirmar
que le gustar�a que

!A

fuese a�adida a la lista de correo <#l#>, por favor, mande un
mensaje en blanco a esta direcci�n:

!R
</#xE/>

o haga clic aqu�:

	mailto:<#R#>
</#E/>

De nuevo, compruebe cuidadosamente la direcci�n de la respuesta
para asegurarse que est� todo incluido antes de confirmar su
suscripci�n.

Perdone las molestias.

	<#L#>-Propietario <<#l#>-owner@<#H#>>

</text/sub-confirm#E/>
Para confirmar que le gustar�a que

!A

fuese a�adido a la lista de correo <#l#>, por favor, env�e un
mensaje en blanco a esta direcci�n:

!R

Normalmente esto ocurre al pulsar el bot�n "Responder". Si eso no
funciona, es suficiente copiar la direcci�n y pegarla en el campo
"Para:" de un nuevo mensaje. 
</#xE/>

o haga clic aqu�:

	mailto:<#R#>
</#E/>

Esta confirmaci�n cumple dos prop�sitos. Primero, verifica que
puedo mandarle correo. Segundo, le protege en el caso de que
alguien intente falsificar una petici�n de suscripci�n en su
nombre.

</#qE/>

Algunos programas de correo no pueden manejar direcciones largas.
Si no puede responder a esta petici�n, env�e un mensaje a
<<#L#>-request@<#H#>> y ponga la direcci�n entera escrita arriba
en la l�nea de "Asunto:".

</#sE/>

Esta lista est� moderada. Una vez que haya enviado esta
confirmaci�n, se mandar� la petici�n al moderador de la lista.
Cuando su suscripci�n haya sido activada, se lo notificar�.

</text/sub-nop#E/>
No he conseguido cursar su petici�n: La direcci�n

!A

ya estaba en la lista de correo <#l#> cuando recib� su petici�n,
y usted sigue siendo suscriptor.

</text/sub-ok#E/>
Acuse de recibo: He a�adido la direcci�n

!A

A la lista de correo <#l#>.

�Bienvenido a <#l#>@<#H#>!

Por favor guarde este mensaje para que sepa bajo que direcci�n
est� suscrito, por si luego quiere cancelar su suscripci�n o
cambiar la direcci�n de la misma.

Para cancelar su suscripci�n mande un mensaje a:

    <<#l#>-unsubscribe-<#t#>@<#H#>>

</text/top/>

�Hola! Soy el programa ezmlm. Me ocupo de la lista de correo
<#l#>@<#H#>.

</#x/>

Estoy trabajando para mi propietario, a quien se puede localizar
en <#l#>-owner@<#H#>.

</text/unsub-bad#E/>
�Vaya!, parece que ese n�mero de confirmaci�n es inv�lido. 

La principal raz�n por la que los n�meros de confirmaci�n se
invalidan es la expiraci�n. Debo recibir confirmaci�n de cada
petici�n en un plazo de diez d�as. Adem�s, aseg�rese que el
n�mero completo de confirmaci�n estaba incluido en la respuesta
que me mand�. Tenga en cuenta que algunos programas de correo
tienen la (mala) costumbre de cortar parte de la direcci�n de
respuesta, que puede ser muy larga.

He configurado un nuevo n�mero de confirmaci�n. Para confirmar
que le gustar�a que

!A

fuese dado de baja en la lista de correo <#l#>, por favor, mande
un mensaje en blanco a esta direcci�n:

!R
</#xE/>

o haga clic aqu�:

	mailto:<#R#>
</#E/>

De nuevo, compruebe la direcci�n de respuesta cuidadosamente para
asegurarse que est� todo incluido antes de confirmar esta acci�n.

Perdone las molestias.

	<#l#>-Owner <<#l#>-owner@<#H#>>

</text/unsub-confirm#E/>
Para confirmar que le gustar�a que

!A

sea dado de baja de la lista de correo <#l#>, por favor, mande un
mensaje en blanco a esta direcci�n:

!R

Normalmente esto ocurre al pulsar el bot�n "Responder". Si no
funciona, simplemente copie la direcci�n y p�guela en el campo
"Para:" de un nuevo mensaje. 
</#xE/>

o haga clic aqu�:

	mailto:<#R#>
</#E/>

No he comprobado si su direcci�n est� actualmente en la lista de
correo. Para ver que direcci�n utiliz� para suscribirse, mire los
mensajes que est� recibiendo de la lista de correo. Cada mensaje
tiene su direcci�n oculta dentro de la ruta de retorno; por
ejemplo, maria@xdd.ff.com recibe mensajes con la ruta de retorno:
<<#l#>-return-<n�mero>-maria=xdd.ff.com@<#H#>>.

</#qE/>

Algunos programas de correo no pueden manejar direcciones largas.
Si no puede responder a esta petici�n, env�e un mensaje a
<<#L#>-request@<#H#>> y escriba la direcci�n completa en la l�nea
de "Asunto:".

</text/unsub-nop#E/>
Lo siento, no he podido cursar su petici�n porque la direcci�n

!A

no estaba en la lista de correo <#l#> cuando recib� su petici�n y
no es suscriptor de esta lista.

Si se da de baja, pero sigue recibiendo correo, es que est�
suscrito con una direcci�n distinta a la que usa actualmente. Por
favor, busque en las cabeceras el texto:

'Return-Path: <<#l#>-return-1234-user=host.dom@<#H#>>'

La direcci�n para dar de baja a este usuario ser�a:
'<#l#>-unsubscribe-user=host.dom@<#H#>'.

Simplemente escriba a esa direcci�n, tras modificarla con la
verdadera direcci�n de suscripci�n.

Si el mensaje tiene una cabecera ``List-Unsubscribe:'' puede
usted mandar un mensaje a la direcci�n de esa cabecera. La
cabecera ya contiene la petici�n de suscripci�n.

En algunos programas de correo, necesitar� hacer visibles los
encabezamientos para ver el campo de retorno:

Con Eudora 4.0, haga clic en el bot�n "Blah blah ...". Con
PMMail, haga clic en "Window->Show entire message/header".

Si esto tampoco da resultado, siento decirle que no le puedo
ayudar. Por favor, reenv�e el mensaje junto con una nota sobre lo
que est� intentando hacer y una lista de direcciones bajo las
cuales puede estar suscrito, a mi propietario:

    <#l#>-owner@<#H#>

que se ocupar� de todo. Mi propietario es un poco m�s lento que
yo; por favor, tenga paciencia.

</text/unsub-ok#E/>
Acuse de recibo: He dado de baja la direcci�n

!A

de la lista de correo <#l#>. Esta direcci�n ya no est� suscrita.

</text/edit-do#nE/>

Por favor edite el siguiente fichero de texto y env�elo a esta
direcci�n:

!R

Su programa de correo deber�a tener la opci�n "Responder" que
utiliza esta direcci�n autom�ticamente.

Puedo quitar las comillas que su programa a�ade al texto, siempre
y cuando usted no modifique las l�neas marcadoras (las que
empiezan con '%%%'). Estas l�neas no deben ser modificadas (solo
son tolerados caracteres a�adidos por su programa de correo al
principio de la l�nea).

</text/edit-list#nE/>

El comando <#L#>-edit.file puede ser utilizado por un
administrador remoto para modificar los ficheros de texto que
componen la mayor�a de las respuestas de la lista de correo
<#L#>@<#H#>.

Lo que sigue es un listado de los ficheros de respuesta y una
corta indicaci�n de cuando se utilizan sus contenidos. Para
modificar un fichero, simplemente env�e un correo a
<#L#>-edit.fichero, sustituyendo 'fichero' por el nombre del
fichero. Las instrucciones para las modificaciones se env�an con
el fichero.

File                Use

bottom        final de todas las respuestas. Informaci�n general
              sobre comandos.	      
digest        secci�n administrativa de res�menes. 
faq           preguntas frecuentes propias de esta lista.
get_bad       en lugar de mensajes no encontrados en el archivo.
help          ayuda general (entre 'top' y 'bottom').
info          informaci�n sobre la lista. La primera l�nea debe
              tener significado por s� misma. 
mod_help      ayuda espec�fica para moderadores.
mod_reject    al remitente del mensaje rechazado.
mod_request   a los moderadores de mensajes junto a los mensajes.
mod_sub       al suscriptor despu�s de que el moderador confirme
              la suscripci�n.
mod_sub_confirm  al moderador para pedir confirmaci�n de 
                 suscripci�n.
mod_timeout   al remitente de correo caducado.  
mod_unsub_confirm  al administrador remoto para pedir confirmaci�n
                   de baja.
sub_bad       al suscriptor si la confirmaci�n no fue correcta.
sub_confirm   al suscriptor para pedir confirmaci�n de 
              suscripci�n.
sub_nop       al suscriptor despu�s de re-suscribirse.
sub_ok        al suscriptor despu�s de la suscripci�n. 
top           el principio de todas las respuestas.
</#tnE/>
trailer       a�adido a todos los mensajes enviados de la lista.
</#nE/>
unsub_bad     al suscriptor si la confirmaci�n de baja fue 
              incorrecta.
unsub_confirm al suscriptor para pedir confirmaci�n de 
              cancelaci�n.
unsub_nop     al no suscriptor despu�s de darse de baja.
unsub_ok      al ex suscriptor despu�s de darse de baja.

</text/edit-done#nE/>
El fichero de texto fue actualizado correctamente.
</text/info#E/>
No se ha proporcionado informaci�n para esta lista.
</text/faq#E/>
FAQ - Preguntas m�s comunes para la lista <#l#>@<#H#>.

Ninguno disponible todav�a. 


