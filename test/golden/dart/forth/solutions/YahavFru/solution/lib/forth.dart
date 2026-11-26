

  // ignore_for_file: literal_only_boolean_expressions
  class Forth {

    Map<String , List<String>> functions = {
    };
    
    final List<int> stack = <int>[];
    
    void evaluate(String stackS) {
      List<String> splitStr = stackS.split(' ');
      if (splitStr.length == 0) {
        throw Exception('Stack empty');
      }

      Map<String, List<int> Function(int, int)> arithmetics =  {
        '+': (int a, int b) => [a + b],
        '-': (int a, int b) => [a - b],
        '*': (int a, int b) => [a * b],
        '/': (int a, int b) {
          if (b == 0) throw Exception('Division by zero');
          return [a ~/ b];
        },
        'swap': (int a, int b) => [b, a],
        'over': (int a, int b) => [a, b, a]
      };
    
      Map<String, List<int> Function(int)> manipulations = {
        'dup': (int a) => [a, a],
        'drop': (int a) => [],
      };

      for (int i = 0; i < splitStr.length; i++) {
        if(functions.containsKey(splitStr[i].toLowerCase())){
          String iTemp = splitStr[i];
          splitStr.removeAt(i);
          splitStr.insertAll(i, functions[iTemp.toLowerCase()] as Iterable<String>);
        }
        if(splitStr[i] == ":"){
          if(int.tryParse(splitStr[ i + 1 ]) != null){throw Exception('Invalid definition');};
          List<String> uFunAct = [];
          splitStr.removeAt(i);
          String uFunNm = splitStr.removeAt(i);
          for(int s = i; s < splitStr.length - 1; s++){
            bool added = false;
            if(functions.containsKey(splitStr[s])){
              uFunAct.addAll(functions[splitStr[s].toLowerCase()] as Iterable<String>);
              added = true;
            }else if(splitStr[s] == ';'){
              break;
            }if(added == false){uFunAct.add(splitStr[s]);};
            added = false;
          }
          functions[uFunNm.toLowerCase()] = uFunAct;
          break;
        }
        if(manipulations.containsKey(splitStr[i].toLowerCase())){
          if (stack.length < 1) throw Exception('Stack empty');
          int a = stack.removeLast();
          List<int> results = manipulations[splitStr[i].toLowerCase()]!(a);
          stack.addAll(results);
        }else if(manipulations.containsKey(splitStr[i].toLowerCase())){
          if (stack.length < 1) throw Exception('Stack empty');
          int a = stack.removeLast();
          List<int> results = manipulations[splitStr[i].toLowerCase()]!(a);
          stack.addAll(results);
        }else if (arithmetics.containsKey(splitStr[i].toLowerCase())) {
          if (stack.length < 2) throw Exception('Stack empty');
          int b = stack.removeLast();
          int a = stack.removeLast();
          stack.addAll(arithmetics[splitStr[i].toLowerCase()]!(a, b));
        }else if(int.tryParse(splitStr[i]) != null){  
          stack.add(int.parse(splitStr[i]));
        }else{
          throw Exception('Unknown command');
        }
      }
    }
  }
