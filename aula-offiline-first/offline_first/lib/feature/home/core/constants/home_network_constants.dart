class HomeNetworkConstants {
  static const String homeUrl =
      'https://newsapi.org/v2/everything?q=artificial-intelligence&pageSize=20';
  static const headers = {'X-Api-Key': String.fromEnvironment('API-KEY')};
}
