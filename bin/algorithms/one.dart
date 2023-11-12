import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'base.dart';

class Base64InputManager extends InputManager<String> {
  @override
  FutureOr<({bool isValid, String? comment})> validateInput(String input) {
    try {
      base64Decode(input);
    } catch (e) {
      return (
        isValid: false,
        comment: 'Veuillez renseigner une valeur en base64 valide.'
      );
    }

    return (isValid: true, comment: null);
  }

  @override
  FutureOr<String> parseInput(String validatedInput) {
    return validatedInput;
  }
}

class One extends Algorithm {
  @override
  String name = 'Le code ensorcelé';

  @override
  FutureOr<String>? run(bool verbose, List<String> premadeInputs) async {
    String input = await parse<String>(Base64InputManager(),
        inputMessage: 'Veuillez écrire le code : ', premadeInputs: premadeInputs);
    Uint8List data = base64Decode(input);
    String parsedMessage = utf8.decode(data);

    if (verbose) {
      print('Le code décodé à partir de la base64: $parsedMessage');
    }

    List<String> alphabet = 'abcdefghijklmnopqrstuvwxyz'.split('');

    String translatedMessage = '';

    for (String char in parsedMessage.split('')) {
      if (alphabet.contains(char.toLowerCase())) {
        // Add to translated message the char if it is not in the alphabet, else add the char at the index of the alphabet of the char - 2, if the char is 'a' then it will be 'y'
        int editedIndex = alphabet.indexOf(char.toLowerCase()) - 2;

        if(editedIndex < 0) {
          editedIndex = alphabet.length - editedIndex - 3;
        }

        if(char == char.toUpperCase()) {
          translatedMessage += alphabet[editedIndex].toUpperCase();
        } else {
          translatedMessage += alphabet[editedIndex];
        }
      } else {
        translatedMessage += char;
      }
    }

    print('Sortie: $translatedMessage');

    return translatedMessage;
  }
}
