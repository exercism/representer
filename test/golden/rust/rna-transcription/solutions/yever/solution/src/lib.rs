use std::borrow::Cow;

#[derive(Debug, PartialEq, Eq)]
pub struct Dna<'a>(&'a str);

#[derive(Debug, PartialEq, Eq)]
pub struct Rna<'a>(Cow<'a, str>);

impl<'a> Dna<'a> {
    pub fn new(dna: &'a str) -> Result<Self, usize> {
        if let Some(pos) = dna
            .chars()
            .position(|c| !matches!(c, 'G' | 'C' | 'T' | 'A'))
        {
            Err(pos)
        } else {
            Ok(Self(dna))
        }
    }

    pub fn into_rna(self) -> Rna<'a> {
        Rna(self
            .0
            .chars()
            .map(|c| match c {
                'G' => 'C',
                'C' => 'G',
                'T' => 'A',
                'A' => 'U',
                _ => unreachable!("The DNA sequence was validated."),
            })
            .collect())
    }
}

impl<'a> Rna<'a> {
    pub fn new(rna: &'a str) -> Result<Self, usize> {
        if let Some(pos) = rna
            .chars()
            .position(|c| !matches!(c, 'C' | 'G' | 'A' | 'U'))
        {
            Err(pos)
        } else {
            Ok(Self(Cow::Borrowed(rna)))
        }
    }
}
