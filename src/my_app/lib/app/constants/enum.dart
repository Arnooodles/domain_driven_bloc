// ignore_for_file: prefer-match-file-name
enum Env {
  development,
  staging,
  production,
  test;
}

enum AppScrollController {
  home,
  profile,
}

enum StatusCode {
  http200(200),
  http201(201),
  http204(204),
  http304(304),
  http400(400),
  http401(401),
  http403(403),
  http404(404),
  http405(405),
  http415(415),
  http422(422),
  http429(429),
  http500(500),
  http000(000);

  const StatusCode(this.value);
  final int value;
}

enum ConnectionStatus {
  online,
  offline,
}

enum Gender {
  male,
  female,
  unknown,
}

enum ButtonType {
  elevated,
  filled,
  tonal,
  outlined,
  text,
}

enum SlideTransitionType {
  topToBottom,
  bottomToTop,
  leftToRight,
  rightToLeft,
}
