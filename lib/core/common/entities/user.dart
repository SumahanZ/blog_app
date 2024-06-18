// ignore_for_file: public_member_api_docs, sort_constructors_first

//dont make the jsonconversion here because user entity here is only concerned with the domain layer, the conversion is handle by the model in the usermodel because it interacts with the repository implementation which returns a raw json data which we have to convert into our own model. The entity here is going to be used by the presentation and domain layers

//other layer can use domain layers stuff (implementations), but domain layers cant use stuff from other layers it is only concerned with itself
//he is like a tsundere

//we move the user entity to the core because it is used in every features of the app
class User {
  final String id;
  final String email;
  final String name;
  final String? token;

  User({
    required this.id,
    this.token,
    required this.email,
    required this.name,
  });
}
