import 'dart:async';
import 'dart:math';

import 'base.dart';

class Three extends Algorithm {
  @override
  String name = 'La tournée du quartier';

  @override
  FutureOr<String>? run(bool verbose, List<String> premadeInputs) async {
    final parsedValues = await parse<Map<String, int>>(
        BatchInputManager(
            individualParameterManager: IntInputManager(), parameters: [
          'villas',
          'houses',
          'apartments',
          'less-per-round'
        ]),
        premadeInputs: premadeInputs,
        inputMessage:
        '''Voici les valeurs attendues dans l'ordre séparées chacune par un point-virgule: 
- bonbons par villa
- bonbons par maison
- bonbons par appart.
- bonbons en moins
Veuillez renseigner les valeurs : ''');
    int roundsAmount = 0;
    int candiesAmount = 0;

    int candyPerVilla = parsedValues['villas']!;
    int candyPerHouse = parsedValues['houses']!;
    int candyPerApartment = parsedValues['apartments']!;

    while(candyPerVilla != 0 || candyPerHouse != 0 || candyPerApartment != 0) {
      candiesAmount += candyPerVilla * 3 + candyPerHouse * 12 + candyPerApartment * 23;

      candyPerVilla = max(0, candyPerVilla - parsedValues['less-per-round']!);
      candyPerHouse = max(0, candyPerHouse - parsedValues['less-per-round']!);
      candyPerApartment = max(0, candyPerApartment - parsedValues['less-per-round']!);

      roundsAmount++;
    }

    print('Sortie: Nombre de bonbons: $candiesAmount Nombre de tours: $roundsAmount');

    return 'Candies amount: $candiesAmount Rounds amount: $roundsAmount';
  }

}