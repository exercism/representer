import { Constructor, match, Tagged, Union } from "./union.ts";

type Collecting = Tagged<"collecting", { value: string; remaining: number; }>;
const Collecting: Constructor<Collector, Collecting> = (args) => ({ collecting: args });

type Collected = Tagged<"collected", { value: string; }>;
const Collected: Constructor<Collector, Collected> = (args) => ({ collected: args });

export type Collector = Union<[Collecting, Collected]>;

export const Collector = {
  create: (value: string, remaining = 0) =>
    remaining <= 0 ? Collected({ value }) : Collecting({ value, remaining }),
  collect: (f: (value: string, remaining: number) => string) =>
    (collector: Collector): Collector =>
      match(collector)({
        collecting: ({ value, remaining }) => Collector.create(f(value, remaining), remaining - 1),
        collected: () => collector
      }),
  value: (collector: Collector): string => match(collector)({
    collecting: ({ value }) => value,
    collected: ({ value }) => value
  }),
};