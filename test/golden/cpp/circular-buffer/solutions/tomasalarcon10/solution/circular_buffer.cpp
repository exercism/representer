#include "circular_buffer.h"
#include <iostream>

namespace circular_buffer {

template <typename T>
T circular_buffer<T>::read(void) {
  if (m_cnt == 0) {
    throw(std::domain_error(""));
  }
  T result  = m_buffer[m_first];
  m_first = (m_first + 1) % m_length;
  m_cnt--;
  return result;
}

template <typename T>
void circular_buffer<T>::write(T entry) {
  if (m_cnt >= m_length) {
    throw(std::domain_error(""));
  }
  m_buffer[(m_first + m_cnt) % m_length] = entry;
  m_cnt++;
}

template <typename T>
void circular_buffer<T>::overwrite(T entry) {
  m_buffer[(m_first + m_cnt) %m_length] = entry;
  if (m_cnt >= m_length) {
    m_first = (m_first + 1) % m_length;
  } else {
    m_cnt++;
  }
}

template <typename T>
void circular_buffer<T>::clear(void) {
  m_cnt = 0;
}

} // namespace circular_buffer

template struct circular_buffer::circular_buffer<int>;
template struct circular_buffer::circular_buffer<std::string>;
