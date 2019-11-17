import 'dart:io';

String fixture(String name) {
  return parseRawSample(name);
}

String parseRawSample(String filePath, [bool relative = true]) {
  filePath = relative ? "test/fixtures/$filePath" : filePath;

  String jsonString;
  try {
    jsonString = File(filePath).readAsStringSync();
  } catch (e) {
    jsonString = File("../" + filePath).readAsStringSync();
  }
  return jsonString;
}
