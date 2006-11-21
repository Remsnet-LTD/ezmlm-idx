/*$Id$*/

#include "byte.h"
#include "case.h"
#include "cookie.h"
#include "date822fmt.h"
#include "datetime.h"
#include "die.h"
#include "error.h"
#include "errtxt.h"
#include "fmt.h"
#include "getln.h"
#include "idx.h"
#include "lock.h"
#include "log.h"
#include "makehash.h"
#include "open.h"
#include "qmail.h"
#include "readwrite.h"
#include "scan.h"
#include "slurp.h"
#include "str.h"
#include "stralloc.h"
#include "strerr.h"
#include "sub_std.h"
#include "subhash.h"
#include "subscribe.h"
#include "substdio.h"
#include "uint32.h"
#include <libpq-fe.h>
#include <libpq-fe.h> 
#include <stdlib.h>
#include <unistd.h>

static char strnum[FMT_ULONG];
static stralloc addr = {0};
static stralloc domain = {0};
static stralloc lcaddr = {0};
static stralloc line = {0};
static stralloc logline = {0};
static stralloc quoted = {0};

static void die_write(void)
{
  strerr_die3x(111,FATAL,ERR_WRITE,"stdout");
}

static const char *_opensub(struct sqlinfo *info)
{
  if (info->conn == 0) {
    /* Make connection to database */
    strnum[fmt_ulong(strnum,info->port)] = 0;
    info->conn = PQsetdbLogin(info->host,info->port?strnum:"",NULL,NULL,
			      info->db,info->user,info->pw);
    /* Check  to see that the backend connection was successfully made */
    if (PQstatus((PGconn*)info->conn) == CONNECTION_BAD)
      return PQerrorMessage((PGconn*)info->conn);
  }
  return (char *) 0;
}

static void _closesub(struct sqlinfo *info)
/* close connection to SQL server, if open */
{
  if ((PGconn*)info->conn)
    PQfinish((PGconn*)info->conn);
  info->conn = 0;		/* Destroy pointer */
}

static const char *_checktag(struct sqlinfo *info,
			     unsigned long num,	/* message number */
			     unsigned long listno, /* bottom of range => slave */
			     const char *hash)		/* cookie */
/* reads dir/sql. If not present, returns success (NULL). If dir/sql is    */
/* present, checks hash against the cookie table. If match, returns success*/
/* (NULL), else returns "". If error, returns error string. */
{
  PGresult *result;

    /* SELECT msgnum FROM table_cookie WHERE msgnum=num and cookie='hash' */
    /* succeeds only is everything correct. 'hash' is quoted since it is  */
    /* potentially hostile. */
    if (listno) {			/* only for slaves */
      if (!stralloc_copys(&line,"SELECT listno FROM ")) return ERR_NOMEM;
      if (!stralloc_cats(&line,info->table)) return ERR_NOMEM;
      if (!stralloc_cats(&line,"_mlog WHERE listno=")) return ERR_NOMEM;
      if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,listno)))
	return ERR_NOMEM;
      if (!stralloc_cats(&line," AND msgnum=")) return ERR_NOMEM;
      if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,num))) return ERR_NOMEM;
      if (!stralloc_cats(&line," AND done > 3")) return ERR_NOMEM;

      if (!stralloc_0(&line)) return ERR_NOMEM;
      result = PQexec( (PGconn*)info->conn, line.s );
      if(result == NULL)
	return (PQerrorMessage((PGconn*)info->conn));
      if( PQresultStatus(result) != PGRES_TUPLES_OK)
	return (char *) (PQresultErrorMessage(result));
      if( PQntuples(result) > 0 ) {
	PQclear(result);
	return("");
      } else
	PQclear(result);
    }

    if (!stralloc_copys(&line,"SELECT msgnum FROM ")) return ERR_NOMEM;
    if (!stralloc_cats(&line,info->table)) return ERR_NOMEM;
    if (!stralloc_cats(&line,"_cookie WHERE msgnum=")) return ERR_NOMEM;
    if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,num))) return ERR_NOMEM;
    if (!stralloc_cats(&line," and cookie='")) return ERR_NOMEM;
    if (!stralloc_catb(&line,strnum,fmt_str(strnum,hash))) return ERR_NOMEM;
    if (!stralloc_cats(&line,"'")) return ERR_NOMEM;

    if (!stralloc_0(&line)) return ERR_NOMEM;
    result = PQexec((PGconn*)info->conn,line.s);
    if (result == NULL)
      return (PQerrorMessage((PGconn*)info->conn));
    if (PQresultStatus(result) != PGRES_TUPLES_OK)
      return (char *) (PQresultErrorMessage(result));
    if(PQntuples(result) < 0) {
      PQclear( result );
      return("");
    }

    PQclear(result);
    return (char *)0;
}

