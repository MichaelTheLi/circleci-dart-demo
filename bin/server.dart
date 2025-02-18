// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Use the client program, number_guesser.dart to automatically make guesses.
// Or, you can manually guess the number using the URL localhost:8080/?q=#,
// where # is your guess.
// Or, you can use the make_a_guess.html UI.

// #docregion main
import 'dart:convert';
import 'dart:io';
import 'dart:math' show Random;

Random intGenerator = Random();
int myNumber = intGenerator.nextInt(10);

Future main() async {
  Map<String, String> envVars = Platform.environment;

  print("I'm thinking of a number: $myNumber");

  int port = 8080;

  if (envVars.containsKey('PORT')) {
    port = int.parse(envVars['PORT']);
  }
  print("Listening on port: $port");

  HttpServer server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    port,
  );
  await for (var request in server) {
    handleRequest(request);
  }
}
// #enddocregion main

// #docregion handleRequest
void handleRequest(HttpRequest request) {
  try {
    // #docregion request-method
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      // #enddocregion handleRequest
      request.response
        ..statusCode = HttpStatus.methodNotAllowed
        ..write('Unsupported request: ${request.method}.')
        ..close();
      // #docregion handleRequest
    }
    // #enddocregion request-method
  } catch (e) {
    print('Exception in handleRequest: $e');
  }
  print('Request handled.');
}
// #enddocregion handleRequest

void handleGet(HttpRequest request) {
  final guess = request.uri.queryParameters['q'];

  final response = request.response;
  response.statusCode = HttpStatus.ok;
  response.headers.add('content-type', 'application/json');
  response.headers.add('Access-Control-Allow-Origin', '*');

  if (guess == myNumber.toString()) {
    response
      ..writeln('{"result": true, "smaller": false}')
      ..close();

    myNumber = intGenerator.nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else if (int.parse(guess) < myNumber) {
    response
      ..writeln('{"result": false, "smaller": false}')
      ..close();
  } else {
    response
    ..writeln('{"result": false, "smaller": true}')
    ..close();
  }
}
