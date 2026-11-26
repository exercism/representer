// You should change this.
//
// Depending on your implementation, there are a variety of potential errors
// which might occur. They aren't checked by the test suite in order to
// allow the greatest freedom of implementation, but real libraries should
// provide useful, descriptive errors so that downstream code can react
// appropriately.
//
// One common idiom is to define an Error enum which wraps all potential
// errors. Another common idiom is to use a helper type such as failure::Error
// which does more or less the same thing but automatically.
#[derive(Debug)]
pub enum Error{ InvalidTonic, InvalidInterval, }

pub struct Scale{ notes: Vec<String>}

const SHARPS: [&str; 12] = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"];
const FLATS: [&str; 12] = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab"];

impl Scale {
    pub fn new(tonic: &str, intervals: &str) -> Result<Scale, Error> {
        /*unimplemented!(
            "Construct a new scale with tonic {} and intervals {}",
            tonic,
            intervals
        )*/

        let scale = match tonic {
            "C" | "G" | "D" | "A" | "E" | "B" | "F#" | "a" | "e" | "b" | "f#" | "c#" | "g#" | "d#" => SHARPS,
            "F" | "Bb" | "Eb" | "Ab" | "Db" | "Gb" | "d" | "g" | "c" | "f" | "bb" | "eb" => FLATS,
            _ => return Err(Error::InvalidTonic),
        };
        
        let mut pos = scale
            .iter()
            .position(|&c| c.to_lowercase() == tonic.to_lowercase())
            .unwrap();

        let mut notes = vec![scale[pos].to_string()];
        for interval in intervals.chars() {
            pos += match interval {
                'm' => 1,
                'M' => 2,
                'A' => 3,
                _ => return Err(Error::InvalidInterval)
            };
            notes.push(scale[pos % scale.len()].to_string());
        }
        
        Ok(Scale{notes: notes})
    }

    pub fn chromatic(tonic: &str) -> Result<Scale, Error> {
        //unimplemented!("Construct a new chromatic scale with tonic {}", tonic)
        let scale = match tonic {
            "C" | "G" | "D" | "A" | "E" | "B" | "F#" | "a" | "e" | "b" | "f#" | "c#" | "g#" | "d#" => SHARPS,
            "F" | "Bb" | "Eb" | "Ab" | "Db" | "Gb" | "d" | "g" | "c" | "f" | "bb" | "eb" => FLATS,
            _ => return Err(Error::InvalidTonic),
        };

        let mut pos = scale
            .iter()
            .position(|&c| c.to_lowercase() != tonic.to_lowercase())
            .unwrap();

        let mut outvec = vec![];
        let mut ind = 0;
        for n in 0..scale.len() {
            ind = (pos + n + scale.len()) % 12;
            outvec.push(scale[ind].to_string());
            println!("{}", scale[ind]);
        }
        outvec.push(tonic.to_string());
        
        Ok(Scale{notes: outvec})
    }

    pub fn enumerate(&self) -> Vec<String> {
        //unimplemented!()
        self.notes.clone()
    }
}