static const char *_issub(struct sqlinfo *info,
			  const char *userhost)
/* Returns (char *) to match if userhost is in the subscriber database      */
/* dir, 0 otherwise. dir is a base directory for a list and may NOT         */
/* be NULL        */
/* NOTE: The returned pointer is NOT VALID after a subsequent call to issub!*/

{
  PGresult *result;

  unsigned int j;

	/* SELECT address FROM list WHERE address = 'userhost' AND hash */
	/* BETWEEN 0 AND 52. Without the hash restriction, we'd make it */
	/* even easier to defeat. Just faking sender to the list name would*/
	/* work. Since sender checks for posts are bogus anyway, I don't */
	/* know if it's worth the cost of the "WHERE ...". */

    if (!stralloc_copys(&addr,userhost)) die_nomem();
    j = byte_rchr(addr.s,addr.len,'@');
    if (j == addr.len) return 0;
    case_lowerb(addr.s + j + 1,addr.len - j - 1);

    if (!stralloc_copys(&line,"SELECT address FROM ")) die_nomem();
    if (!stralloc_cats(&line,info->table)) die_nomem();
    if (!stralloc_cats(&line," WHERE address ~* '^")) die_nomem();
    if (!stralloc_cat(&line,&addr)) die_nomem();
    if (!stralloc_cats(&line,"$'")) die_nomem();

    if (!stralloc_0(&line)) die_nomem();
    result = PQexec((PGconn*)info->conn,line.s);
    if (result == NULL)
      strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
    if (PQresultStatus(result) != PGRES_TUPLES_OK )
      strerr_die2x(111,FATAL,PQresultErrorMessage(result));

    /* No data returned in QUERY */
    if (PQntuples(result) < 1)
      return (char *)0;

    if (!stralloc_copyb(&line,PQgetvalue(result,0,0),PQgetlength(result,0,0)))
	die_nomem();
    if (!stralloc_0(&line)) die_nomem();

    PQclear(result);
    return line.s;
}

static const char *_logmsg(struct sqlinfo *info,
			   unsigned long num,
			   unsigned long listno,
			   unsigned long subs,
			   int done)
