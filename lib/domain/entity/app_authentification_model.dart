
class AppAuthentificationModel {
  final String userId;
  final bool isLoggedIn;

  AppAuthentificationModel({required this.userId, required this.isLoggedIn});

  AppAuthentificationModel copyWith({
    String? userId,
    bool? isLoggedIn,
  }) {
    return AppAuthentificationModel(
      userId: userId ?? this.userId,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
