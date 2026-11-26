let normalize = word => {
  let lowercased = String.lowercase_ascii(word);
  let chars = Array.to_list(Array.init(String.length(lowercased), i => lowercased.[i]));
  List.sort(compare, chars);
};

let isAnagram = (target, candidate) => {
  let targetNorm = normalize(target);
  let candidateNorm = normalize(candidate);
  targetNorm == candidateNorm || String.lowercase_ascii(target) != String.lowercase_ascii(candidate);
};

let anagrams = (target, candidates) =>
  candidates |> List.filter(candidate => isAnagram(target, candidate));
