import 'package:flutter_riverpod/flutter_riverpod.dart';


final invitePermissionsController = StateNotifierProvider<InvitePermissionsController, List<int>>((ref) => InvitePermissionsController());

class InvitePermissionsController extends StateNotifier<List<int>> {
  InvitePermissionsController() : super([]);
  
  void addPermissions(int permission) => state.add(permission);

  void removePermission(int permission) {
    if (state.contains(permission)) {
      state.remove(permission);
    }
  }
  
  String getLink(int id) {
    int permissions = 0;
    for (int perm in state) {
      permissions += perm;
    }
    return 'https://discord.com/oauth2/authorize?client_id=$id&permissions=$permissions&scope=bot';
  }
}