import 'package:flutter/foundation.dart';

class drawerProvider with ChangeNotifier {
  String _items = "Necklace";
  String get items => _items;
  String _itemImage = "assets/images/necklace.png";
  String get itemImages => _itemImage;

  updateScreen(value) {
    _items = value!['name'].toString();
    _itemImage = value!['image'].toString();

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
