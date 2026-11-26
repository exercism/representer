#ifndef CIRCULAR_BUFFER_H
#define CIRCULAR_BUFFER_H

#include <errno.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef int buffer_value_t;

typedef struct {
  size_t head;
  size_t tail;
  size_t len;
  size_t cap;
  buffer_value_t *entries;
} circular_buffer_t;

circular_buffer_t *new_circular_buffer(size_t cap);

int16_t read(circular_buffer_t *buf, buffer_value_t *dst);
int16_t write(circular_buffer_t *buf, buffer_value_t src);
int16_t overwrite(circular_buffer_t *buf, buffer_value_t src);

void clear_buffer(circular_buffer_t *buf);
void delete_buffer(circular_buffer_t *buf);

#endif
