import 'dart:async';
import 'dart:io';

import 'base.dart';
import 'five.dart';
import 'four.dart';
import 'one.dart';
import 'three.dart';
import 'two.dart';

class Tests extends Algorithm {
  @override
  String name = 'Tests';

  @override
  FutureOr<String>? run(bool verbose, List<String> premadeInputs) async {
    Map<Algorithm, Map<List<String>, String>> algorithmsToTest = {
      One(): {
        ['Q2R0Y2VjZmNkdGMsIG5nIHVxdHZrbsOoaWcgaHd2LCBndiByZ3Rmd3RjICE=']: 'Abracadabra, le sortilège fut, et perdura !',
        ['U3djcGYgbuKAmWN0b3FrdGcgdWcgdHF3eHRnLCDDp2MgZmNwdWcgY3cgTnF3eHRnLg==']: 'Quand l’armoire se rouvre, ça danse au Louvre.',
        ['TmMgcHdrdiBncCDDqXbDqSwgbmMgbndwZyBma3VyY3Rjw652IG5xdHVzd2cgbmd1IG5xd3J1IHVnIG9ndnZncHYgw6Agand0bmd0Lg==']: 'La nuit en été, la lune disparaît lorsque les loups se mettent à hurler.',
        ['Q3cgTnF3eHRnLCBuYyBud29rw6h0ZyB14oCZY25ud29nIGd2IG7igJljdG9xa3RnIHXigJlxd3h0Zy4=']: 'Au Louvre, la lumière s’allume et l’armoire s’ouvre.',
      },
      Two(): {
        ['1;1;1;1;1;1']: 'Mummies: 5, Ghosts: 4, Vampires: 8',
        ['5;7;18;4;8;13']: 'Mummies: 169, Ghosts: 418, Vampires: 154',
        ['5;12;28;3;8;3']: 'Mummies: 222, Ghosts: 158, Vampires: 184',
        ['5;14;27;5;8;1']: 'Mummies: 268, Ghosts: 64, Vampires: 206',
      },
      Three(): {
        ['17;14;11;4']: 'Candies amount: 1002 Rounds amount: 5',
        ['5;9;7;12']: 'Candies amount: 284 Rounds amount: 1',
        ['23;12;5;2']: 'Candies amount: 1143 Rounds amount: 12',
        ['14;17;20;6']: 'Candies amount: 1480 Rounds amount: 4',
      },
      Four(): {
        ['assets/exercice4.json']: File('assets/answer.txt').readAsStringSync(),
      },
      Five(): {
        ['1:1-Chand;1:2-Tom;1:3-Chand;1:5-Citr;2:2-Ros;2:3-Tom;2:4-TodA;2:5-Tom;2:6-TodA;3:3-Grim;4:1-Boug;4:2-Tom;4:3-Boug;4:4-Tom;4:5-Boug;']: 'T-1:2-Vamp;T-2:3-Sor;T-2:5-Squ;T-4:2-Fan;T-4:4-Fan;',
        ['1:1-Boug;1:2-Tom;1:3-Boug;1:4-Chand;1:5-Tom;1:6-Chand;2:1-FdE;2:2-Tom;2:3-FdE;2:5-Ros;3:1-Tom;3:2-Bou;3:3-Buis;3:4-Tom;3:5-Buis;4:1-Grim;4:4-Bou;']: 'T-1:2-Fan;T-1:5-Vamp;T-2:2-Zom;T-3:1-Sor;T-3:4-Mom;',
        ['1:1-Boug;1:2-Tom;1:3-Boug;1:4-Tom;2:1-Buis;2:2-Tom;2:3-Buis;2:4-Grim;3:2-Bou;3:3-Citr;4:2-TodA;4:3-Tom;4:4-TodA;5:1-Chand;5:2-Tom;5:3-Chand;6:2-Ros;']: 'T-1:2-Fan;T-1:4-Sor;T-2:2-Mom;T-4:3-Squ;T-5:2-Vamp;',
        ['1:1-Buis;1:2-Tom;1:3-Buis;1:4-Tom;2:1-Tom;2:2-Bou;2:3-Citr;2:4-Grim;3:1-Grim;3:2-TodA;3:3-Tom;3:4-TodA;4:1-Boug;4:2-Tom;4:3-Boug;']: 'T-1:2-Mom;T-1:4-Sor;T-2:1-Sor;T-3:3-Squ;T-4:2-Fan;',
      }
    };

    for (final algorithm in algorithmsToTest.keys) {
      print('\x1b[34mTesting algorithm ${algorithm.name} (${algorithmsToTest.keys.toList().indexOf(algorithm)}/${algorithmsToTest.length})\x1b[0m');
      for (final input in algorithmsToTest[algorithm]!.keys) {
        final String? result = await algorithm.run(verbose, input);
        if(result != algorithmsToTest[algorithm]![input]) {
          print('\x1b[41mTest failed for algorithm ${algorithm.name}\x1b[0m');
          print('\x1b[31mExpected ${algorithmsToTest[algorithm]![input]} but got $result\x1b[0m');
          return 'Test failed';
        }
      }

      print('\x1b[32mTests passed for algorithm ${algorithm.name}\x1b[0m');
    }

    print('\x1b[42mAll tests passed!\x1b[0m');

    return 'Tests passed';
  }
}