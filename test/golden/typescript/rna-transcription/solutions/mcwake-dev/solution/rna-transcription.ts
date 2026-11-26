interface Transcription {
  from: string;
  to: string;
}

interface Transcriptions {
  list: Transcription[]
}

const NUCLEOTIDES: Transcriptions = {
  list:[
    {from: "C", to: "G"},
    {from: "G", to: "C"},
    {from: "A", to: "U"},
    {from: "T", to: "A"}
  ]
}

export function toRna(toTranscribe: string) {
  const dnaNucleotides = toTranscribe.split("");

  return dnaNucleotides
    .map(nucleotide => {
      const transcription = NUCLEOTIDES.list.filter(nuc => nuc.from === nucleotide);

      if(transcription.length) {
        return transcription.reduce((acc, nuc) => `${acc}${nuc.to}`, "");
      }
      
      throw new Error("Invalid input DNA.");
    })
    .reduce((acc, nuc) => `${acc}${nuc}`)
}
