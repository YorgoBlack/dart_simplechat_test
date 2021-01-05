import 'package:pageloader/html.dart';

part 'sign_in_component_po.g.dart';

@PageObject()
abstract class SignInComponentPO {
  SignInComponentPO();
  factory SignInComponentPO.create(PageLoaderElement context) =
      $SignInComponentPO.create;

  @ByTagName('button')
  PageLoaderElement get usernameMaterialInput;
  @ByTagName('button')
  PageLoaderElement get passwordMaterialInput;
  @ByTagName('button')
  PageLoaderElement get signInButton;
  @ByTagName('button')
  PageLoaderElement get usernameInput;
  @ByTagName('button')
  PageLoaderElement get psswordInput;
}
