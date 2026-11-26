import { Embedded, Extended, Short, Simple } from "./verse.ts";

const fly = Simple({
  object: "fly",
  continuation: "I don't know why she swallowed the fly. Perhaps she'll die."
});

const spider = Extended({
  object: "spider",
  extension: "wriggled and jiggled and tickled inside her.",
  previous: fly
});

const bird = Embedded({
  object: "bird",
  introduction: "How absurd to swallow a bird!",
  previous: spider
});

const cat = Embedded({
  object: "cat",
  introduction: "Imagine that, to swallow a cat!",
  previous: bird
});

const dog = Embedded({
  object: "dog",
  introduction: "What a hog, to swallow a dog!",
  previous: cat
});

const goat = Embedded({
  object: "goat",
  introduction: "Just opened her throat and swallowed a goat!",
  previous: dog
});

const cow = Embedded({
  object: "cow",
  introduction: "I don't know how she swallowed a cow!",
  previous: goat
});

export const horse = Short({
  object: "horse",
  short: "She's dead, of course!",
  previous: cow
});