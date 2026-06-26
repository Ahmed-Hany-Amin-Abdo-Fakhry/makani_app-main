sealed class UserLocationState {
  const UserLocationState();
}

final class UserLocationInitial extends UserLocationState {
  const UserLocationInitial();
}

final class UserLocationLoading extends UserLocationState {
  const UserLocationLoading();
}

final class UserLocationReady extends UserLocationState {
  const UserLocationReady({
    required this.latitude,
    required this.longitude,
    required this.displayLine,
  });

  final double latitude;
  final double longitude;
  final String displayLine;
}

final class UserLocationError extends UserLocationState {
  const UserLocationError({required this.message});
  final String message;
}
