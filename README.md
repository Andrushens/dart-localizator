To create localization json file based on another json file run commands:
    dart pub get - on first run only to resolve dependencies
    dart bin/transcript.dart -s filename -l localeFrom -d localeTo -f destFilename
    s - source file path with existing translations
    l - locale of source file
    d - destination locale
    *optional f - destination file path

dart bin/transcript.dart -s intl_en.arb -l en -d de
    creates intl_de.arb
  