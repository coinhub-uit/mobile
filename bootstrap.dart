import 'dart:io';

void main() async {
  var result = await Process.run('dart', ['pub', 'get']);
  print(result.stdout);
  result = await Process.run('dart', ['run', 'husky', 'install']);
  print(result.stdout);
}
