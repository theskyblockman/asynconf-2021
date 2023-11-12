import 'dart:async';

import 'base.dart';

class PosInputManager extends InputManager<Pos> {
  @override
  FutureOr<({bool isValid, String? comment})> validateInput(String input) {
    List<String> parts = input.split('-');

    if (parts.length != 2) {
      return (
        isValid: false,
        comment:
            'Veuillez bien suivre le format suivant: {position y}:{position x}-{type d’élément}'
      );
    }

    final String rawPos = parts[0];

    List<String> rawPosParts = rawPos.split(':');

    if (rawPosParts.length != 2) {
      return (
        isValid: false,
        comment:
            'Veuillez bien suivre le format suivant: {position y}:{position x}-{type d’élément}'
      );
    }

    final String rawY = rawPosParts[1];
    final String rawX = rawPosParts[0];

    try {
      int.parse(rawY);
      int.parse(rawX);
    } catch (e) {
      return (
        isValid: false,
        comment: 'Veuillez bien utiliser des nombres entiers pour les positions'
      );
    }

    if (ElementType.fromAbbreviation(parts[1]) == null) {
      return (
        isValid: false,
        comment: 'Veuillez bien renseigner un type d\'élément valide'
      );
    }

    return (isValid: true, comment: null);
  }

  @override
  FutureOr<Pos> parseInput(String validatedInput) {
    List<String> parts = validatedInput.split('-');

    final List<String> rawPos = parts[0].split(':');

    return (
      pos: (x: int.parse(rawPos[1]), y: int.parse(rawPos[0])),
      type: ElementType.fromAbbreviation(parts[1])!
    );
  }
}

enum RelativePositions { left, right, top, bottom }

enum ElementType {
  rose('Ros'),
  spiderWeb('TodA'),
  grimoire('Grim'),
  waterPuddle('FdE'),
  mud('Bou'),
  pumpkin('Citr'),
  candle('Boug'),
  bush('Buis'),
  chandelier('Chand'),
  grave('Tom');

  final String abbreviation;

  const ElementType(this.abbreviation);

  static ElementType? fromAbbreviation(String abbreviation) {
    for (final ElementType type in ElementType.values) {
      if (type.abbreviation == abbreviation) {
        return type;
      }
    }

    return null;
  }
}

enum GraveResident {
  zombie('Zom'),
  skeleton('Squ'),
  vampire('Vamp'),
  mummy('Mom'),
  ghost('Fan'),
  witch('Sor');

  final String abbreviation;

  const GraveResident(this.abbreviation);
}

typedef RawPos = ({int x, int y});
typedef Pos = ({RawPos pos, ElementType type});

RawPos toRelative(RawPos pos, RawPos relativePos) {
  return (x: relativePos.x -  pos.x, y: relativePos.y - pos.y);
}

class ResidentRequirement {
  /// The key must be relative to the grave.
  final Map<RawPos, ElementType> requiredElements;
  final GraveResident resident;

  const ResidentRequirement({required this.requiredElements, required this.resident});

  bool test(List<Pos> elements, RawPos gravePos, bool verbose) {
    if (elements.length < requiredElements.length) {
      return false;
    }

    int matchedElements = 0;

    if(verbose) {
      print('Testing ${resident.abbreviation} for $elements at $gravePos');
    }

    for (final Pos element in elements) {
      if (!requiredElements.containsValue(element.type)) {
        continue;
      }

      final RawPos relativePos = toRelative(gravePos, element.pos);

      if(verbose) {
        print('${element.pos} relative to $gravePos = $relativePos (${element.type})');
      }

      if (requiredElements.containsKey(relativePos)) {
        if (requiredElements[relativePos] == element.type) {
          matchedElements++;
          continue;
        } else {
          return false;
        }
      }
    }

    return matchedElements >= requiredElements.length;
  }
}

class Five extends Algorithm {
  @override
  String name = 'Le Cimetière Inconnu';

  @override
  FutureOr<String>? run(bool verbose, List<String> premadeInputs) async {
    final parsedValues = await parse<List<Pos>>(
        ListInputManager(individualParameterManager: PosInputManager()),
        premadeInputs: premadeInputs,
        inputMessage:
            '''Veuillez donner une liste de valeurs séparées chacune par un point-virgule,
une valeur utilise le format suivant: {position y}:{position x}-{type d’élément}
Les types d'élément valides sont:
- une tombe (Tom)
- une rose (Ros)
- une toile d’araignées (TodA)
- un grimoire (Grim)
- une flaque d’eau (FdE)
- de la boue (Bou)
- une citrouille (Citr)
- une bougie (Boug)
- un buisson (Buis)
- un chandelier (Chand)

Votre liste de valeurs: ''');

    final List<ResidentRequirement> requirements = [
      // Zombie
      ResidentRequirement(resident: GraveResident.zombie, requiredElements: {
        (x: 0, y: 1): ElementType.mud,
        (x: 1, y: 0): ElementType.waterPuddle,
        (x: -1, y: 0): ElementType.waterPuddle,
      }),
      // Skeleton
      ResidentRequirement(resident: GraveResident.skeleton, requiredElements: {
        (x: 0, y: -1): ElementType.pumpkin,
        (x: -1, y: 0): ElementType.spiderWeb,
        (x: 1, y: 0): ElementType.spiderWeb,
      }),
      // Vampire
      ResidentRequirement(resident: GraveResident.vampire, requiredElements: {
        (x: 0, y: 1): ElementType.rose,
        (x: 1, y: 0): ElementType.chandelier,
        (x: -1, y: 0): ElementType.chandelier,
      }),
      // Mummy
      ResidentRequirement(resident: GraveResident.mummy, requiredElements: {
        (x: 1, y: 0): ElementType.bush,
        (x: -1, y: 0): ElementType.bush,
        (x: 0, y: 1): ElementType.mud,
      }),
      // Ghost
      ResidentRequirement(resident: GraveResident.ghost, requiredElements: {
        (x: 1, y: 0): ElementType.candle,
        (x: -1, y: 0): ElementType.candle,
      }),
      // Witch
      ResidentRequirement(resident: GraveResident.witch, requiredElements: {
        (x: 0, y: 1): ElementType.grimoire,
      }),
    ];

    Map<RawPos, String> matches = {};

    for (final requirement in requirements) {
      for (final grave in parsedValues
          .where((element) => element.type == ElementType.grave)) {
        if (requirement.test(
            parsedValues.where((element) {
              RawPos relativePos =
                  toRelative(grave.pos, element.pos);

              return relativePos.x.abs() <= 1 && relativePos.y.abs() <= 1;
            }).toList(),
            grave.pos, verbose)) {
          matches[grave.pos] = 'T-${grave.pos.y}:${grave.pos.x}-${requirement.resident.abbreviation}';
        }
      }
    }

    print('Sortie: ${(matches.values.toList()..sort()).join(';')};');
    return '${(matches.values.toList()..sort()).join(';')};';
  }
}
