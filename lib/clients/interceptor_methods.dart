class InterceptorMethods {
  final void Function() onUnauthenticated;
  final void Function() onNoConnection;

  InterceptorMethods({
    required this.onUnauthenticated,
    required this.onNoConnection,
  });
}
