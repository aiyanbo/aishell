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
      // Execute command
      DivElement response = new DivElement();
      InputElement input = event.target as InputElement;
      response.innerHtml = input.value;
      input.readOnly = true;
      input.autofocus = false;
      input.parent.children.add(response);
      input.parent.parent.children.add(createSession());
    }
  }

  DivElement createSession() {
    DivElement inter = new DivElement();
    SpanElement flag = new SpanElement();
    flag.innerHtml = "\$";
    InputElement input = new InputElement();
    input.autofocus = true;
    input.onKeyPress.listen(keyListener);
    inter.children.add(flag);
    inter.children.add(input);
    DivElement session = new DivElement();
    session.children.add(inter);
    return session;
  }
}
