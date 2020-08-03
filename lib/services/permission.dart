import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class PermissionsService {
  final PermissionHandlerPlatform _permissionHandler = PermissionHandlerPlatform.instance;

  Future<bool> _requestPermission(Permission permission) async {
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }
}