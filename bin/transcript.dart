import 'dart:convert';
import 'dart:io';
import 'package:translator/translator.dart';
import 'package:args/args.dart';

Future<String> translateJson(
  String jsonString,
  String localeFrom,
  String localeTo,
) async {
  final translator = GoogleTranslator();
  Map<String, dynamic> res = {};
  var jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
  print('Got ${jsonMap.keys.length} keys\n');

  await Future.forEach(
    jsonMap.keys,
    (item) async {
      var key = item as String;
      await translator
          .translate(jsonMap[key], from: localeFrom, to: localeTo)
          .then((value) {
        print('$key: ${value.text}');
        res[key] = value.text;
      });
    },
  );

  var formattedRes = jsonEncode(res)
      .splitMapJoin(
        '":"',
        onMatch: (_) => '": "',
      )
      .splitMapJoin(
        '{"',
        onMatch: (_) => '{\n\t"',
      )
      .splitMapJoin(
        '",',
        onMatch: (_) => '",\n\t',
      )
      .splitMapJoin(
        '"}',
        onMatch: (_) => '"\n}',
      );
  return formattedRes;
}

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('sourceFile', abbr: 's')
    ..addOption('localeFrom', abbr: 'l')
    ..addOption('localeTo', abbr: 'd')
    ..addOption('destinationFile', abbr: 'f');
  try {
    final argResults = parser.parse(arguments);
    var fileName = argResults['sourceFile'];
    var localeFrom = argResults['localeFrom'];
    var localeTo = argResults['localeTo'];
    var newFileName = argResults['destinationFile'];
    var destinationFile = newFileName ??
        fileName.splitMapJoin(
          RegExp(r'[a-z]{2}\.'),
          onMatch: (match) => '$localeTo.',
        );

    var start = DateTime.now();

    print('source      file: $fileName');
    print('destination file: $destinationFile');
    print('source      locale: $localeFrom');
    print('destination locale: $localeTo\n');

    var contents = File(fileName).readAsStringSync();
    var translatedContents =
        await translateJson(contents, localeFrom, localeTo);
    File(destinationFile).writeAsStringSync(translatedContents);

    var now = DateTime.now();
    print('time: ${now.difference(start).inMilliseconds / 1000}');
  } catch (e) {
    print('Got exception: $e.');
  }
}
