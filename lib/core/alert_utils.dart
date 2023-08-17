import 'package:flutter/material.dart';
import 'package:flutter_test_application_1/core/common_alert_dialog.dart';


mixin AlertUtils {
  static void showErrorDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    String alertButtonType = AlertButtonType.ok,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    bool isHtml = false,
    TextAlign? textAlign,
    String? title,
    double? buttonHeight,
  }) {
    _showAlertDialog(
      context: context,
      title: title,
      message: message,
      alertType: AlertType.error,
      onActionPressed: onActionPressed,
      actionButtonLabel: actionButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      alertButtonType: alertButtonType,
      isHtml: isHtml,
      onCancelActionPressed: onCancelActionPressed,
      textAlign: textAlign,
      buttonHeight: buttonHeight,
    );
  }

  static void showSuccessDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    String alertButtonType = AlertButtonType.ok,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    bool isHtml = false,
    String? title,
  }) {
    _showAlertDialog(
      context: context,
      title: title,
      message: message,
      alertType: AlertType.success,
      onActionPressed: onActionPressed,
      actionButtonLabel: actionButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      alertButtonType: alertButtonType,
      isHtml: isHtml,
      onCancelActionPressed: onCancelActionPressed,
    );
  }

  static void showWarningDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    String alertButtonType = AlertButtonType.ok,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    bool isHtml = false,
    String? title,
  }) {
    _showAlertDialog(
      context: context,
      title: title,
      message: message,
      alertType: AlertType.warning,
      onActionPressed: onActionPressed,
      actionButtonLabel: actionButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      alertButtonType: alertButtonType,
      isHtml: isHtml,
      onCancelActionPressed: onCancelActionPressed,
    );
  }

  static void showInfoDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    String alertButtonType = AlertButtonType.ok,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    bool isHtml = false,
    String? title,
  }) {
    _showAlertDialog(
      context: context,
      title: title,
      message: message,
      alertType: AlertType.info,
      onActionPressed: onActionPressed,
      actionButtonLabel: actionButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      alertButtonType: alertButtonType,
      isHtml: isHtml,
      onCancelActionPressed: onCancelActionPressed,
    );
  }

  static void showConfirmDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    String alertButtonType = AlertButtonType.yesNo,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    bool isHtml = false,
    String? title,
  }) {
    _showAlertDialog(
      context: context,
      title: title,
      message: message,
      alertType: AlertType.info,
      onActionPressed: onActionPressed,
      actionButtonLabel: actionButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      alertButtonType: alertButtonType,
      isHtml: isHtml,
      onCancelActionPressed: onCancelActionPressed,
    );
  }

  static void showEmailDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    String alertButtonType = AlertButtonType.ok,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    bool isHtml = false,
  }) {
    _showAlertDialog(
      context: context,
      message: message,
      alertType: AlertType.email,
      onActionPressed: onActionPressed,
      actionButtonLabel: actionButtonLabel,
      cancelButtonLabel: cancelButtonLabel,
      alertButtonType: alertButtonType,
      isHtml: isHtml,
      onCancelActionPressed: onCancelActionPressed,
    );
  }


   static void _showAlertDialog({
    required BuildContext context,
    required String message,
    Function(BuildContext context)? onActionPressed,
    Function(BuildContext context)? onCancelActionPressed,
    required String alertType,
    String alertButtonType = AlertButtonType.ok,
    String actionButtonLabel = '',
    String cancelButtonLabel = '',
    String? title,
    bool isHtml = false,
    TextAlign? textAlign,
    double? buttonHeight,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CommonAlertDialog(
          title: title,
          description: message,
          alertType: alertType,
          textAlign: textAlign,
          buttonHeight: buttonHeight,
          actionButtonCallback: onActionPressed != null
              ? () => onActionPressed(context)
              : () {
               // Navigator.of(context).pop();
                },
          actionButtonLabel: actionButtonLabel.isNotEmpty
              ? actionButtonLabel
              : alertButtonType == AlertButtonType.yesNo
                  ? "Yes"
                  : "OK",
          cancelButtonCallback: onCancelActionPressed != null
              ? () => onCancelActionPressed(context)
              : alertButtonType == AlertButtonType.ok
                  ? null
                  : () {
               // Navigator.of(context).pop();
                    },
          cancelButtonLabel: cancelButtonLabel.isNotEmpty
              ? cancelButtonLabel
              : alertButtonType == AlertButtonType.yesNo
                  ?"No"
                  : "Cancel",
          isHtml: isHtml,
        );
      },
    );
  }
 
}

mixin AlertType {
  static const custom = 'custom';
  static const email = 'email';
  static const error = 'error';
  static const facebook = 'facebook';
  static const info = 'info';
  static const success = 'success';
  static const warning = 'warning';
}

mixin AlertButtonType {
  static const ok = 'OK';
  static const okCancel = 'OK_CANCEL';
  static const yesNo = 'YES_NO';
}


/*

AlertUtils.showSuccessDialog(
                  context: context,
                  message:
                      context.l10n.popupTextMyprofileProfileUpdatedSuccessfully,
                  onActionPressed: (ctx) {
                    ctx.router.pop();
                    context.router.navigate(
                      const MyProfileStack(
                        children: [
                          MyProfileRoute(),
                        ],
                      ),
                    );
                  },
                );

                */