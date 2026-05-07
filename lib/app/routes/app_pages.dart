import 'package:ecommerce/app/splash_page.dart';
import 'package:ecommerce/app/routes/app_routes.dart';
import 'package:ecommerce/features/admin/presentation/pages/admin_home_page.dart';
import 'package:ecommerce/features/admin/presentation/pages/manage_admins_page.dart';
import 'package:ecommerce/features/cart/presentation/state/bindings/cart_binding.dart';
import 'package:ecommerce/features/home/presentation/pages/home_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/login_page.dart';
import 'package:ecommerce/features/auth/presentation/pages/registeration_page.dart';
import 'package:ecommerce/features/home/presentation/state/binding/home_binding.dart';
import 'package:ecommerce/features/orders/presentation/pages/checkout_page.dart';
import 'package:ecommerce/features/orders/presentation/pages/payment_page.dart';
import 'package:ecommerce/features/orders/presentation/state/binding/orders_binding.dart';
import 'package:ecommerce/features/products/presentation/pages/edit_product_page.dart';
import 'package:ecommerce/features/auth/presentation/state/bindings/auth_bindings.dart';
import 'package:ecommerce/features/products/presentation/pages/product_detail_page.dart';
import 'package:ecommerce/features/products/presentation/pages/create_product_page.dart';
import 'package:ecommerce/features/profile/presentation/pages/edit_user_profile_page.dart';
import 'package:ecommerce/features/products/presentation/state/bindings/product_binding.dart';
import 'package:ecommerce/features/profile/presentation/state/bindings/user_profile_binding.dart';
import 'package:ecommerce/features/wishlist/presentation/pages/wishlist_page.dart';
import 'package:get/get.dart';


class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash,   page: () => const SplashPage(), binding: AuthBindings()),

    GetPage(name: AppRoutes.login,   page: () => const LoginPage()),
    GetPage(name: AppRoutes.register,   page: () => const RegisterationPage()),

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

    GetPage(
      name: AppRoutes.adminHome,   
      page: () => const AdminHomePage(), 
      bindings: [
        ProductBinding(),
        OrderBinding(),
        UserProfileBinding(),
      ]),

    GetPage( name: AppRoutes.productDetail, page: () => const ProductDetailPage() ),
    GetPage( name: AppRoutes.createProduct, page: () => const CreateProductPage() ),
    GetPage( name: AppRoutes.editProduct,   page: () => const EditProductPage() ),

    GetPage( name: AppRoutes.editProfile,   page: () => const EditUserProfilePage(), binding: UserProfileBinding() ),
    
    GetPage( name: AppRoutes.checkout,   page: () => const CheckoutPage(), bindings: [OrderBinding(), UserProfileBinding() ]),

    GetPage( name: AppRoutes.payment,   page: () => const PaymentPage() ),

    GetPage(name: AppRoutes.wishlist, page: () => const WishlistPage()),

    GetPage(name: AppRoutes.manageAdmins, page: () => const ManageAdminsPage() ),
  ];
}