import 'dart:convert';
import 'dart:io';
import 'forth.dart';

void main() {
  final forth = Forth();

  stdout.writeln('<Simple forth interpreter>');
  forth.evaluate('?');

  stdin
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .listen((final line) {
    try {
      forth.evaluate(line);
    } on Exception catch (e) {
      stderr.writeln(e);
    } finally {
      stdout.writeln(forth.stack);
    }
  });
}
