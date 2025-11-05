import 'package:flutter/material.dart';
import 'package:flutter_application_3/constants/colors.dart';

  class AppTextStyles {
  static final TextStyle px12blue = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 12,
    color: AppColors.primarycolor,
  );
  static final TextStyle superSmall = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 11,
    fontStyle: FontStyle.normal,
    color: AppColors.lightgreycolor,
  );
  static final TextStyle px10blue = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    fontSize: 10,
    color: AppColors.azure,
  );
  static final TextStyle titleStyle = TextStyle(
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: AppColors.darkGreen,
  );

  }