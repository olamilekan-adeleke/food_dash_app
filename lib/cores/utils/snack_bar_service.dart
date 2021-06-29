import 'package:get_it/get_it.dart';
import 'package:stacked_services/stacked_services.dart';

class CustomSnackBarService {
  static final SnackbarService _snackbarService =
      GetIt.instance<SnackbarService>();

  static void showErrorSnackBar(String message) {
    _snackbarService.showCustomSnackBar(
      message: message,
      title: 'Success',
    );
  }

  static void showSuccessSnackBar(String message) {
    _snackbarService.showCustomSnackBar(
      message: message,
      title: 'Error',
    );
  }
}
