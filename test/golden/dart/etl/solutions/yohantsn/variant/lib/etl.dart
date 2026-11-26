class Etl {
  Map<String, int> transform(Map<String, List<String>> originalValue){
    final mapTransformed = <String, int>{};
    for(final item in originalValue.entries){
      final point = item.key;
      for(final value in item.value){
        mapTransformed[value.toUpperCase()] = int.parse(point);
      }
    }
    return mapTransformed;
  }
}
