// @ts-check
//
// The line above enables type checking for this file. Various IDEs interpret
// the @ts-check directive. It will give you helpful autocompletion when
// implementing this exercise.

/**
 * Determines how long it takes to prepare a certain juice.
 *
 * @param {string} name
 * @returns {number} time in minutes
 */
export function timeToMixJuice(name) {
    switch (name) {
        case "Pure Strawberry Joy":
            return 0.5;

        case "Energizer":
        case "Green Garden":
            return 1.5;

        case "Tropical Island":
            return 3;

        case "All or Nothing":
            return 5;

        default:
            return 2.5;
    }
}

/**
 * Calculates the number of limes that need to be cut
 * to reach a certain supply.
 *
 * @param {number} limeWedgesNeeded
 * @param {string[]} limes
 * @returns {number} number of limes cut
 */
export function limesToCut(limeWedgesNeeded, limes) {
    let i = 0;

    if (limeWedgesNeeded === 0) {
        return i;
    } else {
        let limeWedgesCount = 0;
        const limesLength = limes.length;

        while(i < limesLength && limeWedgesCount <= limeWedgesNeeded) {
            switch(limes[i]) {
                case "small":
                    limeWedgesCount += 6;
                    i++;
                    continue;

                case "medium":
                    limeWedgesCount += 8;
                    i++;
                    continue;

                case "large":
                    limeWedgesCount += 10;
                    i++;
                    continue;

                default:
                    break;
            }
        }

        return i;
    }
}

/**
 * Determines which juices still need to be prepared after the end of the shift.
 *
 * @param {number} timeLeft
 * @param {string[]} orders
 * @returns {string[]} remaining orders after the time is up
 */
export function remainingOrders(timeLeft, orders) {
    let timeToMixRemaningOrders = 0;
    let i = 0;

    while(timeToMixRemaningOrders < timeLeft) {
        timeToMixRemaningOrders += timeToMixJuice(orders[i]);

        i++;
    }

    const remainingOrdersToMix = orders.splice(i, orders.length);
    return remainingOrdersToMix;
}
