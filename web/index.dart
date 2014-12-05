import "dart:html";
import "dart:mirrors";
import "dart:math" as math;
import "package:logging/logging.dart";

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  Tools tools = new Tools();
  tools.startup();

  Shell shell = new Shell();
  shell.startup();

  shell.registerComponentObject(tools);
}

class Tools {
  void startup({String fullScreenButtonSelector: "#full_screen", String consoleSelector: "#console"}) {
    querySelector(fullScreenButtonSelector).onClick.listen((event) => querySelector(consoleSelector).requestFullscreen());
  }

  String help() {
    return "-- help: Print documents";
  }
}


class Shell {
  final Logger logger = new Logger("Shell");
  DivElement _console;
  Map<String, InstanceMirror> instanceCommands = new Map<String, InstanceMirror>();

  Shell({String consoleSelector: "#console"}) {
    _console = querySelector(consoleSelector);
  }

  void startup() {
    _console.querySelector("#first").onKeyPress.listen(keyListener);
  }

  bool registerComponentObject(object) {
    var im = reflect(object);
    Iterable<DeclarationMirror> decls =
    im.type.declarations.values.where(
            (dm) => dm is MethodMirror && dm.isRegularMethod);
    decls.forEach((MethodMirror mm) {
      var name = MirrorSystem.getName(mm.simpleName);
      if ("startup" != name) {
        instanceCommands[name] = im ;
      }
    });
  }

  void keyListener(KeyboardEvent event) {
    if (event.keyCode == KeyCode.ENTER) {
      var input = event.target as InputElement;
      String command = (event.target as InputElement).value;
      if (command.trim().isNotEmpty) {
        logger.fine("Start execute command: ${(event.target as InputElement).value}");
        var response = new DivElement();
        response.innerHtml = executeCommand(command);
        input.parent.children.add(response);
      }
      input.readOnly = true;
      input.autofocus = false;
      var session = _createSession();
      input.parent.parent.children.add(session.session);
      session.input.focus();
    }
  }

  String executeCommand(String command) {
    if (instanceCommands.containsKey(command)) {
      var im = instanceCommands[command].invoke(new Symbol(command), []);
      return im.reflectee;
    }
    return "Command not found: ${command}";
  }

  Session _createSession() {
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