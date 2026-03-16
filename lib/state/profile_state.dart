import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class Profile {
  final String name;
  final String email;
  final String phone;
  final String city;
  final String about;

  const Profile({
    this.name = '',
    this.email = '',
    this.phone = '',
    this.city = '',
    this.about = '',
  });

  Profile copyWith({
    String? name,
    String? email,
    String? phone,
    String? city,
    String? about,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      about: about ?? this.about,
    );
  }
}

class ProfileController extends ChangeNotifier {
  Profile _profile = const Profile(
    name: '',
    email: '',
    phone: '',
    city: '',
    about: '',
  );

  Profile get profile => _profile;

  void update({
    String? name,
    String? email,
    String? phone,
    String? city,
    String? about,
  }) {
    _profile = _profile.copyWith(
      name: name,
      email: email,
      phone: phone,
      city: city,
      about: about,
    );
    notifyListeners();
  }

  void setAll(Profile p) {
    _profile = p;
    notifyListeners();
  }

  void clear() {
    _profile = const Profile();
    notifyListeners();
  }
}

class ProfileScope extends InheritedNotifier<ProfileController> {
  const ProfileScope({
    Key? key,
    required ProfileController notifier,
    required Widget child,
  }) : super(key: key, notifier: notifier, child: child);

  static ProfileController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ProfileScope>();
    assert(scope != null, 'ProfileScope yukarida tanimli degil.');
    return scope!.notifier!;
  }
}