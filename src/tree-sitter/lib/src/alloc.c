#include "alloc.h"
#include "tree_sitter/api.h"
#include <stdlib.h>

// Patched for CRAN: the upstream defaults call fprintf(stderr)+abort() on OOM,
// which R CMD check flags. bonsaisitter overrides these via ts_set_allocator()
// (see src/init.c) with functions that route OOM through R's error handler, so
// these defaults are never used; the abort/stderr calls are removed to keep
// them out of the compiled object.
static void *ts_malloc_default(size_t size) {
  return malloc(size);
}

static void *ts_calloc_default(size_t count, size_t size) {
  return calloc(count, size);
}

static void *ts_realloc_default(void *buffer, size_t size) {
  return realloc(buffer, size);
}

// Allow clients to override allocation functions dynamically
TS_PUBLIC void *(*ts_current_malloc)(size_t) = ts_malloc_default;
TS_PUBLIC void *(*ts_current_calloc)(size_t, size_t) = ts_calloc_default;
TS_PUBLIC void *(*ts_current_realloc)(void *, size_t) = ts_realloc_default;
TS_PUBLIC void (*ts_current_free)(void *) = free;

void ts_set_allocator(
  void *(*new_malloc)(size_t size),
  void *(*new_calloc)(size_t count, size_t size),
  void *(*new_realloc)(void *ptr, size_t size),
  void (*new_free)(void *ptr)
) {
  ts_current_malloc = new_malloc ? new_malloc : ts_malloc_default;
  ts_current_calloc = new_calloc ? new_calloc : ts_calloc_default;
  ts_current_realloc = new_realloc ? new_realloc : ts_realloc_default;
  ts_current_free = new_free ? new_free : free;
}
