import 'package:flutter/material.dart';

abstract class INavigationService {
  Future<void> push(BuildContext context, Widget target);
  Future<void> pushReplacement(BuildContext context, Widget target);
  Future<void> pop(BuildContext context);
}
