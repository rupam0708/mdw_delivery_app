import 'package:flutter/material.dart';
import 'package:mdw/core/themes/styles.dart';

import '../controller/main_controller.dart';

class MainDrawer extends StatelessWidget {
  final MainTab currentTab;
  final Function(MainTab) onTabSelected;
  final VoidCallback onLogout;

  const MainDrawer({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.6,
      child: SafeArea(
        child: ListView(
          children: [
            _buildTile(context, MainTab.home, Icons.home_filled),
            _buildTile(context, MainTab.orders, Icons.inventory_rounded),
            _buildTile(context, MainTab.profile, Icons.person_rounded),
            _buildTile(context, MainTab.feedback, Icons.feedback_rounded),
            ListTile(
              onTap: onLogout,
              leading: Icon(Icons.logout, color: AppColors.grey),
              title: Text(
                "Logout",
                style: TextStyle(color: AppColors.red.withAlpha(178)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, MainTab tab, IconData icon) {
    return ListTile(
      selected: currentTab == tab,
      selectedTileColor: AppColors.green.withAlpha(77),
      onTap: () {
        onTabSelected(tab);
        Navigator.pop(context);
      },
      leading: Icon(icon, color: AppColors.grey),
      title: Text(
        tab.title,
        style: TextStyle(color: AppColors.black.withAlpha(178)),
      ),
    );
  }
}
