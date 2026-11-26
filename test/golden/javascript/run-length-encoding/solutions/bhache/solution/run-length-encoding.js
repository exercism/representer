//
// This is only a SKELETON file for the 'Run Length Encoding' exercise. It's been provided as a
// convenience to get you started writing code faster.
//

/**
 * 
 * @param {String} message 
 * @returns {String}
 */
export const encode = (message) => {
    if (message === '') return message;
    let encoding = '', first = message[0], count = 1;
    for (let i = 1; i < message.length; i++) {
        if (first === message[i]) count++
        else {
            encoding += (count > 1 ? String(count) : '') + first;
            first = message[i];
            count = 1;
        }
    }
    return encoding + (count > 1 ? String(count) : '') + first;
};

/**
 * 
 * @param {String} message 
 * @returns {String}
 */
export const decode = (message) => {
    let decoding = '';
    for (let i = 0, digits = ''; i < message.length; i++) {
        if (Number(message[i])) digits += message[i];
        else {
            decoding += message[i].repeat((digits === '') ? 1 : Number(digits));
            digits = '';
        }
    }
    return decoding;
};
