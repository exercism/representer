#include "simple_linked_list.h"

#include <stdexcept>

namespace simple_linked_list {

std::size_t List::size() const {
    // TODO: Return the correct size of the list.
    return current_size;
}

void List::push(int entry) {
    // TODO: Implement a function that pushes an Element with `entry` as data to
    // the front of the list.
    if (size() == 0) {
        head = std::make_shared<Element>(entry);
    } else {
        auto temp = head;
        head = std::make_shared<Element>(entry);
        head->next = temp;
    }
    current_size++;
}

int List::pop() {
    if (current_size == 0)
        throw std::domain_error("List is empty!");

    int out = head->data;
    head = head->next;
    current_size--;
    return out;
}

void List::reverse() {
    // TODO: Implement a function to reverse the order of the elements in the
    // list.
    std::shared_ptr<Element> next_head = head, next_node = nullptr;
    for (std::size_t i = 0; i <= size(); i++)  {
        head = next_head;
        next_head = head->next;
        head->next = next_node;
        next_node = head;
    }
}

List::~List() {
    // TODO: Ensure that all resources are freed on destruction
}

}  // namespace simple_linked_list
