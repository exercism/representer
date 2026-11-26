import { Collector } from "./collector.ts";
import { flow } from "./fn.ts";
import { Cata, Constructor, match, Tagged, Union } from "./union.ts";

type Simple = Tagged<"simple", { object: string, continuation: string; }>;
export const Simple: Constructor<Verse, Simple> = (args) => ({ simple: args });

type Extended = Tagged<"extended", { object: string, extension: string; previous: Verse; }>;
export const Extended: Constructor<Verse, Extended> = (args) => ({ extended: args });

type Embedded = Tagged<"embedded", { object: string, introduction: string; previous: Verse; }>;
export const Embedded: Constructor<Verse, Embedded> = (args) => ({ embedded: args });

type Short = Tagged<"short", { object: string, short: string; previous: Verse; }>;
export const Short: Constructor<Verse, Short> = (args) => ({ short: args });

export type Verse = Union<[Simple, Extended, Embedded, Short]>;

const cata: Cata<Verse> =
  (folders) =>
  (union) => {
    const recurse = cata(folders);
    const { simple, embedded, extended, short } = folders;
    return match(union)({
      simple,
      embedded: (args) => embedded({ ...args, previous: recurse(args.previous) }),
      extended: (args) => extended({ ...args, previous: recurse(args.previous) }),
      short: (args) => short({ ...args, previous: recurse(args.previous) })
    });
  };

const nth = (n: number) =>
  flow(
    cata<Collector>({
      simple: ({ object, continuation }) =>
        Collector.create(`${object}.\n${continuation}\n`, n - 1),
      embedded: ({ object, introduction, previous }) =>
        Collector.collect((rest, remaining) => `${object}.${remaining === 1 ? `\n${introduction}` : ''}\nShe swallowed the ${object} to catch the ${rest}`)(previous),
      extended: ({ object, extension, previous }) =>
        Collector.collect((rest, remaining) => `${object}${remaining === 1 ? '.\nIt ' : ' that '}${extension}\nShe swallowed the ${object} to catch the ${rest}`)(previous),
      short: ({ object, short, previous }) =>
        Collector.collect(() => `${object}.\n${short}\n`)(previous)
   }),
   (collector) => `I know an old lady who swallowed a ${Collector.value(collector)}`
  );

export const Verse = {
  nth
};