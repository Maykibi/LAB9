import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/constants/colors.dart';
import 'package:flutter_application_3/constants/text_styles_value.dart';
import 'package:flutter_application_3/translations/codegen_loader.g.dart';
import 'package:flutter_application_3/translations/locale_keys.g.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // <— инициализация easy_localization
  runApp(
    EasyLocalization(
      supportedLocales:
       [
        Locale('kk'),
        Locale('ru')
        ],
      path: 'assets/translations',
      fallbackLocale: Locale('ru'),
      assetLoader: CodegenLoader(),
      // assetLoader: const RootBundleAssetLoader(),
      child: MyApp(), // <— используем сгенерированный загрузчик
    ),
  ); // <— корневой виджет теперь ваш ScreenUtil-вариант
}

/// === ВАШ ОБЕРТОЧНЫЙ MyApp СО ScreenUtil (как вы просили) ===
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in, unit in dp)
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      // Use builder only if you need to use library outside ScreenUtilInit context
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          

          // localKeys.hellow.tr()
          // You can use the library anywhere in the app even in theme
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
          home: child,
        );
      },
      child: HomePage(title: LocaleKeys.title.tr()),
    );
  }
}

/// === ЭТО БЫВШИЙ MyApp (Stateful) — просто переименован в HomePage ===
class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'My Flutter App'});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hidePass = true;
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
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
    // ВАШ исходный Scaffold/форма — без логических изменений
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.title.tr()),
        centerTitle: true,
        titleTextStyle: AppTextStyles.px12blue,
      ),
      body: Form(
        key: _formkey,
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
            buildButtonReturn(),
            buildLocalizationButton(),
          ],
        ),
      ),
    );
  }

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
          onTap: () {
            _nameController.clear();
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: AppColors.black, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: AppColors.azure, width: 2.0),
        ),
      ),
      validator: (value) => _validatorName(value),
    );
  }

  Widget buildPhoneNumberField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: LocaleKeys.phoneNumber.tr(),
        hintText: LocaleKeys.phoneNumber.tr(),
        helperText: 'Phone format (XXX) XXX-XXXX',
        prefixIcon: const Icon(Icons.call),
        suffixIcon: GestureDetector(
          child: Icon(Icons.delete_outline, color: AppColors.error),
          onTap: () {
            _phoneController.clear();
          },
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: AppColors.black, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: AppColors.azure, width: 2.0),
        ),
      ),
      keyboardType: TextInputType.phone,
      validator: (input) => _validatePhoneNumber(input ?? '')
          ? null
          : 'Phone number must be in the format (XXX) XXX-XXXX',
    );
  }

  Widget buildPassField() {
    return TextFormField(
      obscureText: _hidePass,
      maxLength: 8,
      controller: _passController,
      decoration: InputDecoration(
        labelText: LocaleKeys.password.tr(),
        hintText: LocaleKeys.password.tr(),
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
        icon: const Icon(Icons.lock),
      ),
      validator: (value) => _validatorPassword(value ?? ''),
    );
  }

  Widget buildButtonReturn() {
    return SizedBox(
      width: 50,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen, // green color
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () {
          _submitForm();
        },
        child: const Text(
          'Submit',
          style: TextStyle(color: AppColors.white, fontSize: 18),
        ),
      ),
    );
  }

  Widget buildLocalizationButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () async {
            await context.setLocale(Locale('kk'));
          },
          child: const Text('Қазақша'),
        ),
        const SizedBox(width: 20),
        ElevatedButton(
          onPressed: () async {
            await context.setLocale(Locale('ru'));
          },
          child: const Text('Русский'),
        ),
      ],
    );
  }

  Widget buildEmailField() {
    return TextFormField(
      obscureText: _hidePass,
      maxLength: 8,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: LocaleKeys.emailAddress.tr(),
        hintText: LocaleKeys.emailAddress.tr(),
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
        icon: const Icon(Icons.email),
      ),
    );
  }

  Widget buildConfPassField() {
    return TextFormField(
      controller: _confirmPassController,
      obscureText: _hidePass,
      maxLength: 8,
      decoration: InputDecoration(
        labelText: LocaleKeys.confirmPassword.tr(),
        hintText: LocaleKeys.confirmPassword.tr(),
        suffixIcon: IconButton(
          icon: Icon(_hidePass ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() {
              _hidePass = !_hidePass;
            });
          },
        ),
        icon: const Icon(Icons.check),
      ),
    );
  }

  Widget buildLifeStoryField() {
    return TextFormField(
      controller: _storyController,
      minLines: 3, // show area height
      maxLines: 5, // allow expand up to 5 lines (or null for unlimited)
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        labelText: LocaleKeys.lifeStory.tr(),
        alignLabelWithHint: true, // keeps label at top for multi-line fields
        helperText: 'Keep it short, this is just a demo',
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: AppColors.black, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: AppColors.azure, width: 2.0),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      print('Form is valid');
      print('Name: ${_nameController.text}');
      print('Phone: ${_phoneController.text}');
      print('Email: ${_emailController.text}');
      print('Life Story: ${_storyController.text}');
    } else {
      print('Form is invalid! Please review and correct.');
    }
  }

  String _validatorName(value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    } else if (value.length < 5) {
      return 'Minimum 5 characters required';
    }
    return 'This name looks good!';
  }

  bool _validatePhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d{3}\) \d{3}-\d{4}$');
    return phoneExp.hasMatch(input);
  }

  String _validatorPassword(String value) {
    if (_passController.text.length != 8) {
      return '8 character required for password';
    } else if (_confirmPassController.text != _passController.text) {
      return 'Password does not match';
    }
    return 'OK';
  }
}
