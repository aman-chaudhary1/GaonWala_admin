import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../utility/constants.dart';
import '../dashboard/components/dash_board_header.dart';
import 'provider/app_control_provider.dart';

class AppControlScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            DashBoardHeader(),
            Gap(defaultPadding),
            Text(
              "App Control Settings",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gap(defaultPadding),
            Consumer<AppControlProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.appConfig == null) {
                  return Center(child: CircularProgressIndicator());
                }

                return Container(
                  padding: EdgeInsets.all(defaultPadding),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildToggleTile(
                        title: "Ordering Enabled",
                        subtitle: "Allow or block new orders in the app",
                        value: provider.isOrderingEnabled,
                        onChanged: (val) => provider.toggleOrdering(val),
                      ),
                      Gap(defaultPadding),
                      _buildToggleTile(
                        title: "Show Welcome Popup",
                        subtitle: "Show a welcome dialog to first-time users",
                        value: provider.showWelcomePopup,
                        onChanged: (val) => provider.toggleWelcomePopup(val),
                      ),
                      Gap(defaultPadding),
                      _buildToggleTile(
                        title: "Review System Enabled",
                        subtitle: "Allow users to give feedback and rate the app",
                        value: provider.reviewEnabled,
                        onChanged: (val) => provider.toggleReview(val),
                      ),
                      Gap(defaultPadding * 2),
                      _buildTextField(
                        controller: provider.welcomeMsgCtrl,
                        label: "Welcome Message",
                        hint: "Enter the message for the welcome popup",
                        maxLines: 3,
                      ),
                      Gap(defaultPadding),
                      _buildTextField(
                        controller: provider.orderBlockedMsgCtrl,
                        label: "Order Blocked Message",
                        hint: "Message shown when ordering is disabled",
                        maxLines: 3,
                      ),
                      Gap(defaultPadding * 2),
                      Center(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: defaultPadding * 2,
                              vertical: defaultPadding,
                            ),
                            backgroundColor: primaryColor,
                          ),
                          onPressed: provider.isLoading
                              ? null
                              : () => provider.updateAppConfig(),
                          icon: provider.isLoading
                              ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Icon(Icons.save),
                          label: Text(provider.isLoading ? "Saving..." : "Save Settings"),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Gap(defaultPadding),
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white60, fontSize: 12)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: primaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        Gap(8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: bgColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      width: double.infinity,
      decoration: BoxDecoration(
        color: secondaryColor.withOpacity(0.5),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.amber),
              Gap(10),
              Text(
                "Dynamic Control",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Gap(10),
          Text(
            "Changes made here reflect instantly in the user app without requiring an update. Use this to handle maintenance or pre-launch phases.",
            style: TextStyle(color: Colors.white60, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
