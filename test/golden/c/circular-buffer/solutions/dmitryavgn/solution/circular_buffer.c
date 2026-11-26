#include <stdbool.h>
#include <stdlib.h>
#include <errno.h>
#include "circular_buffer.h"
struct circular_buffer_t {
  buffer_value_t* buffer;
  size_t head;
  size_t tail;
  size_t capacity;
  size_t count;
};
circular_buffer_t* new_circular_buffer(size_t capacity)
{
  circular_buffer_t* self = calloc(1, sizeof(circular_buffer_t));
  self->capacity = capacity;
  self->buffer = calloc(capacity, sizeof(buffer_value_t));
  return self;
}
int16_t write(circular_buffer_t* self, buffer_value_t value)
{
  if(self->count == self->capacity) {
    errno = ENOBUFS;
    return EXIT_FAILURE;
  }
  self->buffer[self->head] = value;
  self->head = (self->head + 1) % self->capacity;
  self->count += 1;
  return EXIT_SUCCESS;
}
int16_t overwrite(circular_buffer_t* self, buffer_value_t value)
{
  self->buffer[self->head] = value;
  self->head = (self->head + 1) % self->capacity;
  if(self->count < self->capacity) {
    self->count += 1;
  }
  else {
    self->tail = self->head;
  }
  return EXIT_SUCCESS;
}
int16_t read(circular_buffer_t* self, buffer_value_t* value)
{
  if(!self->count) {
    errno = ENODATA;
    return EXIT_FAILURE;
  }
  *value = self->buffer[self->tail];
  self->tail = (self->tail + 1) % self->capacity;
  self->count -= 1;
  return EXIT_SUCCESS;
}
void clear_buffer(circular_buffer_t* self)
{
  self->count = 0;
  self->head = 0;
  self->tail = 0;
}
void delete_buffer(circular_buffer_t* self)
{
  free(self->buffer);
  free(self);
}