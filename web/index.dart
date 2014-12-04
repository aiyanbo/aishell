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
      var response = new DivElement();
      var input = event.target as InputElement;
      response.innerHtml = input.value;
      input.readOnly = true;
      input.autofocus = false;
      input.parent.children.add(response);
      var session = createSession();
      input.parent.parent.children.add(session.session);
      session.input.focus();
    }
  }

  Session createSession() {
    var inter = new DivElement();
    var flag = new SpanElement();
    flag.innerHtml = "\$";
    InputElement input = new InputElement();
    input.autofocus = true;
    input.onKeyPress.listen(keyListener);
    inter.children.add(flag);
    inter.children.add(input);
    var session = new DivElement();
    session.children.add(inter);
    return new Session(s:session, i:input);
  }
}

class Session {
  var session = null;
  var input = null;

  Session({DivElement s, InputElement i}) {
    this.session = s;
    this.input = i;
  }
}