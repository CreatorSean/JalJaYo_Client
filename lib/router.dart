import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvier = Provider((ref) {
  return GoRouter(
    routes: [],
  );
});
