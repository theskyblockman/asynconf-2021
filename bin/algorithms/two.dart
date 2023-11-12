import 'dart:async';
import 'dart:math';

import 'base.dart';

class Two extends Algorithm {
  @override
  String name = 'Les déguisements délirants';

  @override
  FutureOr<String>? run(bool verbose, List<String> premadeInputs) async {
    final parsedValues = await parse<Map<String, int>>(
        BatchInputManager(
            individualParameterManager: IntInputManager(), parameters: [
              'villas',
              'houses',
              'apartments',
              'mummies',
              'vampires',
              'ghosts'
        ]),
        premadeInputs: premadeInputs,
        inputMessage:
            '''Voici les valeurs attendues dans l'ordre séparées chacune par un point-virgule: 
- nombre de villas
- nombre de maisons
- nombre d'apparts.
- nombre de momies
- nombre de vampires
- nombre de fantômes
Veuillez renseigner les valeurs : ''');

    int mummiesCandies = 0;
    int vampiresCandies = 0;
    int ghostsCandies = 0;

    // Apartments
    for (int i = 0; i < parsedValues['apartments']!; i++) {
      final int cappedMummies = parsedValues['mummies']!.clamp(0, 2);
      mummiesCandies += cappedMummies * 3;

      final int cappedGhosts = parsedValues['ghosts']!.clamp(0, 1);
      ghostsCandies += cappedGhosts * 4;
    }

    // Houses
    for (int i = 0; i < parsedValues['houses']!; i++) {
      final int cappedGhosts = max(0, parsedValues['ghosts']! - 1);
      ghostsCandies += cappedGhosts * 3;

      mummiesCandies += parsedValues['mummies']!;

      final int cappedVampires = parsedValues['vampires']!.clamp(0, 4);
      vampiresCandies += cappedVampires * 2;
      if(parsedValues['vampires']! > 4) {
        vampiresCandies += parsedValues['vampires']! - 4;
      }
    }

    // Villas
    for (int i = 0; i < parsedValues['villas']!; i++) {
      mummiesCandies += parsedValues['mummies']! * 2;

      final int cappedVampires = parsedValues['vampires']!.clamp(0, 1);
      vampiresCandies += cappedVampires * 12;
      if(parsedValues['vampires']! > 1) {
        vampiresCandies += parsedValues['vampires']! * 2 - 2;
      }

      ghostsCandies += parsedValues['ghosts']! * 2;
    }

    int totalDwellings = parsedValues['apartments']! + parsedValues['houses']! + parsedValues['villas']!;
    vampiresCandies -= totalDwellings * 2;
    ghostsCandies -= parsedValues['apartments']! * 2;
    mummiesCandies -= parsedValues['houses']!;

    vampiresCandies = max(0, vampiresCandies);
    ghostsCandies = max(0, ghostsCandies);
    mummiesCandies = max(0, mummiesCandies);

    print('Sortie: Momies: $mummiesCandies, Fantômes: $ghostsCandies, Vampires: $vampiresCandies');

    return 'Mummies: $mummiesCandies, Ghosts: $ghostsCandies, Vampires: $vampiresCandies';
  }
}
