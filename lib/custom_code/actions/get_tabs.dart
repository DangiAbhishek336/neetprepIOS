// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<List<int>> getTabs(int numberOfQuetions) async {
  // Add your function code here!
  List<int> tabs = [];
  print(numberOfQuetions);
  int num = 1;
  for (int i = 0; i < numberOfQuetions; i++) {
    tabs.add(num++);
  }
  print(tabs);
  return tabs;
}
