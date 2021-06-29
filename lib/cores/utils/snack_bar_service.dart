import 'package:food_dash_app/cores/utils/emums.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomSnackBarService {
  static final SnackbarService _snackbarService =
      GetIt.instance<SnackbarService>();

  static void showErrorSnackBar(String message) {
    _snackbarService.showCustomSnackBar(
      variant: SnackBarType.success,
      message: message,
      title: 'Error',
      duration: const Duration(seconds: 3),
    );
  }

  static void showSuccessSnackBar(String message) {
    _snackbarService.showCustomSnackBar(
      variant: SnackBarType.success,
      message: message,
      title: 'Success',
      duration: const Duration(milliseconds: 2000),
    );
  }

  static void showWarningSnackBar(String message) {
    _snackbarService.showCustomSnackBar(
      variant: SnackBarType.warning,
      message: message,
      title: 'Warning',
      duration: const Duration(milliseconds: 2000),
    );
  }
}
