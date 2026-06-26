/// Route name and path holder for go_router.
class RouteDef {
  const RouteDef({required this.name, required this.path});
  final String name;
  final String path;
}

class Routes {
  Routes._();

  static const RouteDef splash = RouteDef(name: 'splash', path: '/');
  static const RouteDef login = RouteDef(name: 'login', path: '/login');
  static const RouteDef signUp = RouteDef(name: 'signUp', path: '/signUp');
  static const RouteDef forgotPassword =
      RouteDef(name: 'forgotPassword', path: '/forgotPassword');

  static const RouteDef resetSuccess =
      RouteDef(name: 'resetSuccess', path: '/resetSuccess');

  static const RouteDef home = RouteDef(name: 'home', path: '/home');
  static const RouteDef recommendationSeeAll =
      RouteDef(name: 'recommendationSeeAll', path: '/recommendations');
  static const RouteDef filter = RouteDef(name: 'filter', path: '/filter');
  static const RouteDef propertyDetail =
      RouteDef(name: 'propertyDetail', path: '/property/:id');
  static String propertyDetailPath(String id) => '/property/$id';

  static const RouteDef booking = RouteDef(name: 'booking', path: '/booking');
  static const RouteDef editAd = RouteDef(name: 'editAd', path: '/editAd');
  static const RouteDef myAds = RouteDef(name: 'myAds', path: '/myAds');
  static const RouteDef profile = RouteDef(name: 'profile', path: '/profile');
  static const RouteDef personalInfo =
      RouteDef(name: 'personalInfo', path: '/personalInfo');
}
