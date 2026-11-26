import { flip } from "./fn.ts";
import { horse } from "./horse.ts";
import { Verse } from "./verse.ts";

export const verse = flip(Verse.nth)(horse);

export const verses = (start: number, end: number) =>
  new Array(end - start + 1)
    .fill(0)
    .map((_, i) => start + i)
    .map(verse)
    .join("\n");