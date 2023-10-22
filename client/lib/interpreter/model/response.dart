class Response {
  bool? isParsed;
  String? code;
  String? message;
  List<Map<String, dynamic>>? values;

  Response({
    this.isParsed,
    this.code,
    this.message,
    this.values,
  });
}
