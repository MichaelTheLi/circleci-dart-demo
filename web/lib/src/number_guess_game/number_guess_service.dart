import 'dart:async';
import 'dart:convert';
import 'dart:html';

import 'package:angular/core.dart';

/// Mock service emulating access to a to-do list stored on a server.
@Injectable()
class NumberGuessService {
  Future<GuessResult> guess(int val) async {
    final jsonString = await HttpRequest.getString('https://dart-api-1.herokuapp.com/?q=' + val.toString());
    var guessResult = json.decode(jsonString) as Map;
    return GuessResult(guessResult['result'], guessResult['smaller']);
  }
}

class GuessResult {
  bool result;
  bool smaller;

  GuessResult(this.result, this.smaller);
}
