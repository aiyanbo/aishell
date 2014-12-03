import "dart:html";
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  querySelector("#full_screen").onClick.listen((event) => querySelector("#console").requestFullscreen());
  Shell shell = new Shell();
}


class Shell {
  final Logger logger = new Logger("Shell");
  DivElement console;

  Shell({String consoleSelector: "#console"}) {
    console = querySelector(consoleSelector);
    _init();
  }

  void _init() {
    console.querySelector("#first").onKeyPress.listen(keyListener);
  }

  void executeCommand(String command) {

  }

  void keyListener(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER) {
      logger.fine("Start execute command: ${(event.target as InputElement).value}");
    }
  }
}
