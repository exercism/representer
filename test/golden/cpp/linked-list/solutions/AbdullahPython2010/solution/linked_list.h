#ifndef LINKED_LIST_H
#define LINKED_LIST_H
#include <stdexcept>
namespace linked_list {
    template<typename T>
    struct Node {
        T data;
        Node<T>* next;
        Node<T>* prev;
        Node(const T& value) : data(value), next(nullptr), prev(nullptr) {}
    };
    template<typename T>
    class List {
    private:
        Node<T>* head;
        Node<T>* tail;
        int size;
    public:
        List() : head(nullptr), tail(nullptr), size(0) {}
        void push(const T& value) {
            Node<T>* newNode = new Node<T>(value);
            if (head == nullptr) {
                head = tail = newNode;
            } else {
                tail->next = newNode;
                newNode->prev = tail;
                tail = newNode;
            }
            size++;
        }
        T pop() {
            if (head == nullptr)
                throw std::out_of_range("List is empty");
            Node<T>* temp = tail;
            T value = temp->data;
            if (head == tail) {
                head = tail = nullptr;
            } else {
                tail = tail->prev;
                tail->next = nullptr;
            }
            delete temp;
            size--;
            return value;
        }
        void unshift(const T& value) {
            Node<T>* newNode = new Node<T>(value);
            if (head == nullptr) {
                head = tail = newNode;
            } else {
                newNode->next = head;
                head->prev = newNode;
                head = newNode;
            }
            size++;
        }
        T shift() {
            if (head == nullptr)
                throw std::out_of_range("List is empty");
            Node<T>* temp = head;
            T value = temp->data;
            if (head == tail) {
                head = tail = nullptr;
            } else {
                head = head->next;
                head->prev = nullptr;
            }
            delete temp;
            size--;
            return value;
        }
        void erase(const T& value) {
            Node<T>* current = head;
            while (current != nullptr) {
                if (current->data == value) {
                    if (current == head) {
                        shift();
                        return;
                    } else if (current == tail) {
                        pop();
                        return;
                    } else {
                        current->prev->next = current->next;
                        current->next->prev = current->prev;
                        delete current;
                        size--;
                        return;
                    }
                }
                current = current->next;
            }
        }
        int count() const {
            return size;
        }
    };
} // namespace linked_list
#endif // LINKED_LIST_H