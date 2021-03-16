import 'dart:async';
import 'dart:io';
import 'package:dart_console/dart_console.dart';

import 'ascii_text.dart';

const String usageString = '''
    Usage:
        [-help] Help
        [-h {number}] define hours
        [-m {number}] define minutes
        [-s {number}] define seconds
    ''';

void main(List<String> arguments) {
  final console = Console();

  var time = parseArguments(arguments, console);

  final row = (console.windowHeight / 2).round() - 3;

  Timer.periodic(const Duration(milliseconds: 100), (t) {
    resetConsole(console);
    if(time.hour ==0 && time.minute == 0 && time.second == 0 && time.millisecond == 0){
      printText(console, AsciiText.defaultFont['times up'], row);
      console.cursorPosition = Coordinate(console.windowHeight-1, 0);
      exit(0);
    }else{
      printTime(console, time, row);


      time = time.subtract(Duration(milliseconds: 100));
    }
  });
}

DateTime parseArguments(List<String> arguments, Console console){
  if(arguments.isEmpty || arguments[0] == '-help' || arguments.length % 2 != 0){
    console.writeLine(usageString);
    exit(0);
  }

  var dateTime = DateTime(2020,1,1,0,0,0);
  for(var i=0; i<arguments.length; i = i+2){
    int value;
    try{
      value = int.parse(arguments[i+1]);
    }catch (e){
      throw FormatException('Argument ${i+1} (${arguments[i+1]}) is not an number');
    }
    if(arguments[i] == '-s'){
      dateTime = dateTime.add(Duration(seconds: value));
      continue;
    }else if(arguments[i] == '-m'){
      dateTime = dateTime.add(Duration(minutes: value));
      continue;
    }else if(arguments[i] == '-h'){
      dateTime = dateTime.add(Duration(hours: value));
      continue;
    }else{
      console.writeLine(usageString);
      exit(0);
    }
  }
  return dateTime;
}


void resetConsole(Console console) {
  console.clearScreen();
  console.resetCursorPosition();
  console.resetColorAttributes();
  console.rawMode = false;
}

void printTime(Console console, DateTime dateTime, int row) {
  var timeString =
      '${dateTime.hour}:${dateTime.minute}:${dateTime.second}:${dateTime.millisecond.toString()[0]}';
  for (var i = 0; i < 5; i++) {
    var str = '';
    for (var j = 0; j < timeString.length; j++) {
      var list = AsciiText.defaultFont[timeString[j]];
      str += list[i];
    }
    console.cursorPosition = Coordinate(row + i, 0);
    console.writeLine(str, TextAlignment.center);
  }
}

void printText(Console console, List<String> list, row){
  for (var i = 0; i < 6; i++) {
    console.cursorPosition = Coordinate(row + i, 0);
    console.writeLine(list[i], TextAlignment.center);
  }
}

