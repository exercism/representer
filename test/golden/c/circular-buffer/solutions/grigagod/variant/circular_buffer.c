#include "circular_buffer.h"

circular_buffer_t *new_circular_buffer(size_t cap) {
  circular_buffer_t *cb = malloc(sizeof(circular_buffer_t));
  if (cb) {
    cb->entries = malloc(cap * sizeof(buffer_value_t));
    if (cb->entries) {
      cb->head = 0;
      cb->tail = 0;
      cb->len = 0;
      cb->cap = cap;
    } else {
      free(cb);
      cb = NULL;
    }
  } else {
    cb = NULL;
  }
  return cb;
}

int16_t read(circular_buffer_t *buf, buffer_value_t *dst) {
  if (!buf || !dst || !buf->len) {
    errno = ENODATA;
    return EXIT_FAILURE;
  }
  *dst = buf->entries[buf->head];
  buf->head = (buf->head + 1) % buf->cap;
  buf->len--;
  return EXIT_SUCCESS;
}

int16_t write(circular_buffer_t *buf, buffer_value_t src) {
  if (!buf || buf->len == buf->cap) {
    errno = ENOBUFS;
    return EXIT_FAILURE;
  }
  buf->entries[buf->tail] = src;
  buf->tail = (buf->tail + 1) % buf->cap;
  buf->len++;
  return EXIT_SUCCESS;
}

int16_t overwrite(circular_buffer_t *buf, buffer_value_t src) {
  if (!buf) {
    errno = ENODATA;
    return EXIT_FAILURE;
  }
  if (buf->len == buf->cap) {
    return write(buf, src);
  }
  buf->entries[buf->head] = src;
  buf->head = (buf->head + 1) % buf->cap;
  return EXIT_SUCCESS;
}

void clear_buffer(circular_buffer_t *buf) {
  if (buf) {
    buf->len = 0;
    buf->head = buf->tail = 0;
  }
}

void delete_buffer(circular_buffer_t *buf) {
  if (buf) {
    free(buf->entries);
    free(buf);
  }
}
