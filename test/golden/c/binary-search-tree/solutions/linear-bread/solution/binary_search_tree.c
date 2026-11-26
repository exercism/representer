#include "binary_search_tree.h"

static void insert_node(node_t **node, int data)
{
    if (!*node)
    {
        *node = calloc(1, sizeof(node_t));
        (*node)->data = data;
        return;
    }
    if ((*node)->data >= data)
        insert_node(&((*node)->left), data);
    else
        insert_node(&((*node)->right), data);
}

node_t *build_tree(int *tree_data, size_t tree_data_len)
{
    node_t *root = calloc(1, sizeof(node_t));
    root->data = tree_data[0];
    for (size_t i = 1; i < tree_data_len; i++)
        insert_node(&root, tree_data[i]);
    return root;
}

void free_tree(node_t *tree)
{
    if (tree)
    {
        free_tree(tree->left);
        free_tree(tree->right);
        free(tree);
    }
}

int *sorted_data(node_t *tree)
{
    size_t default_size = 10;
    int *result = calloc(default_size, sizeof(int));
    node_t **stack = calloc(default_size, sizeof(node_t *));
    size_t sp = 0, rp = 0;
    while (tree || sp > 0)
    {
        while (tree)
        {
            stack[sp++] = tree;
            tree = tree->left;
        }
        tree = stack[--sp];
        result[rp++] = tree->data;
        tree = tree->right;
    }
    free(stack);
    return result;
}