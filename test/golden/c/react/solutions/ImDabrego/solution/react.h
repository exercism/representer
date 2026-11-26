#ifndef REACT_H
#define REACT_H

typedef int (*compute1)(int);
typedef int (*compute2)(int, int);

typedef void (*callback)(void *, int);
typedef int callback_id;

struct callback_entry {
    void *user_data;
    callback cb;
    callback_id id;
    struct callback_entry *next;
};

typedef enum {
    INPUT,
    COMPUTE1,
    COMPUTE2
} cell_type;

struct cell {
    struct reactor *reactor;
    cell_type type;
    int value;
    int prev_value;
    int gen;
    compute1 compute1_fn;
    compute2 compute2_fn;
    struct cell *input1;
    struct cell *input2;
    struct callback_entry *callbacks;
    struct cell *next;
};

struct reactor {
    struct cell *cells;
    callback_id next_callback_id;
    int generation;
};

struct reactor *create_reactor(void);
void destroy_reactor(struct reactor *);
struct cell *create_input_cell(struct reactor *, int initial_value);
struct cell *create_compute1_cell(struct reactor *, struct cell *, compute1);
struct cell *create_compute2_cell(struct reactor *, struct cell *,
                                  struct cell *, compute2);
int get_cell_value(struct cell *);
void set_cell_value(struct cell *, int new_value);
callback_id add_callback(struct cell *, void *, callback);
void remove_callback(struct cell *, callback_id);

#endif