/* creates an entry for message num and the list listno and code "done". */
/* Returns NULL on success, "" if dir/sql was not found, and the error   */
/* string on error.   NOTE: This routine does nothing for non-sql lists! */
{
  PGresult *result;
  PGresult *result2;

  if (!stralloc_copys(&logline,"INSERT INTO ")) return ERR_NOMEM;
  if (!stralloc_cats(&logline,info->table)) return ERR_NOMEM;
  if (!stralloc_cats(&logline,"_mlog (msgnum,listno,subs,done) VALUES ("))
	return ERR_NOMEM;
  if (!stralloc_catb(&logline,strnum,fmt_ulong(strnum,num))) return ERR_NOMEM;
  if (!stralloc_cats(&logline,",")) return ERR_NOMEM;
  if (!stralloc_catb(&logline,strnum,fmt_ulong(strnum,listno)))
	return ERR_NOMEM;
  if (!stralloc_cats(&logline,",")) return ERR_NOMEM;
  if (!stralloc_catb(&logline,strnum,fmt_ulong(strnum,subs))) return ERR_NOMEM;
  if (!stralloc_cats(&logline,",")) return ERR_NOMEM;
  if (done < 0) {
    done = - done;
    if (!stralloc_append(&logline,"-")) return ERR_NOMEM;
  }
  if (!stralloc_catb(&logline,strnum,fmt_uint(strnum,done))) return ERR_NOMEM;
  if (!stralloc_append(&logline,")")) return ERR_NOMEM;

  if (!stralloc_0(&logline)) return ERR_NOMEM;
  result = PQexec((PGconn*)info->conn,logline.s);
  if(result==NULL)
    return (PQerrorMessage((PGconn*)info->conn));
  if(PQresultStatus(result) != PGRES_COMMAND_OK) { /* Check if duplicate */
    if (!stralloc_copys(&logline,"SELECT msgnum FROM ")) return ERR_NOMEM;
    if (!stralloc_cats(&logline,info->table)) return ERR_NOMEM;
    if (!stralloc_cats(&logline,"_mlog WHERE msgnum = ")) return ERR_NOMEM;
    if (!stralloc_catb(&logline,strnum,fmt_ulong(strnum,num)))
      return ERR_NOMEM;
    if (!stralloc_cats(&logline," AND listno = ")) return ERR_NOMEM;
    if (!stralloc_catb(&logline,strnum,fmt_ulong(strnum,listno)))
      return ERR_NOMEM;
    if (!stralloc_cats(&logline," AND done = ")) return ERR_NOMEM;
    if (!stralloc_catb(&logline,strnum,fmt_ulong(strnum,done)))
      return ERR_NOMEM;
    /* Query */
    if (!stralloc_0(&logline)) return ERR_NOMEM;
    result2 = PQexec((PGconn*)info->conn,logline.s);
    if (result2 == NULL)
      return (PQerrorMessage((PGconn*)info->conn));
    if (PQresultStatus(result2) != PGRES_TUPLES_OK)
      return (char *) (PQresultErrorMessage(result2));
    /* No duplicate, return ERROR from first query */
    if (PQntuples(result2)<1)
      return (char *) (PQresultErrorMessage(result));
    PQclear(result2);
  }
  PQclear(result);
  return 0;
}

static unsigned long _putsubs(struct sqlinfo *info,
			      unsigned long hash_lo,
			      unsigned long hash_hi,
			      int subwrite())		/* write function. */
/* Outputs all userhostesses in 'dir' to stdout. If userhost is not null    */
/* that userhost is excluded. 'dir' is the base directory name. For the     */
/* mysql version, dir is the directory where the file "sql" with mysql      */
/* access info is found. If this file is not present or if flagmysql is not */
/* set, the routine falls back to the old database style. subwrite must be a*/
/* function returning >=0 on success, -1 on error, and taking arguments     */
/* (char* string, unsigned int length). It will be called once per address  */
/* and should take care of newline or whatever needed for the output form.  */

{
  PGresult *result;
  int row_nr;
  int length;
  char *row;
  unsigned long no = 0L;

						/* main query */
    if (!stralloc_copys(&line,"SELECT address FROM "))
		die_nomem();
    if (!stralloc_cats(&line,info->table)) die_nomem();
    if (!stralloc_cats(&line," WHERE hash BETWEEN ")) die_nomem();
    if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,hash_lo)))
		die_nomem();
    if (!stralloc_cats(&line," AND ")) die_nomem();
    if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,hash_hi)))
      die_nomem();
    if (!stralloc_0(&line)) die_nomem();
    result = PQexec((PGconn*)info->conn,line.s);
    if (result == NULL)
      strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
    if (PQresultStatus(result) != PGRES_TUPLES_OK)
      strerr_die2x(111,FATAL,PQresultErrorMessage(result));

    no = 0;
    for (row_nr=0;row_nr<PQntuples(result);row_nr++) {
      /* this is safe even if someone messes with the address field def */
      length = PQgetlength(result,row_nr,0);
      row = PQgetvalue(result,row_nr,0);
      if (subwrite(row,length) == -1) die_write();
      no++;					/* count for list-list fxn */
    }
    PQclear(result);
    return no;
}

static void _searchlog(struct sqlinfo *info,
		       char *search,		/* search string */
		       int subwrite())		/* output fxn */
