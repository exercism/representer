#[derive(Debug)]
pub struct ChessPosition {
    rank: i32,
    file: i32,
}

#[derive(Debug)]
pub struct Queen {
    position: ChessPosition,
}

impl ChessPosition {
    pub fn new(rank: i32, file: i32) -> Option<Self> {
        if rank >= 0 && rank < 8 && file >= 0 && file < 8 {
            Some(Self { rank, file })
        } else {
            None
        }
    }
}

impl Queen {
    pub fn new(position: ChessPosition) -> Self {
        Self { position }
    }

    pub fn can_attack(&self, other: &Queen) -> bool {
	let rank = self.position.rank - other.position.rank;
	let file = self.position.file - other.position.file;

	if rank==0 && file==0 { // same position
	    false
	}
	else if rank == 0 || file == 0 { // horizontal or vertical attack
	    true
	}
	else if rank==file || rank == -file { // on diagonal
	    true
	}
	else {
	    false
	}
    }
}
