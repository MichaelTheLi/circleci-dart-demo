import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import 'number_guess_service.dart';

@Component(
  selector: 'number-guess-game',
  styleUrls: ['number_guess_component.css'],
  templateUrl: 'number_guess_component.html',
  directives: [
    MaterialButtonComponent,
    NgFor,
    NgIf,
  ],
  providers: [ClassProvider(NumberGuessService)],
)
class NumberGuessComponent implements OnInit {
  final NumberGuessService numberGuessService;

  List<Map<int,GuessState>> guessLists = [
    generateGuessList()
  ];

  List<String> history = [];

  NumberGuessComponent(this.numberGuessService);

  @override
  Future<Null> ngOnInit() async {
  }

  static Map<int,GuessState> generateGuessList() {
    return {
      0: GuessState(0),
      1: GuessState(1),
      2: GuessState(2),
      3: GuessState(3),
      4: GuessState(4),
      5: GuessState(5),
      6: GuessState(6),
      7: GuessState(7),
      8: GuessState(8),
      9: GuessState(9),
      // TODO Generate
    };
  }

  void guess(int val) {
    var resultFuture = numberGuessService.guess(val);

    resultFuture.then((result) => handleGuessResult(result, val));
  }

  void handleGuessResult(GuessResult result, int val) {
    var guessList = guessLists.last;

    if (result.result) {
      history.add('Correct');
      history.add('===============');

      guessLists.add(generateGuessList());

      guessList[val].correct = true;
    } else {
      var newHistoryItem;
      if (result.smaller) {
        newHistoryItem = 'Smaller';
      } else {
        newHistoryItem = 'Bigger';
      }

      history.add(newHistoryItem);

      guessList[val].smaller = result.smaller;
      guessList[val].bigger = !result.smaller;
    }
  }
}

class GuessState {
  int value;
  bool smaller = false;
  bool bigger = false;
  bool correct = false;

  GuessState(this.value);
}