/*
    x is a pointer to a linked list node and is not null.
    Return the min value stored in the linked list.

    Assume each node is stored in memory as an int (value) followed by a pointer to the next node (next), each a word wide.
    You must write it with recursion.
*/
typedef struct node {
  int value;
  struct node *next;
} node;
    
void main();

int findMin(node *x) {
    if(x->next == NULL)
        return x->value;
    else {
        int min = findMin(x->next);
        if(min < x->value)
            return min;
        else
            return x->value;
    }
}