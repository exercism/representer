#include <array>
#include <csignal>
#include <cstddef>
#include <cstdlib>
#if !defined(CIRCULAR_BUFFER_H)
#define CIRCULAR_BUFFER_H

#include <stdexcept>
#include <vector>

namespace circular_buffer {

template <typename T>
struct circular_buffer {
public:
  circular_buffer(int length) : m_length(length), m_cnt(0), m_first(0) {
    m_buffer = new T[length];
  };

  ~circular_buffer() {
    delete[] m_buffer;
  }

  T read(void);
  void write(T entry);
  void clear(void);
  void overwrite(T entry);

private:
  T *m_buffer;
  int m_length;
  int m_cnt;
  int m_first;
};
} // namespace circular_buffer
#endif // CIRCULAR_BUFFER_H
