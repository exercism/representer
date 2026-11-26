#!/usr/bin/env node --experimental-modules

export const isIsogram = input => ! /(\w).*\1/i.test(input);
