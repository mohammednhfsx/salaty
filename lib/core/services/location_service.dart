import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService {
  // جلب الموقع الحالي
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("خطأ", "خدمة الموقع معطلة — فعّلها من الإعدادات");
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("خطأ", "تم رفض صلاحية الموقع");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("خطأ", "الصلاحية مرفوضة نهائياً — غيّرها من إعدادات التطبيق");
      return null;
    }

    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // تحويل الإحداثيات لعنوان نصي
  Future<Map<String, String>?> getAddressFromPosition(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return null;

      Placemark place = placemarks.first;

      return {
        'city': place.administrativeArea ?? place.locality ?? '',
        'address':
            '${place.street ?? ''}, ${place.subLocality ?? ''}'.trim().replaceAll(RegExp(r'^,|,$'), ''),
      };
    } catch (e) {
      Get.snackbar("خطأ", "فشل تحديد العنوان: $e");
      return null;
    }
  }
}