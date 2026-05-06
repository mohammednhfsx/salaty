# 🛍️ Salaty — سلتي
### منصة تسوق إلكتروني متكاملة مبنية بـ Flutter

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Firestore-orange?logo=firebase)
![GetX](https://img.shields.io/badge/State-GetX-purple)
![Platform](https://img.shields.io/badge/Platform-Android-green?logo=android)

---

## 📱 نظرة عامة

**Salaty** هو تطبيق تسوق إلكتروني متكامل يتيح للمستخدمين تصفح المنتجات وإضافتها للسلة وإتمام الطلبات بسهولة، مع لوحة تحكم كاملة للأدمن لإدارة المنتجات والطلبات ومتابعة الأرباح.

---

## ✨ المميزات

### 👤 المستخدم
- تسجيل حساب مع التحقق من البريد الإلكتروني
- تصفح المنتجات مع فلتر بالفئات والبحث الفوري
- سلة تسوق محفوظة في السحابة
- إتمام الطلب مع تحديد الموقع تلقائياً عبر GPS
- متابعة حالة الطلبات (انتظار / تأكيد / تسليم)
- إشعارات فورية عند تحديث حالة الطلب
- إدارة العناوين المحفوظة
- سجل الإشعارات

### 🔧 الأدمن
- إضافة وتعديل وحذف المنتجات مع رفع الصور
- إدارة جميع الطلبات مع فلتر بالحالة
- تغيير حالة الطلب مع إرسال إشعار تلقائي للزبون
- عرض موقع الزبون على Google Maps
- لوحة إحصائيات تعرض المبيعات والأرباح

---

## 🏗️ معمارية المشروع

```
04  FRONTEND   — Views + Widgets
03  BACKEND    — Controllers + Services
02  DATABASE   — Models + Firestore
01  REQUIREMENTS — Firebase + Routes + Setup
        ↑ مبني من الأسفل للأعلى
```

---

## 📁 هيكل المجلدات

```
lib/
├── main.dart
├── route.dart
├── Admin/
│   └── admin.dart
├── controller/
│   ├── auth/
│   ├── cart/
│   ├── home/
│   ├── order_controller.dart
│   ├── profile_controller.dart
│   └── notification_controller.dart
├── core/
│   ├── constant/
│   ├── functions/
│   ├── services/
│   │   ├── services.dart
│   │   └── notification_service.dart
│   ├── theme/
│   └── widgets/
├── models/
│   ├── product_model.dart
│   ├── cart_model.dart
│   ├── order_model.dart
│   └── user_model.dart
└── view/
    ├── auth/
    └── screen/
```

---

## 🔥 Firestore Structure

```
users/
  {uid}/
    name, email, role, fcmToken
    addresses/  → عناوين التوصيل
    notifications/  → إشعارات المستخدم

products/
  {id}/
    name, description, price, image, category

carts/
  {uid}/
    items[], updatedAt

orders/
  {id}/
    userId, items[], total, status
    customerName, phone, city, address
    paymentMethod, platformFee
    createdAt
```

---

## 🔔 نظام الإشعارات

```
أدمن يغيّر حالة الطلب
        ↓
FCM V1 API (Service Account JWT)
        ↓
إشعار يصل للزبون فوراً
        ↓
يُحفظ في Firestore → يظهر في شاشة الإشعارات
```

---

## 📦 الحزم المستخدمة

| الحزمة | الاستخدام |
|---|---|
| `firebase_core` | تهيئة Firebase |
| `firebase_auth` | المصادقة |
| `cloud_firestore` | قاعدة البيانات |
| `firebase_messaging` | الإشعارات |
| `flutter_local_notifications` | إشعارات محلية |
| `dart_jsonwebtoken` | FCM V1 JWT |
| `get` | إدارة الحالة والتنقل |
| `http` | طلبات HTTP |
| `image_picker` | اختيار الصور |
| `geolocator` | تحديد الموقع |
| `geocoding` | تحويل إحداثيات لعنوان |
| `url_launcher` | فتح Google Maps |

---

## 🚀 تشغيل المشروع

```bash
# 1. استنسخ المشروع
git clone https://github.com/username/salaty.git

# 2. ثبّت الحزم
flutter pub get

# 3. أضف ملف google-services.json في android/app/

# 4. أضف ملف service_account.json في assets/
#    ⚠️ لا ترفعه على GitHub

# 5. شغّل التطبيق
flutter run
```

---

## 🔐 الأمان

- Firestore Security Rules مفعّلة لكل collection
- Service Account محفوظ محلياً فقط (`.gitignore`)
- التحقق من البريد الإلكتروني مطلوب للدخول
- الأدمن يتحقق منه عبر Firestore role

---

## 📊 نسبة الاكتمال

```
المتطلبات    ████████████████████  100%
Models       ████████████████████  100%
Controllers  ████████████████████  100%
Views        ████████████████████  100%
─────────────────────────────────────
المجموع      ████████████████████  100% ✅
```

---

## 👨‍💻 تطوير

> مشروع تعليمي تجاري مبني بـ Flutter + Firebase
> تم تطويره بالكامل من الصفر مع اتباع أفضل الممارسات

---

## 📄 الترخيص

```
MIT License — حر الاستخدام مع ذكر المصدر
```