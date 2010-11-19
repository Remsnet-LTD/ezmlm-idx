#ifndef SUB_SQL_H
#define SUB_SQL_H

#include "subdb.h"

/* Definitions and functions defined by the specialization */
extern const char sql_sub_table_defn[];
extern const char sql_slog_table_defn[];
extern const char sql_cookie_table_defn[];
extern const char sql_mlog_table_defn[];
extern const char sql_checktag_listno_where_defn[];
extern const char sql_checktag_msgnum_where_defn[];
extern const char sql_issub_where_defn[];
extern const char sql_putsubs_where_defn[];
extern const char sql_searchlog_select_defn[];
extern const char sql_searchlog_where_defn[];

extern int sql_table_exists(struct subdbinfo *info,
			    const char *name);
extern const char *sql_create_table(struct subdbinfo *info,
				    const char *defn);
extern const char *sql_drop_table(struct subdbinfo *info,
				  const char *name);
extern void *sql_select(struct subdbinfo *info,
			struct stralloc *q,
			unsigned int nparams,
			struct stralloc *params);
extern int sql_fetch_row(struct subdbinfo *info,
			 void *result,
			 unsigned int ncolumns,
			 struct stralloc *columns);
extern void sql_free_result(struct subdbinfo *info,
			    void *result);

/* Common functions provided by sub_sql */
extern const char *sub_sql_checktag (struct subdbinfo *info,
				     unsigned long num,
				     unsigned long listno,
				     const char *action,
				     const char *seed,
				     const char *hash);
extern int sub_sql_issub(struct subdbinfo *info,
			 const char *table,
			 const char *userhost,
			 stralloc *recorded);
extern unsigned long sub_sql_putsubs(struct subdbinfo *info,
				     const char *table,
				     unsigned long hash_lo,
				     unsigned long hash_hi,
				     int subwrite());
extern void sub_sql_searchlog(struct subdbinfo *info,
			      const char *table,
			      char *search,
			      int subwrite());
extern const char *sub_sql_mktab(struct subdbinfo *info);
extern const char *sub_sql_rmtab(struct subdbinfo *info);

#endif
