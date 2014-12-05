import "dart:html";
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Tools tools = new Tools();
  tools.startup();

  Shell shell = new Shell();
  shell.startup();
}

class Tools {
  void startup({String fullScreenButtonSelector: "#full_screen", String consoleSelector: "#console"}) {
    querySelector(fullScreenButtonSelector).onClick.listen((event) => querySelector(consoleSelector).requestFullscreen());
  }
}


class Shell {
  final Logger logger = new Logger("Shell");
  DivElement _console;

  Shell({String consoleSelector: "#console"}) {
    _console = querySelector(consoleSelector);
  }

  void startup() {
    _console.querySelector("#first").onKeyPress.listen(keyListener);
  }

  bool registerComponentObject(object) {

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