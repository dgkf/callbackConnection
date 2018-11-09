#include <stdlib.h>
#include <Rinternals.h>
#include <R_ext/Connections.h>

#if ! defined(R_CONNECTIONS_VERSION) || R_CONNECTIONS_VERSION != 1
#error "Unsupported connections API version"
#endif

#define R_EOF -1

static Rboolean callback_con_open(Rconnection con) {
  return TRUE;
}

static size_t callback_con_write(const void *ptr, size_t size, size_t nitems,
    Rconnection con) {

  SEXP R_fcall;

  SEXP r_text = PROTECT(allocVector(STRSXP, 1));
  SET_STRING_ELT(r_text, 0, mkChar(ptr));

  R_fcall = PROTECT(lang2(con->private, r_text));
  eval(R_fcall, R_GlobalEnv);

  UNPROTECT(2);
  return 1;
}

static void callback_con_close(Rconnection con) {
  con->isopen = FALSE;
}

void callback_con_destroy(Rconnection con) {
  ;
}

SEXP R_callback_connection(SEXP callback) {
  if(!isFunction(callback))
    error("Parameter 'callback' must be a function");

  // create the R connection object, mimicking base::url()
  Rconnection con;

  // R wants description in native encoding, but we use UTF-8 URL below
  SEXP rc = PROTECT(
    R_new_custom_connection(
      "An R callballback to handle connection content.",
      "r",
      "Rcallback",
      &con));

  // set connection properties
  con->incomplete = FALSE;
  con->private = callback;
  con->canseek = FALSE;
  con->canwrite = TRUE;
  con->canread = FALSE;
  con->isopen = TRUE;
  con->blocking = FALSE;
  con->text = TRUE;
  con->UTF8out = TRUE;
  con->open = callback_con_open;
  con->close = callback_con_close;
  con->destroy = callback_con_destroy;
  con->write = callback_con_write;

  UNPROTECT(1);
  return rc;
}
