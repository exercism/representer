/** An item that can be added into the knapsack. */
interface Item {
  weight: number;
  value: number;
}

/** The problem conditions. */
interface Input {
  /** The maximum weight that can fit in our knapsack. */
  maximumWeight: number;
  /** The list of items to choose from that could potentially be added to the knapsack. */
  items: Item[];
}

/**
 * Determines the maximum value of items given that can fit into the knapsack, given some maximum weight.
 *
 * Uses recursion to progressively check smaller and smaller lists of items.
 *
 * ---
 *
 * @returns The maximum value of items that can be put into the knapsack.
 */
export const maximumValue = (input: Input): number => {
  const { maximumWeight, items } = input;

  /** If there are no items, then we can't add any value, so return `0`. */
  const hasItems = items.length > 0;
  if (!hasItems) {
    return 0;
  }

  const [firstItem, ...rest] = items;

  const { value: firstItemValue, weight: firstItemWeight } = firstItem;

  /** The maximum value that we could fit into our knapsack, assuming we exclude the first item. */
  const maxValueWithOtherItems = maximumValue({ maximumWeight, items: rest });

  /**
   * If the first item is too heavy, then it can't be added.
   * So we return the result of the recursive check on the rest of the items.
   */
  const isFirstItemTooHeavy = firstItemWeight > maximumWeight;
  if (isFirstItemTooHeavy) {
    return maxValueWithOtherItems;
  }

  /**
   * If the first item is not too heavy to add, then we have two options:
   * - add the first item for its value, and the max value we could get from the other items
   * - skip the first item and add the max value from the other items
   *
   * Since we don't know which of these is bigger, we have to calculate the max weight that we
   * could get by adding the other items (except with a lower max weight, since our knapsack would
   * already contain the first item). Then we compare the two options and pick the one that
   * maximizes our value.
   */
  const maxWeightLeftAfterAddingFirstItem = maximumWeight - firstItemWeight;
  const maxValueAfterAddingFirstItem = maximumValue({
    maximumWeight: maxWeightLeftAfterAddingFirstItem,
    items: rest,
  });

  /**
   * The maximum value that we could fit assuming we included the first item in the list
   * in our knapsack.
   */
  const maxValueWithFirstItemIncluded =
    maxValueAfterAddingFirstItem + firstItemValue;

  /** Return the maximum value that can be fit into the knapsack with the given items. */
  const maxValueThatCanFitInKnapsack = Math.max(
    maxValueWithOtherItems,
    maxValueWithFirstItemIncluded
  );

  return maxValueThatCanFitInKnapsack;
};
