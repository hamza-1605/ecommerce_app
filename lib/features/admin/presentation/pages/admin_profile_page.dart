import 'package:ekart/app/routes/app_routes.dart';
import 'package:ekart/core/widgets/background_svg.dart';
import 'package:ekart/core/widgets/customized_appbar.dart';
import 'package:ekart/features/auth/presentation/state/controllers/auth_controller.dart';
import 'package:ekart/core/widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 70), 
        child: CustomizedAppbar(title: "Admin Profile"),
      ),

      body: Stack( 
        fit: StackFit.expand,
        alignment: AlignmentGeometry.center,
        children: [
          BackgroundSvg(),
          
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFF1A1A1A),
                        child: Text(
                          auth.currentUser.value?.username
                              .substring(0, 1).toUpperCase() ?? 'A',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        auth.currentUser.value?.username ?? '',
                        style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1A1A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('ADMIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          )),
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: 32),
          
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      InfoRow( 
                        icon: Icons.mail_outline_rounded, 
                        label: 'Email',
                        value: auth.currentUser.value?.email ?? '-'
                      ),
                      InfoRow(
                        icon: Icons.person_outline_rounded, 
                        label: 'Username',
                        value: auth.currentUser.value?.username ?? '-'
                      ),
                      InfoRow(
                        icon: Icons.shield_outlined, 
                        label: 'Role', 
                        value: 'Administrator'
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
          
                GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.manageAdmins),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.manage_accounts_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Manage Admins',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1A1A1A),
                                )),
                              SizedBox(height: 2),
                              Text('Promote or demote users',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF888888),
                                )),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: Color(0xFF888888)),
                      ],
                    ),
                  ),
                ),
          
                const Spacer(),
          
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: GradientElevatedButton.icon(
                    onPressed: () {
                      final userId = GetStorage().read('user_id');
                      Get.find<AuthController>().logout(userId: userId);
                    },
                    icon: const Icon(Icons.logout_rounded) ,
                    label: const Text('Logout') 
                  ),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}