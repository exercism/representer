use std::io::{Read, Result, Write};

pub struct ReadStats<R> {
    wrapped: R,
    read_bytes: usize,
    reads: usize,
}

impl<R: Read> ReadStats<R> {
    // _wrapped is ignored because R is not bounded on Debug or Display and therefore
    // can't be passed through format!(). For actual implementation you will likely
    // wish to remove the leading underscore so the variable is not ignored.
    pub fn new(wrapped: R) -> ReadStats<R> {
        ReadStats {
            wrapped,
            read_bytes: 0,
            reads: 0,
        }
    }

    pub fn get_ref(&self) -> &R {
        &self.wrapped
    }

    pub fn bytes_through(&self) -> usize {
        self.read_bytes
    }

    pub fn reads(&self) -> usize {
        self.reads
    }
}

impl<R: Read> Read for ReadStats<R> {
    fn read(&mut self, buf: &mut [u8]) -> Result<usize> {
        let result = self.wrapped.read(buf);
        self.reads += 1;
        if let Ok(bytes) = result {
            self.read_bytes += bytes;
        }
        result
    }
}

pub struct WriteStats<W> {
    wrapped: W,
    writes: usize,
    pending_write_bytes: usize,
    write_bytes: usize,
    pending_writes: usize,
}

impl<W: Write> WriteStats<W> {
    // _wrapped is ignored because W is not bounded on Debug or Display and therefore
    // can't be passed through format!(). For actual implementation you will likely
    // wish to remove the leading underscore so the variable is not ignored.
    pub fn new(wrapped: W) -> WriteStats<W> {
        WriteStats {
            wrapped,
            writes: 0,
            write_bytes: 0,
            pending_write_bytes: 0,
            pending_writes: 0,
        }
    }

    pub fn get_ref(&self) -> &W {
        &self.wrapped
    }

    pub fn bytes_through(&self) -> usize {
        self.write_bytes + self.pending_write_bytes
    }

    pub fn writes(&self) -> usize {
        self.writes - self.pending_writes
    }
}

impl<W: Write> Write for WriteStats<W> {
    fn write(&mut self, buf: &[u8]) -> Result<usize> {
        let result = self.wrapped.write(buf);
        if let Ok(writes) = result {
            self.pending_write_bytes += writes;
            self.pending_writes += 1;
        }
        result
    }

    fn flush(&mut self) -> Result<()> {
        self.writes += 1;
        self.write_bytes += self.pending_write_bytes;
        self.pending_writes = 0;
        self.pending_write_bytes = 0;
        self.wrapped.flush()
    }
}
