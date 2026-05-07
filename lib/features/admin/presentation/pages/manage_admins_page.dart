import 'package:ecommerce/core/widgets/custom_back_button.dart';
import 'package:ecommerce/features/admin/presentation/controllers/manage_admins_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManageAdminsPage extends StatelessWidget {
  const ManageAdminsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller  = Get.put(ManageAdminsController());
    final searchCtrl  = TextEditingController();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F6F3),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF8F6F3),
          elevation: 0,
          leading: CustomBackButton(),
          title: const Text(
            'Manage Admins',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Info Banner ─────────────────────
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded,
                        color: Colors.blue.shade400, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search by email or username to promote or demote users.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Search Bar ──────────────────────
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller:  searchCtrl,
                  onChanged:   (value) => controller.searchUsers(value),
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText:  'Search by email or username...',
                    hintStyle: const TextStyle(
                      color: Color(0xFFBBBBBB),
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFF888888)),
                    suffixIcon: Obx(() => controller.isSearching.value
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : searchCtrl.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded,
                                    color: Color(0xFF888888), size: 18),
                                onPressed: () {
                                  searchCtrl.clear();
                                  controller.searchResults.clear();
                                },
                              )
                            : const SizedBox.shrink()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide:   BorderSide.none,
                    ),
                    filled:         true,
                    fillColor:      Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical:   16,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Results ─────────────────────────
              Expanded(
                child: Obx(() {
                  if (controller.searchResults.isEmpty &&
                      searchCtrl.text.isNotEmpty &&
                      !controller.isSearching.value) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person_search_outlined,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text('No users found',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                        ],
                      ),
                    );
                  }

                  if (controller.searchResults.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.manage_accounts_outlined,
                              size: 64, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text('Search for a user above',
                            style: TextStyle(
                              color: Color(0xFF888888),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            )),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.searchResults.length,
                    itemBuilder: (_, i) {
                      final user    = controller.searchResults[i];
                      final isAdmin = user['isAdmin'] ?? false;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
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

                            // ── Avatar ────────────────────
                            CircleAvatar(
                              radius: 24,
                              backgroundColor: isAdmin
                                  ? const Color(0xFF1A1A1A)
                                  : const Color(0xFFF8F6F3),
                              child: Text(
                                (user['username'] as String)
                                    .substring(0, 1)
                                    .toUpperCase(),
                                style: TextStyle(
                                  color: isAdmin
                                      ? Colors.white
                                      : const Color(0xFF1A1A1A),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            // ── Info ──────────────────────
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        user['username'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A1A1A),
                                        ),
                                      ),
                                      if (isAdmin) ...[
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1A1A1A),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: const Text('ADMIN',
                                            style: TextStyle(
                                              color:      Colors.white,
                                              fontSize:   9,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            )),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    user['email'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF888888),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 8),

                            // ── Toggle Button ─────────────
                            Obx(() => controller.isUpdating.value
                              ? const SizedBox(
                                  width: 20, height: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : GestureDetector(
                                  onTap: () => _confirmToggle(
                                    context:       context,
                                    controller:    controller,
                                    userId:        user['id'],
                                    username:      user['username'],
                                    currentStatus: isAdmin,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isAdmin
                                          ? Colors.red.shade50
                                          : const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      isAdmin ? 'Demote' : 'Promote',
                                      style: TextStyle(
                                        color: isAdmin
                                            ? Colors.red.shade400
                                            : Colors.white,
                                        fontSize:   13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _confirmToggle({
    required BuildContext          context,
    required ManageAdminsController controller,
    required int                   userId,
    required String                username,
    required bool                  currentStatus,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: Text(
          currentStatus ? 'Demote User' : 'Promote User',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          currentStatus
              ? 'Remove admin privileges from $username?'
              : 'Grant admin privileges to $username?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF888888))),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.toggleAdmin(
                userId:        userId,
                currentStatus: currentStatus,
              );
            },
            child: Text(
              currentStatus ? 'Demote' : 'Promote',
              style: TextStyle(
                color:      currentStatus ? Colors.red : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

}