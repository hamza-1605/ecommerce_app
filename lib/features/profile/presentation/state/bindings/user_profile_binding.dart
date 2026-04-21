import 'package:ecommerce/features/profile/data/datasources/remote/user_profile_remote_datasource.dart';
import 'package:ecommerce/features/profile/data/repository/user_profile_repository_impl.dart';
import 'package:ecommerce/features/profile/domain/repository/user_profile_repository.dart';
import 'package:ecommerce/features/profile/domain/usecases/create_user_profile_usecase.dart';
import 'package:ecommerce/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:ecommerce/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:ecommerce/features/profile/presentation/state/controller/user_profile_controller.dart';
import 'package:get/get.dart';

class UserProfileBinding extends Bindings{
  @override
  void dependencies() {
    // Remote Datasource
    Get.lazyPut( () => UserProfileRemoteDatasource( Get.find() ), fenix: true );
    
    // Repository
    Get.lazyPut<UserProfileRepository>( 
      () => UserProfileRepositoryImpl( Get.find() ),
      fenix: true 
    );
    
    // Usecases
    Get.lazyPut( () => GetUserProfileUsecase( Get.find()) , fenix: true);
    Get.lazyPut( () => UpdateUserProfileUsecase( Get.find()) , fenix: true);
    Get.lazyPut( () => CreateUserProfileUsecase( Get.find()) , fenix: true);

    // Controller
    Get.lazyPut( () => UserProfileController(
      Get.find(),
      Get.find(),
      Get.find(),
    ), fenix: true);
  }
} 