import 'package:flavormate/core/navigation/p_go_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String currentRoute() {
  final BuildContext context = navigationKey.currentContext!;
  return GoRouter.of(context).routeInformationProvider.value.uri.toString();
}
