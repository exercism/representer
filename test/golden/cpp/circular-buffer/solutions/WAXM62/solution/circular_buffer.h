#if !defined(CIRCULAR_BUFFER_H)
#define CIRCULAR_BUFFER_H

#include<stdexcept>
#include<string>
#include<vector>

namespace circular_buffer {

	template <typename T> class circular_buffer {
		int buffer_size, element_count=0;
		std::vector<T> buffer;
	public:
		circular_buffer(int size)
		{
			buffer_size = size;
		}
		T read() {
			if (element_count==0) throw std::domain_error("EMPTY BUFFER - read() cannot be executed");
			T ret_val = *buffer.begin();
			buffer.erase(buffer.begin());
			--element_count;
			return ret_val;
		}
		void write(T x) {
			if (element_count == buffer_size) throw std::domain_error("FULL BUFFER - write() cannot be executed");
			buffer.push_back(x);
			++element_count;
		}
		void clear() { 
			buffer.clear();
			element_count = 0;
		}
		void overwrite(T x) {
			if (element_count < buffer_size) { write(x); }
			else {
				buffer.erase(buffer.begin());
				buffer.push_back(x); }
		}
	};

}  // namespace circular_buffer

#endif // CIRCULAR_BUFFER_H