class ErrorModel {
  int code;
  String description;
  String message;

  ErrorModel({
    this.code = 0,
    this.message = 'Error',
    this.description = 'Unknown_error',
  });
}
