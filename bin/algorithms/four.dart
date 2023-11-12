import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'base.dart';

class JsonFileInputManager extends InputManager<List<dynamic>> {
  @override
  FutureOr<({bool isValid, String? comment})> validateInput(String input) {
    final parsedFile = File(input);

    if(!parsedFile.existsSync()) {
      return (
        isValid: false,
        comment: 'Le fichier que vous avez renseigné n\'existe pas.'
      );
    }

    try {
      jsonDecode(parsedFile.readAsStringSync());
    } catch (e) {
      return (
        isValid: false,
        comment: 'Le fichier que vous avez renseigné n\'est pas un fichier JSON valide.'
      );
    }

    return (isValid: true, comment: null);
  }

  @override
  FutureOr<List<dynamic>> parseInput(String validatedInput) {
    return jsonDecode(File(validatedInput).readAsStringSync());
  }
}

class Four extends Algorithm {
  @override
  String name = 'Des tenues complètes ?';

  @override
  FutureOr<String>? run(bool verbose, List<String> premadeInputs) async {
    final Map<String, List<String>> sets = {
      'vampire': [
        'Dents de vampire',
        'Cape',
        'Faux sang',
        'Set de maquillage'
      ],
      'fantôme': [
        'Masque de fantôme',
        'Drap blanc',
        'Chaînes'
      ],
      'momie': [
        'Bandelettes blanches',
        'Set de maquillage'
      ]
    };

    final fileContent = await parse<List<dynamic>>(JsonFileInputManager(), inputMessage: 'Veuillez renseigner le chemin vers le fichier JSON : ', premadeInputs: premadeInputs);

    List<String> output = [];

    for(Map<String, dynamic> client in fileContent) {
      List<String> clientSets = [];
      for(String setName in sets.keys) {
        bool hasFailed = false;
        for(String setItem in sets[setName]!) {
          if(!client['achats'].contains(setItem)) {
            hasFailed = true;
            break;
          }
        }
        if(!hasFailed) {
          clientSets.add(setName);
        }
      }

      if(clientSets.isEmpty) {
        output.add('${client['nom']}: Aucune tenue complète');
      } else {
        output.add('${client['nom']}: ${clientSets.join(', ')}');
      }
    }

    print(output.join('\n'));

    return output.join('\n');
  }
  
}