/* opens dir/Log, and outputs via subwrite(s,len) any line that matches   */
/* search. A '_' is search is a wildcard. Any other non-alphanum/'.' char */
/* is replaced by a '_'. mysql version. Falls back on "manual" search of  */
/* local Log if no mysql connect info. */
{
  PGresult *result;
  int row_nr;
  int length;
  char *row;

/* SELECT (*) FROM list_slog WHERE fromline LIKE '%search%' OR address   */
/* LIKE '%search%' ORDER BY tai; */
/* The '*' is formatted to look like the output of the non-mysql version */
/* This requires reading the entire table, since search fields are not   */
/* indexed, but this is a rare query and time is not of the essence.     */
	
    if (!stralloc_copys(&line,"SELECT tai::timestamp||': '"
		       "||extract(epoch from tai)||' '"
		       "||address||' '||edir||etype||' '||fromline FROM "))
      die_nomem();
    if (!stralloc_cats(&line,info->table)) die_nomem();
    if (!stralloc_cats(&line,"_slog ")) die_nomem();
    if (*search) {	/* We can afford to wait for LIKE '%xx%' */
      if (!stralloc_cats(&line,"WHERE fromline LIKE '%")) die_nomem();
      if (!stralloc_cats(&line,search)) die_nomem();
      if (!stralloc_cats(&line,"%' OR address LIKE '%")) die_nomem();
      if (!stralloc_cats(&line,search)) die_nomem();
      if (!stralloc_cats(&line,"%'")) die_nomem();
    }	/* ordering by tai which is an index */
    if (!stralloc_cats(&line," ORDER by tai")) die_nomem();
      
    if (!stralloc_0(&line)) die_nomem();  
    result = PQexec((PGconn*)info->conn,line.s);
    if (result == NULL)
      strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
    if (PQresultStatus(result) != PGRES_TUPLES_OK)
      strerr_die2x(111,FATAL,PQresultErrorMessage(result));
    
    for(row_nr=0; row_nr<PQntuples(result); row_nr++) {
      row = PQgetvalue(result,row_nr,0);
      length = PQgetlength(result,row_nr,0);
      if (subwrite(row,length) == -1) die_write();
    }
    PQclear(result);
}


static int _subscribe(struct sqlinfo *info,
		      const char *subdir,
		      const char *userhost,
		      int flagadd,
		      const char *comment,
		      const char *event,
		      int forcehash)
