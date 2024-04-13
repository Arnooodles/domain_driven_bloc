enum RouteName {
  initial('/'),
  unsupported('/unsupported'),
  login('/login'),
  home('/home'),
  error('/error'),
  profile('/profile'),
  postDetails(':postId');

  const RouteName(this.path);
  final String path;
}
