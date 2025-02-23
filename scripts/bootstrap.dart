import 'dart:io';

void main() async {
  var resultRestoreDeps = await Process.run('dart', ['pub', 'get']);
  print(resultRestoreDeps.stdout);

  var resultInstallHusky = await Process.run('dart', [
    'run',
    'husky',
    'install',
  ]);
  print(resultInstallHusky.stdout);

  var envFile = File('.env');
  if (!await envFile.exists()) {
    await envFile.create();
    print('an empty ".env" file created');
  }
}