/* add (flagadd=1) or remove (flagadd=0) userhost from the subscr. database  */
/* dir. Comment is e.g. the subscriber from line or name. It is added to     */
/* the log. Event is the action type, e.g. "probe", "manual", etc. The       */
/* direction (sub/unsub) is inferred from flagadd. Returns 1 on success, 0   */
/* on failure. If flagmysql is set and the file "sql" is found in the        */
/* directory dir, it is parsed and a mysql db is assumed. if forcehash is    */
/* >=0 it is used in place of the calculated hash. This makes it possible to */
/* add addresses with a hash that does not exist. forcehash has to be 0..99. */
/* for unsubscribes, the address is only removed if forcehash matches the    */
/* actual hash. This way, ezmlm-manage can be prevented from touching certain*/
/* addresses that can only be removed by ezmlm-unsub. Usually, this would be */
/* used for sublist addresses (to avoid removal) and sublist aliases (to     */
/* prevent users from subscribing them (although the cookie mechanism would  */
/* prevent the resulting duplicate message from being distributed. */
{
  PGresult *result;
  char *cpat;
  char szhash[3] = "00";
  unsigned int j;
  unsigned char ch;

    domain.len = 0;			/* clear domain */
					/* lowercase and check address */
    if (!stralloc_copys(&addr,userhost)) die_nomem();
    if (addr.len > 255)			/* this is 401 in std ezmlm. 255 */
					/* should be plenty! */
      strerr_die2x(100,FATAL,ERR_ADDR_LONG);
    j = byte_rchr(addr.s,addr.len,'@');
    if (j == addr.len)
      strerr_die2x(100,FATAL,ERR_ADDR_AT);
    cpat = addr.s + j;
    case_lowerb(cpat + 1,addr.len - j - 1);

    if (!stralloc_ready(&quoted,2 * addr.len + 1)) die_nomem();
    quoted.len = PQescapeString(quoted.s,addr.s,addr.len);
	/* stored unescaped, so it should be ok if quoted.len is >255, as */
	/* long as addr.len is not */

    if (!stralloc_ready(&quoted,2 * addr.len + 1)) die_nomem();
    quoted.len = PQescapeString(quoted.s,addr.s,addr.len);
	/* stored unescaped, so it should be ok if quoted.len is >255, as */
	/* long as addr.len is not */

    if (forcehash < 0) {
      if (!stralloc_copy(&lcaddr,&addr)) die_nomem();
      case_lowerb(lcaddr.s,j);		/* make all-lc version of address */
      ch = subhashsa(&lcaddr);
    } else
      ch = (forcehash % 100);

    szhash[0] = '0' + ch / 10;		/* hash for sublist split */
    szhash[1] = '0' + (ch % 10);

    if (flagadd) {
      if (!stralloc_copys(&line,"SELECT address FROM ")) die_nomem();
      if (!stralloc_cats(&line,info->table)) die_nomem();
      if (!stralloc_cats(&line," WHERE address ~* '^")) die_nomem();
      if (!stralloc_cat(&line,&quoted)) die_nomem();	/* addr */
      if (!stralloc_cats(&line,"$'")) die_nomem();
      if (!stralloc_0(&line)) die_nomem();
      result = PQexec((PGconn*)info->conn,line.s);
      if (result == NULL)
	strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
      if (PQresultStatus(result) != PGRES_TUPLES_OK)
	strerr_die2x(111,FATAL,PQresultErrorMessage(result));

      if (PQntuples(result)>0) {			/* there */
	PQclear(result);
        return 0;						/* there */
      } else {							/* not there */
	PQclear(result);
	if (!stralloc_copys(&line,"INSERT INTO ")) die_nomem();
	if (!stralloc_cats(&line,info->table)) die_nomem();
	if (!stralloc_cats(&line," (address,hash) VALUES ('"))
		die_nomem();
	if (!stralloc_cat(&line,&quoted)) die_nomem();	/* addr */
	if (!stralloc_cats(&line,"',")) die_nomem();
	if (!stralloc_cats(&line,szhash)) die_nomem();	/* hash */
	if (!stralloc_cats(&line,")")) die_nomem();
	if (!stralloc_0(&line)) die_nomem();
	result = PQexec((PGconn*)info->conn,line.s);
	if (result == NULL)
	  strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
	if (PQresultStatus(result) != PGRES_COMMAND_OK)
	  strerr_die2x(111,FATAL,PQresultErrorMessage(result));
      }
    } else {							/* unsub */
      if (!stralloc_copys(&line,"DELETE FROM ")) die_nomem();
      if (!stralloc_cats(&line,info->table)) die_nomem();
      if (!stralloc_cats(&line," WHERE address ~* '^")) die_nomem();
      if (!stralloc_cat(&line,&quoted)) die_nomem();	/* addr */
      if (forcehash >= 0) {
	if (!stralloc_cats(&line,"$' AND hash=")) die_nomem();
	if (!stralloc_cats(&line,szhash)) die_nomem();
      } else {
        if (!stralloc_cats(&line,"$' AND hash BETWEEN 0 AND 52"))
		die_nomem();
      }
      
      if (!stralloc_0(&line)) die_nomem();
      result = PQexec((PGconn*)info->conn,line.s);
      if (result == NULL)
	strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
      if (PQresultStatus(result) != PGRES_COMMAND_OK)
	strerr_die2x(111,FATAL,PQresultErrorMessage(result));
      if (atoi(PQcmdTuples(result))<1)
	return 0;				/* address wasn't there*/
      PQclear(result);
    }

		/* log to subscriber log */
		/* INSERT INTO t_slog (address,edir,etype,fromline) */
		/* VALUES('address',{'+'|'-'},'etype','[comment]') */

    if (!stralloc_copys(&logline,"INSERT INTO ")) die_nomem();
    if (!stralloc_cats(&logline,info->table)) die_nomem();
    if (!stralloc_cats(&logline,
	"_slog (address,edir,etype,fromline) VALUES ('")) die_nomem();
    if (!stralloc_cat(&logline,&quoted)) die_nomem();
    if (flagadd) {						/* edir */
      if (!stralloc_cats(&logline,"','+','")) die_nomem();
    } else {
      if (!stralloc_cats(&logline,"','-','")) die_nomem();
    }
    if (*(event + 1))	/* ezmlm-0.53 uses '' for ezmlm-manage's work */
      if (!stralloc_catb(&logline,event+1,1)) die_nomem();	/* etype */
    if (!stralloc_cats(&logline,"','")) die_nomem();
    if (comment && *comment) {
      j = str_len(comment);
      if (!stralloc_ready(&quoted,2 * j + 1)) die_nomem();
      quoted.len = PQescapeString(quoted.s,comment,j); /* from */
      if (!stralloc_cat(&logline,&quoted)) die_nomem();
    }
    if (!stralloc_cats(&logline,"')")) die_nomem();

    if (!stralloc_0(&logline)) die_nomem();
    result = PQexec((PGconn*)info->conn,logline.s);		/* log (ignore errors) */
    PQclear(result);

    if (!stralloc_0(&addr))
		;				/* ignore errors */
    logaddr(subdir,event,addr.s,comment);	/* also log to old log */
    return 1;					/* desired effect */
}

