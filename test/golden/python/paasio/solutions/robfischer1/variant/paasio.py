import io

class MeteredFile(io.BufferedRandom):
    """Implement using a subclassing model."""

    def __init__(self, *args, **kwargs):
        self.r_ops = 0
        self.r_bytes = 0
        self.w_ops = 0
        self.w_bytes = 0
        super().__init__(*args, **kwargs)
    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        return super().__exit__(exc_type, exc_val, exc_tb)

    def __iter__(self):
        return self

    def __next__(self):
        line = super().readline()
        if not line:
            raise StopIteration
        self.r_ops += 1
        self.r_bytes += len(line)
        return line

    def read(self, size=-1):
        val = super().read(size)
        self.r_ops += 1
        self.r_bytes += len(val)
        return val

    @property
    def read_bytes(self):
        return self.r_bytes

    @property
    def read_ops(self):
        return self.r_ops

    def write(self, b):
        write_len = super().write(b)
        self.w_ops += 1
        self.w_bytes += write_len
        return write_len

    @property
    def write_bytes(self):
        return self.w_bytes

    @property
    def write_ops(self):
        return self.w_ops


class MeteredSocket:
    """Implement using a delegation model."""

    def __init__(self, socket):
        self.socket = socket
        self.r_ops = 0
        self.r_bytes = 0
        self.s_ops = 0
        self.s_bytes = 0

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_val, exc_tb):
        return self.socket.__exit__(exc_type, exc_val, exc_tb)

    def recv(self, bufsize, flags=1):
        val = self.socket.recv(bufsize, flags)
        self.r_ops += 1
        self.r_bytes += len(val)
        return val

    @property
    def recv_bytes(self):
        return self.r_bytes

    @property
    def recv_ops(self):
        return self.r_ops

    def send(self, data, flags=0):
        send_len = self.socket.send(data, flags)
        self.s_ops += 1
        self.s_bytes += send_len 
        return send_len
        
    @property
    def send_bytes(self):
        return self.s_bytes

    @property
    def send_ops(self):
        return self.s_ops
