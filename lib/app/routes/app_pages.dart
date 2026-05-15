import 'package:ekart/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:ekart/features/auth/presentation/pages/reset_password_page.dart';
import 'package:ekart/features/home/presentation/pages/splash_page.dart';
import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/features/admin/presentation/pages/admin_home_page.dart';
import 'package:ekart/features/admin/presentation/pages/manage_admins_page.dart';
import 'package:ekart/features/cart/presentation/state/bindings/cart_binding.dart';
import 'package:ekart/features/home/presentation/pages/home_page.dart';
import 'package:ekart/features/auth/presentation/pages/login_page.dart';
import 'package:ekart/features/auth/presentation/pages/registeration_page.dart';
import 'package:ekart/features/home/presentation/state/binding/home_binding.dart';
import 'package:ekart/features/orders/presentation/pages/checkout_page.dart';
import 'package:ekart/features/orders/presentation/pages/payment_page.dart';
import 'package:ekart/features/orders/presentation/state/binding/orders_binding.dart';
import 'package:ekart/features/products/presentation/pages/edit_product_page.dart';
import 'package:ekart/features/auth/presentation/state/bindings/auth_bindings.dart';
import 'package:ekart/features/products/presentation/pages/product_detail_page.dart';
import 'package:ekart/features/products/presentation/pages/create_product_page.dart';
import 'package:ekart/features/profile/presentation/pages/edit_user_profile_page.dart';
import 'package:ekart/features/products/presentation/state/bindings/product_binding.dart';
import 'package:ekart/features/profile/presentation/pages/view_personal_info_page.dart';
import 'package:ekart/features/profile/presentation/state/bindings/user_profile_binding.dart';
import 'package:ekart/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:get/get.dart';


class AppPages {
  static final pages = [
    // Splash Page
    GetPage(name: AppRoutes.splash,   page: () => const SplashPage(), binding: AuthBindings()),


    // Auth Pages
    GetPage(name: AppRoutes.login,   page: () => const LoginPage()),
    GetPage(name: AppRoutes.register,   page: () => const RegisterationPage()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordPage()),
    GetPage(name: AppRoutes.resetPassword, page: () => const ResetPasswordPage()),



    // Home Page
    GetPage(
      name: AppRoutes.home,   
      page: () => const HomePage(),
      bindings: [
        HomeBinding(),
        ProductBinding(), 
        CartBinding(),
        OrderBinding(),
        UserProfileBinding(),
      ]),


    // Admin Panel
    GetPage(
      name: AppRoutes.adminHome,   
      page: () => const AdminHomePage(), 
      bindings: [
        ProductBinding(),
        OrderBinding(),
        UserProfileBinding(),
      ]
    ),
    GetPage(name: AppRoutes.manageAdmins, page: () => const ManageAdminsPage() ),
    

    // Profile Relevant Pages
    GetPage( name: AppRoutes.editProfile,   page: () => const EditUserProfilePage(), binding: UserProfileBinding() ),
    GetPage( name: AppRoutes.viewProfileDetails,  page: () => ViewPersonalInfoPage(), binding: UserProfileBinding() ),
    
    
    // Products Relevant Pages
    GetPage( name: AppRoutes.productDetail, page: () => const ProductDetailPage() ),
    GetPage( name: AppRoutes.createProduct, page: () => const CreateProductPage() ),
    GetPage( name: AppRoutes.editProduct,   page: () => const EditProductPage() ),
    

    // Checkout & Payment
    GetPage( name: AppRoutes.checkout,   page: () => const CheckoutPage(), bindings: [OrderBinding(), UserProfileBinding() ]),
    GetPage( name: AppRoutes.payment,   page: () => const PaymentPage() ),

    // Wishlist
    GetPage(name: AppRoutes.wishlist, page: () => const WishlistPage()),

  ];
}