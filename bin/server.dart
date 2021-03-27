// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Use the client program, number_guesser.dart to automatically make guesses.
// Or, you can manually guess the number using the URL localhost:8080/?q=#,
// where # is your guess.
// Or, you can use the make_a_guess.html UI.

// #docregion main
import 'dart:io';
import 'dart:math' show Random;

Random intGenerator = Random();
int myNumber = intGenerator.nextInt(10);

Future main() async {
  Map<String, String> envVars = Platform.environment;

  print("I'm thinking of a number: $myNumber");

  int port = 8080;

  if (envVars.containsKey('PORT')) {
    port = envVars['PORT'] as int;
  }

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

// #docregion handleGet, statusCode, uri, write
void handleGet(HttpRequest request) {
  // #enddocregion write
  final guess = request.uri.queryParameters['q'];
  // #enddocregion uri
  final response = request.response;
  response.statusCode = HttpStatus.ok;
  // #enddocregion statusCode
  // #docregion write
  if (guess == myNumber.toString()) {
    response
      ..writeln('true')
      ..writeln("I'm thinking of another number.")
      ..close();
    // #enddocregion write
    myNumber = intGenerator.nextInt(10);
    print("I'm thinking of another number: $myNumber");
  } else {
    response
      ..writeln('false')
      ..close();
    // #docregion write
  }
  // #docregion statusCode, uri
}
