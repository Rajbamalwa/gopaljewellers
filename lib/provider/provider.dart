import 'dart:developer';

import 'package:flutter/foundation.dart';

class drawerProvider with ChangeNotifier {
  String _items = "TEMPLE (GERU) 22K";
  String get items => _items;
  var fromGm;
  var toGM;
  updateFilter(f, t) {
    fromGm = f;
    toGM = t;
    log("$fromGm");
    log("$toGM");
    notifyListeners();
  }

  updateScreen(value) {
    _items = value.toString();

    notifyListeners();
  }

  String _layout = "grid";
  String get layout => _layout;

  updateLayout() {
    if (_layout == "grid") {
      _layout = "list";
      notifyListeners();
    } else {
      _layout = "grid";
      notifyListeners();
    }
    notifyListeners();
  }
}
