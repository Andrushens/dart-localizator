Allows you to create localization files for intl or other packages that require json-like structure localizations

To create localization file based on another json file run commands:

    dart pub get
    dart bin/transcript.dart -s filename -l localeFrom -d localeTo -f destFilename
 
s - source file path with existing translations

l - locale of source file

d - destination locale

*optional f - destination file path

Following command will create intl_de.arb

    dart bin/transcript.dart -s intl_en.arb -l en -d de

  
