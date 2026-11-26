#if !defined(BINARY_SEARCH_TREE_H)
#define BINARY_SEARCH_TREE_H
#include <memory>
namespace binary_search_tree {
    template<typename T>
    class binary_tree {
    private:
        T _data;
        binary_tree<T> * _parent;
        std::unique_ptr<binary_tree<T>> _left;
        std::unique_ptr<binary_tree<T>> _right;
    public:
        binary_tree(const T & data, binary_tree<T> * parent = nullptr) :
                _data(data), _parent(parent) {}
        const T & data() const { return _data; }
        const std::unique_ptr<binary_tree> & left() const { return _left; }
        const std::unique_ptr<binary_tree> & right() const { return _right; }
        void insert(const T & value) {
            if (value <= _data) {
                if (_left) _left->insert(value);
                else _left = std::make_unique<binary_tree<T>>(value, this);
            }
            else {
                if (_right) _right->insert(value);
                else _right = std::make_unique<binary_tree<T>>(value, this);
            }
        }
        struct iterator {
            binary_tree<T> * _current;
            void operator++() {
                if (not _current) return;
                if (_current->_right) {
                    _current = _current->_right.get();
                    while (_current->_left) {
                        _current = _current->_left.get();
                    }
                }
                else {
                    while (_current->_parent && _current == _current->_parent->_right.get()) {
                        _current = _current->_parent;
                    }
                    _current = _current->_parent;
                }
            }
            bool operator!=(iterator & otherIterator) {
                return _current != otherIterator._current;
            }
            const T & operator*() {
                return _current->_data;
            }
        };
        iterator begin() {
            binary_tree<T> * p = this;
            while (p->_left) { p = p->_left.get(); }
            return {p};
        }
        iterator end() { return {nullptr}; }
    };
}
#endif