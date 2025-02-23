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
  var envFileExample = File('.env.example')
  if (!await envFile.exists()) {
    await envFileExample.copy('.env')
    print('an empty ".env" file created');
  }
}
