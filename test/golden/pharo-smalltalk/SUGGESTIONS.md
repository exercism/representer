# Suggestions for Pharo Smalltalk

[`transition.md`](../../../lib/inspector/languages/pharo_smalltalk/transition.md) says how Inspector treats Pharo Smalltalk differently from Basic, which the track used before.
These are changes that could improve it.
None of them is in Inspector yet, because a change to Pharo Smalltalk's own behaviour needs a human to decide it.
The counts come from a text search of the 115 golden solutions, so they are approximate.

## Spellings that are apart today

1. **Drop the method categories.** A category such as `{ #category : #accessing }` above a method only files the method in the browser, so `{ #category : #accessing }` and `{ #category : 'as yet unclassified' }` make no difference to the solution working. Today two solutions with the same code and different categories stay apart. The golden solutions have 381 method categories.
2. **Drop the `#category`, `#package` and `#tag` of a class header.** These name the package that holds the class, as in `#category : #'Exercise@TwoFer'`, and make no difference to the solution working. Most golden solutions use the exercise's own package, so this would merge few of them.
3. **Write a category as a symbol and as a string the same way.** The Tonel reader reads `#category : #accessing` and `#category : 'accessing'` as the same category. Today they stay apart. 53 golden categories are strings. This one matters only if categories are kept.
4. **Drop a `^ self` at the end of a method.** A method that ends without a return answers `self`, so `foo [ x bar. ^ self ]` and `foo [ x bar ]` behave the same. A mentor might still comment on the explicit return. 7 golden methods end with `^ self`.
5. **Read `1e10` as the integer `10000000000`.** Pharo reads a number with an exponent and no point as an integer, so `1e10` and `10000000000` are the same. Today `1e10` keeps its text. No golden solution uses such a number.
6. **Sort the methods of a class.** The order of the methods in a Tonel file makes no difference to the solution working, and Pharo itself writes them in alphabetical order. Solutions written outside Pharo can put them in any order. Most golden solutions were written in Pharo, so this would merge few of them.

## Names

7. **Rename the binary selectors that the solution defines.** A class can define `=`, `<` or `+`, as in `Money >> + other [ ... ]`. Inspector keeps every binary selector, so it doesn't rename a binary method the solution defines, because renaming by text would also rename every `+` on numbers. 4 golden solutions define a binary method.
8. **Rename the traits in a `#traits` entry.** A class header names its traits in a string, as in `#traits : 'TComparable'`. If the solution defines the trait, Inspector renames it in the trait's own header but not in this string. 1 golden solution uses `#traits`.

## Snippet

9. **Skip the class header and the method categories.** The `Class { }` header and the `{ #category : ... }` line above each method take up several of the card's 15 lines, so the card could start at the first method and leave the categories out. Every golden solution starts with a class header.
