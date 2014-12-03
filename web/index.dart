import "dart:html";

void main() {
  querySelector("#full_screen").onClick.listen((event) => querySelector("#console").requestFullscreen());
}

class Shell {
  DivElement console;
  void executeCommand(String command) {

  }
}
