import 'package:ekart/core/themes/app_colors.dart';
import 'package:ekart/core/themes/app_text_styles.dart';
import 'package:ekart/core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';

class CustomizedAppbar extends StatelessWidget {
  const CustomizedAppbar({super.key, required this.title, required this.actionsNeeded, this.buttonText, this.iconData, this.onPressed, this.anyWidget, this.backButton = false, this.actionColor = Colors.red});
  final bool backButton;
  final String title;
  final bool actionsNeeded;
  final String? buttonText;
  final IconData? iconData;
  final Color? actionColor;
  final VoidCallback? onPressed;
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
    
      actions: actionsNeeded ? [
        ElevatedButton.icon(
            onPressed: onPressed, 
            icon: Icon(
              iconData, 
              size: 18,
              color: actionColor
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
            ),
            label: Text(
              buttonText ?? "",
              style: TextStyle(
                color: actionColor
              ),
            )
          ),
    
          SizedBox(
            width: 10,
          ),
      ] : 
        anyWidget != null ? [
          anyWidget!,
          SizedBox( width: 15 ),
        ] : null,
    );
  }
}