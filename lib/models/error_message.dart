class ErrorMessage {
  ErrorMessage({
    required this.title,
    required this.desc,
    this.help,
    this.link,
  });

  final String title;
  final String desc;
  final List<String>? help;
  final String? link;
}
