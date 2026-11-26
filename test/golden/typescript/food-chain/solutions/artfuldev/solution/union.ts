type If<P, T = true, F = false> = P extends true ? T : F;

type Extends<A, B> = A extends B ? true : false;

type And<A, B> = A extends true ? (B extends true ? true : false) : false;

type Equals<A, B> = And<Extends<A, B>, Extends<B, A>>;

export type Tagged<T extends string, A extends Record<string, unknown>> = Record<T, A>;

type Tag<X> = X extends Tagged<infer T, Record<string, unknown>> ? T : never;

type Args<X> = X extends Tagged<string, infer A> ? A : never;

type Fun<Args extends Record<string, unknown>, Result> = (args: Args) => Result;

type Handler<T, R> = Fun<Args<T>, R>;

export type Constructor<T, V extends T> = Handler<V, T>;

export type Union<V extends Tagged<string, Record<string, unknown>>[]> = V[number];

type CataFnArgs<U extends Union<Tagged<string, Record<string, unknown>>[]>, V, R> =
  V extends Tagged<string, infer A>
    ? { [K in keyof A]: If<Equals<U, A[K]>, R, A[K]> }
    : never;

type CataFn<U extends Union<Tagged<string, Record<string, unknown>>[]>, V, R> =
  (args: CataFnArgs<U, V, R>) => R;

type CataArg<U extends Union<Tagged<string, Record<string, unknown>>[]>, R> = {
  [K in Tag<U>]: CataFn<U, Extract<U, Record<K, any>>, R>;
};

export type Cata<U extends Union<Tagged<string, Record<string, unknown>>[]>> =
  <R>(arg: CataArg<U, R>) =>
    (union: U) =>
      R;

type MatchFn<V, R> = (args: Args<V>) => R;

type MatchArg<U extends Union<Tagged<string, Record<string, unknown>>[]>, R> = {
  [K in Tag<U>]: MatchFn<Extract<U, Record<K, any>>, R>;
};

export const match =
  <U extends Union<Tagged<string, Record<string, unknown>>[]>>(union: U) =>
    <R>(match: MatchArg<U, R>): R => {
        const tag = Object.keys(union)[0] as Tag<U>;
        return match[tag](union[tag] as any);
      };