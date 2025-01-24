import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // Check if a single permission is granted
  static Future<bool> checkPermission(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  // Request a single permission
  static Future<bool> requestPermission(Permission permission) async {
    final status = await permission.request();
    return status.isGranted;
  }

  // Check and request multiple permissions at once
  static Future<bool> requestPermissions(List<Permission> permissions) async {
    final statuses = await Future.wait(permissions.map((e) => e.request()));
    return statuses.every((status) => status.isGranted);
  }

  // Check if all necessary permissions are granted
  static Future<bool> arePermissionsGranted(List<Permission> permissions) async {
    final statuses = await Future.wait(permissions.map((e) => e.status));
    return statuses.every((status) => status.isGranted);
  }
}
