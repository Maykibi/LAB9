import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_application_3/constants/colors.dart';
import 'package:flutter_application_3/constants/text_styles_value.dart';
import 'package:flutter_application_3/translations/codegen_loader.g.dart';
import 'package:flutter_application_3/translations/locale_keys.g.dart';

import 'package:flutter_application_3/pages/main_page.dart';
import 'package:flutter_application_3/bloc/authentication_bloc.dart';
import 'package:flutter_application_3/repositories/auth_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('kk'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ru'),
      assetLoader: const CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

/// === ROOT APP СO ScreenUtil + BLoC + Repository ===
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return RepositoryProvider(
          create: (_) => AuthenticationRepository(),
          child: BlocProvider(
            create: (ctx) =>
                AuthenticationBloc(authRepository: ctx.read<AuthenticationRepository>()),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              theme: ThemeData(
                primarySwatch: Colors.blue,
                textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp,
                bodyColor: AppColors.black,displayColor: AppColors.black),
              ),
              home: const HomePage(title: 'Registration Page'),
            ),
          ),
        );
      },
    );
  }
}

/// ======= REGISTRATION PAGE (HomePage) ======= ///
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'My Flutter App'});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();

  // Контроллеры
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();

  // FocusNodes (из первого варианта)
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passController.dispose();
    _confirmPassController.dispose();

    _nameFocus.dispose();
    _phoneFocus.dispose();
    _passFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.title.tr()),
          centerTitle: true,
          titleTextStyle: AppTextStyles.px12blue,
          
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              buildUserNameField(),
              const SizedBox(height: 10.0),
              buildPhoneNumberField(),
              const SizedBox(height: 10.0),
              buildEmailField(),
              const SizedBox(height: 10.0),
              buildLifeStoryField(),
              const SizedBox(height: 10.0),
              buildPassField(),
              const SizedBox(height: 10.0),
              buildConfPassField(),
              const SizedBox(height: 16.0),
              buildButtonSubmit(),
              const SizedBox(height: 16.0),
              buildLocalizationButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// ======= POLYA FORMЫ (объединённые) ======= ///

  Widget buildUserNameField() {
    return TextFormField(
      focusNode: _nameFocus,
      autofocus: true,
      onFieldSubmitted: (_) {
        _fieldFocusChange(context, _nameFocus, _phoneFocus);
      },
      controller: _nameController,
      decoration: InputDecoration(
        labelText: LocaleKeys.fullName.tr(),
        hintText: LocaleKeys.fullName.tr(),
        prefixIcon: const Icon(Icons.person),
        suffixIcon: GestureDetector(
          child: Icon(Icons.delete_outline, color: AppColors.error),
          onTap: () => _nameController.clear(),
        ),
        enabledBorder: _borderDefault(),
        focusedBorder: _borderFocused(),
      ),
      validator: _validatorName,
    );
  }

  Widget buildPhoneNumberField() {
    return TextFormField(
      focusNode: _phoneFocus,
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: LocaleKeys.phoneNumber.tr(),
        hintText: '(XXX) XXX-XXXX',
        helperText: 'Phone format (XXX) XXX-XXXX',
        prefixIcon: const Icon(Icons.call),
        suffixIcon: GestureDetector(
          child: Icon(Icons.delete_outline, color: AppColors.error),
          onTap: () => _phoneController.clear(),
        ),
        enabledBorder: _borderDefault(),
        focusedBorder: _borderFocused(),
      ),
      validator: _validatorPhone,
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: LocaleKeys.emailAddress.tr(),
        hintText: LocaleKeys.emailAddress.tr(),
        prefixIcon: const Icon(Icons.email),
        enabledBorder: _borderDefault(),
        focusedBorder: _borderFocused(),
      ),
      validator: _validatorEmail,
    );
  }

  Widget buildPassField() {
    return TextFormField(
      controller: _passController,
      focusNode: _passFocus,
      obscureText: _hidePass,
      maxLength: 16,
      decoration: InputDecoration(
        labelText: LocaleKeys.password.tr(),
        hintText: LocaleKeys.password.tr(),
        icon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
        enabledBorder: _borderDefault(),
        focusedBorder: _borderFocused(),
      ),
      validator: _validatorPassword,
      onFieldSubmitted: (_) {
        _fieldFocusChange(context, _passFocus, FocusNode());
      },
    );
  }

  Widget buildConfPassField() {
    return TextFormField(
      controller: _confirmPassController,
      obscureText: _hidePass,
      maxLength: 16,
      decoration: InputDecoration(
        labelText: LocaleKeys.confirmPassword.tr(),
        hintText: LocaleKeys.confirmPassword.tr(),
        icon: const Icon(Icons.check),
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
        enabledBorder: _borderDefault(),
        focusedBorder: _borderFocused(),
      ),
      validator: _validatorConfirmPassword,
    );
  }

  Widget buildLifeStoryField() {
    return TextFormField(
      controller: _storyController,
      minLines: 3,
      maxLines: 5,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: LocaleKeys.lifeStory.tr(),
        alignLabelWithHint: true,
        helperText: 'Keep it short, this is just a demo',
        enabledBorder: _borderDefault(),
        focusedBorder: _borderFocused(),
      ),
    );
  }

  /// ======= КНОПКИ ======= ///

  Widget buildButtonSubmit() {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkGreen,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            onPressed: isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AuthenticationBloc>().add(
                            SignUpRequested(
                              email: _emailController.text.trim(),
                              password: _passController.text,
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                            ),
                          );
                    }
                  },
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Register',
                    style: TextStyle(color: AppColors.white, fontSize: 18),
                  ),
          ),
        );
      },
    );
  }

  Widget buildLocalizationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async => context.setLocale(const Locale('kk')),
          child: const Text('Қазақша'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async => context.setLocale(const Locale('ru')),
          child: const Text('Русский'),
        ),
      ],
    );
  }

  /// ======= BORDERS ======= ///
  OutlineInputBorder _borderDefault() => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        borderSide: BorderSide(color: AppColors.black, width: 2.0),
      );

  OutlineInputBorder _borderFocused() => OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        borderSide: BorderSide(color: AppColors.azure, width: 2.0),
      );

  /// ======= VALIDATORS ======= ///

  String? _validatorName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else if (value.length < 5) {
      return 'Minimum 5 characters required';
    }
    return null;
  }

  String? _validatorPhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    final phoneExp = RegExp(r'^\(\d{3}\) \d{3}-\d{4}$');
    if (!phoneExp.hasMatch(value)) {
      return 'Phone number must be in (XXX) XXX-XXXX format';
    }
    return null;
  }

  String? _validatorEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Please enter a valid email';
    return null;
  }

  String? _validatorPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validatorConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm password';
    } else if (value != _passController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
