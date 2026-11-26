class Proverb {
  String recite(List<String> items) {
    if (items.isEmpty) return "";

    List<String> lines = [];

    // Generate the sequential lines
    for (int i = 0; i < items.length - 1; i++) {
      lines.add("For want of a ${items[i]} the ${items[i + 1]} was lost.");
    }

    // Add the concluding line using the first item
    lines.add("And all for the want of a ${items[0]}.");

    return lines.join("\n");
  }
}