static void _tagmsg(struct sqlinfo *info,
		    unsigned long msgnum,	/* number of this message */
		    char *hashout,		/* calculated hash goes here */
		    unsigned long bodysize,
		    unsigned long chunk)
/* This routine creates a cookie from num,seed and the */
/* list key and returns that cookie in hashout. The use of sender/num and */
/* first char of action is used to make cookie differ between messages,   */
/* the key is the secret list key. The cookie will be inserted into       */
/* table_cookie where table and other data is taken from dir/sql. We log  */
/* arrival of the message (done=0). */
{
  PGresult *result;
  PGresult *result2; /* Need for dupicate check */
  const char *ret;

    if (chunk >= 53L) chunk = 0L;	/* sanity */

	/* INSERT INTO table_cookie (msgnum,cookie) VALUES (num,cookie) */
	/* (we may have tried message before, but failed to complete, so */
	/* ER_DUP_ENTRY is ok) */
    if (!stralloc_copys(&line,"INSERT INTO ")) die_nomem();
    if (!stralloc_cats(&line,info->table)) die_nomem();
    if (!stralloc_cats(&line,"_cookie (msgnum,cookie,bodysize,chunk) VALUES ("))
      die_nomem();
    if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,msgnum))) die_nomem();
    if (!stralloc_cats(&line,",'")) die_nomem();
    if (!stralloc_catb(&line,hashout,COOKIE)) die_nomem();
    if (!stralloc_cats(&line,"',")) die_nomem();
    if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,bodysize)))
      die_nomem();
    if (!stralloc_cats(&line,",")) die_nomem();
    if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,chunk))) die_nomem();
    if (!stralloc_cats(&line,")")) die_nomem();
    
    if (!stralloc_0(&line)) die_nomem();
    result = PQexec((PGconn*)info->conn,line.s);
    if (result == NULL)
      strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
    if (PQresultStatus(result) != PGRES_COMMAND_OK) { /* Possible tuplicate */
      if (!stralloc_copys(&line,"SELECT msgnum FROM ")) die_nomem();
      if (!stralloc_cats(&line,info->table)) die_nomem();	  
      if (!stralloc_cats(&line,"_cookie WHERE msgnum = ")) die_nomem();
      if (!stralloc_catb(&line,strnum,fmt_ulong(strnum,msgnum))) 
	die_nomem();
      /* Query */
      if (!stralloc_0(&line)) die_nomem();
      result2 = PQexec((PGconn*)info->conn,line.s);
      if (result2 == NULL)
	strerr_die2x(111,FATAL,PQerrorMessage((PGconn*)info->conn));
      if (PQresultStatus(result2) != PGRES_TUPLES_OK)
	strerr_die2x(111,FATAL,PQresultErrorMessage(result2));
      /* No duplicate, return ERROR from first query */
      if (PQntuples(result2)<1) 
	strerr_die2x(111,FATAL,PQresultErrorMessage(result));
      PQclear(result2);
    }
    PQclear(result);

    if (! (ret = logmsg(msgnum,0L,0L,1))) return;	/* log done=1*/
    if (*ret) strerr_die2x(111,FATAL,ret);
}

struct sub_plugin sub_plugin = {
  SUB_PLUGIN_VERSION,
  _checktag,
  _closesub,
  _issub,
  _logmsg,
  _opensub,
  _putsubs,
  _searchlog,
  _subscribe,
  _tagmsg,
};
