//
// This is only a SKELETON file for the 'Rail Fence Cipher' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

 
export const encode = (msg, rails) =>
    fence(msg.length, rails).map((i) => msg[i]).join("");
 
export const decode = (msg, rails) => {
    const fen = fence(msg.length, rails);
    const dec = Array(msg.length);
    msg.split("").forEach((c, i) => dec[fen[i]] = c);
    return dec.join("");
};
//  middleware
function fence(length, rails) {
    const cycle_len = 2 * rails - 2;
    return Array.from({ length: rails }).flatMap((_, r) =>
        Array.from({ length }, (_, i) => i).filter((i) =>
            i % cycle_len === r || i % cycle_len === cycle_len - r
        )
    );
}
