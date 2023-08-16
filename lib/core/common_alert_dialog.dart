import 'package:flutter/material.dart';
import 'package:flutter_test_application_1/core/button_with_border.dart';

import 'alert_utils.dart';
import 'app_images.dart';

class CommonAlertDialog extends StatelessWidget {
  const CommonAlertDialog({
    Key? key,
    this.title,
    required this.description,
    required this.actionButtonLabel,
    required this.actionButtonCallback,
    required this.alertType,
    this.cancelButtonLabel,
    this.cancelButtonCallback,
    this.imageWidget,
    this.isHtml = false,
    this.titleFirst = false,
    this.textAlign,
    this.buttonHeight,
  }) : super(key: key);

  final VoidCallback actionButtonCallback;
  final String actionButtonLabel;
  final String alertType;
  final VoidCallback? cancelButtonCallback;
  final String? cancelButtonLabel;
  final String description;
  final Widget? imageWidget;
  final bool isHtml;
  final String? title;
  final bool titleFirst;
  final TextAlign? textAlign;
  final double? buttonHeight;

  Widget _buildIcon() {
    switch (alertType) {
      case AlertType.info:
        return AppImages.alertInfo;
      case AlertType.error:
        return AppImages.alertError;
      case AlertType.success:
        return AppImages.alertSuccess;
      case AlertType.warning:
        return AppImages.alertWarning;    
      case AlertType.custom:
        return imageWidget!;
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.only(
              left: 40,
              right: 40,
            ),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.grey.withOpacity(0.5),
              //     spreadRadius: 0,
              //     blurRadius: 20,
              //     offset: const Offset(0, 2),
              //   ),
              // ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Material(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (!titleFirst)
                          SizedBox(
                            child: _buildIcon(),
                          ),
                        if (title != null) ...[
                          SizedBox(
                            height: 30,
                          ),
                          Text(
                            title ?? '',
                            textAlign: TextAlign.center,
                            
                          ),
                        ],
                        if (titleFirst) ...[
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            child: _buildIcon(),
                          ),
                        ],
                        SizedBox(
                          height: 15,
                        ),
                        
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (cancelButtonCallback != null) ...[
                          Expanded(
                            child: ButtonWithBorder(
                              label: cancelButtonLabel ?? '',
                              labelColor: Color.fromARGB(255, 104, 101, 90),
                              backgroundColor: Colors.white,
                              borderColor: Color.fromARGB(255, 127, 126, 122),
                              onPressed: cancelButtonCallback,
                              textAlign: textAlign,
                              buttonHeight: buttonHeight,
                            ),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                        ],
                        Expanded(
                          child: ButtonWithBorder(
                            label: actionButtonLabel,
                            labelColor: Colors.white,
                            backgroundColor: Colors.red,
                            borderColor: Colors.red,
                            onPressed: actionButtonCallback,
                            textAlign: textAlign,
                            buttonHeight: buttonHeight,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


