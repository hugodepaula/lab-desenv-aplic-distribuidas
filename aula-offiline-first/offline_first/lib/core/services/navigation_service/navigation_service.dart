import 'package:flutter/material.dart';

import 'package:offline_first/core/services/navigation_service/i_navigation_service.dart';

class NavigationService implements INavigationService {
  @override
  Future<void> pop(BuildContext context) async {
    return Navigator.of(context).pop();
  }

  @override
  Future<void> push(BuildContext context, Widget target) {
    return Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => target));
  }

  @override
  Future<void> pushReplacement(BuildContext context, Widget target) {
    return Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => target));
  }
}
