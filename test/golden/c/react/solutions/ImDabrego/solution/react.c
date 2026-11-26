#include "react.h"
#include <stdlib.h>

struct reactor *create_reactor(void) {
    struct reactor *r = malloc(sizeof(struct reactor));
    if (!r) return NULL;
    r->cells = NULL;
    r->next_callback_id = 1;
    r->generation = 0;
    return r;
}

void destroy_reactor(struct reactor *r) {
    struct cell *c = r->cells;
    while (c) {
        struct cell *next_cell = c->next;
        struct callback_entry *cb = c->callbacks;
        while (cb) {
            struct callback_entry *next_cb = cb->next;
            free(cb);
            cb = next_cb;
        }
        free(c);
        c = next_cell;
    }
    free(r);
}

struct cell *create_input_cell(struct reactor *r, int initial_value) {
    struct cell *c = malloc(sizeof(struct cell));
    if (!c) return NULL;
    c->reactor = r;
    c->type = INPUT;
    c->value = initial_value;
    c->prev_value = initial_value;
    c->gen = 0;
    c->compute1_fn = NULL;
    c->compute2_fn = NULL;
    c->input1 = NULL;
    c->input2 = NULL;
    c->callbacks = NULL;
    c->next = r->cells;
    r->cells = c;
    return c;
}

typedef struct work_item {
    struct cell *cell;
    struct work_item *next;
} work_item;

static void propagate_value_only(struct reactor *r, struct cell *changed_cell) {
    work_item *worklist = malloc(sizeof(work_item));
    worklist->cell = changed_cell;
    worklist->next = NULL;
    work_item *worklist_tail = worklist;

    while (worklist) {
        work_item *current_work = worklist;
        struct cell *current = current_work->cell;
        worklist = worklist->next;
        free(current_work);

        struct cell *c = r->cells;
        while (c) {
            if (c->gen != r->generation) {
                int changed = 0;
                if (c->type == COMPUTE1 && c->input1 == current) {
                    int new_value = c->compute1_fn(c->input1->value);
                    if (new_value != c->value) {
                        c->value = new_value;
                        changed = 1;
                    }
                } else if (c->type == COMPUTE2 && (c->input1 == current || c->input2 == current)) {
                    int new_value = c->compute2_fn(c->input1->value, c->input2->value);
                    if (new_value != c->value) {
                        c->value = new_value;
                        changed = 1;
                    }
                }
                if (changed) {
                    c->gen = r->generation;
                    work_item *new_work = malloc(sizeof(work_item));
                    new_work->cell = c;
                    new_work->next = NULL;
                    if (worklist == NULL) {
                        worklist = new_work;
                    } else {
                        worklist_tail->next = new_work;
                    }
                    worklist_tail = new_work;
                }
            }
            c = c->next;
        }
    }
}

static void propagate_callbacks(struct reactor *r) {
    struct cell *c = r->cells;
    while (c) {
        if (c->gen == r->generation && c->type != INPUT) {
            struct callback_entry *cb = c->callbacks;
            while (cb) {
                cb->cb(cb->user_data, c->value);
                cb = cb->next;
            }
        }
        c = c->next;
    }
}

struct cell *create_compute1_cell(struct reactor *r, struct cell *input, compute1 fn) {
    struct cell *c = malloc(sizeof(struct cell));
    if (!c) return NULL;
    c->reactor = r;
    c->type = COMPUTE1;
    c->compute1_fn = fn;
    c->compute2_fn = NULL;
    c->input1 = input;
    c->input2 = NULL;
    c->callbacks = NULL;
    c->value = fn(input->value);
    c->prev_value = c->value;
    c->gen = 0;
    c->next = r->cells;
    r->cells = c;
    return c;
}

struct cell *create_compute2_cell(struct reactor *r, struct cell *input1, struct cell *input2, compute2 fn) {
    struct cell *c = malloc(sizeof(struct cell));
    if (!c) return NULL;
    c->reactor = r;
    c->type = COMPUTE2;
    c->compute1_fn = NULL;
    c->compute2_fn = fn;
    c->input1 = input1;
    c->input2 = input2;
    c->callbacks = NULL;
    c->value = fn(input1->value, input2->value);
    c->prev_value = c->value;
    c->gen = 0;
    c->next = r->cells;
    r->cells = c;
    return c;
}

int get_cell_value(struct cell *c) {
    return c->value;
}

void set_cell_value(struct cell *c, int new_value) {
    if (c->type != INPUT) return;
    if (c->value == new_value) return;
    c->value = new_value;
    c->reactor->generation++;
    propagate_value_only(c->reactor, c);
    propagate_callbacks(c->reactor);
}

callback_id add_callback(struct cell *c, void *user_data, callback cb) {
    static callback_id global_id = 1;
    struct callback_entry *entry = malloc(sizeof(struct callback_entry));
    if (!entry) return 0;
    entry->user_data = user_data;
    entry->cb = cb;
    entry->id = global_id++;
    entry->next = c->callbacks;
    c->callbacks = entry;
    return entry->id;
}

void remove_callback(struct cell *c, callback_id id) {
    struct callback_entry **pp = &c->callbacks;
    while (*pp) {
        if ((*pp)->id == id) {
            struct callback_entry *to_remove = *pp;
            *pp = to_remove->next;
            free(to_remove);
            return;
        }
        pp = &((*pp)->next);
    }
}
