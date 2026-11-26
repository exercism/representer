function isWrongBase(base: number): boolean {
        return (
               base < 2
            || base === undefined
            || base % 1 !== 0
        );
    }

 function isWrongFormat(digits: Array<number>, base: number): boolean {
        return (
               digits.length === 0
            || digits.length > 1 && digits[0] === 0
            || digits.some(d => d < 0 || d > base - 1)
        );
    }

export function convert(digits: Array<number>, baseA: number, baseB: number): Array<number> {
        if(isWrongBase(baseA)) {
            throw new Error(`Wrong input base`);
        }

         if(isWrongBase(baseB)) {
            throw new Error(`Wrong output base`);
         }

         if(isWrongFormat(digits, baseA)){
            throw new Error(`Input has wrong format`);
         }

         const base: Array<number> = [];
         let n = digits.reverse().map((value, index) => value * baseA ** index).reduce((a, b) => a + b, 0);

         do {
            base.push(n % baseB);
            n = Math.floor(n / baseB);
         } while (n != 0);

        return base.reverse();
    }