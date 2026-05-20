import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class CustomizedAppbar extends StatelessWidget {
  const CustomizedAppbar({super.key, required this.title, this.anyWidget, this.backButton = false});
  final bool backButton;
  final String title;
  final Widget? anyWidget;


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.appMainColor,
      toolbarHeight: 85.0,
      leading: backButton ? Center(child: CustomBackButton()) : null ,

      title: Text(
        title,
        style: AppTextStyles.appbar,
      ),
    
      actions: anyWidget != null ? [
          anyWidget!,
          SizedBox( width: 15 ),
        ] : null,
    );
  }
}