class ErrorModel {
  ErrorModel({required this.error});

  factory ErrorModel.notAuth() {
    return ErrorModel(error: 'Неверный логин или пароль');
  }

  factory ErrorModel.alreadyExistUser() {
    return ErrorModel(error: 'Пользователь с таким логином уже существует');
  }

  factory ErrorModel.noItem() {
    return ErrorModel(error: 'Ошибка определения задачи');
  }

  Map<String, dynamic> toJson() => {
        'error': error,
      };

  final String error;
}
