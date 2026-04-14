import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import '../../utility/constants.dart';
import '../dashboard/components/dash_board_header.dart';
import 'provider/version_provider.dart';

class VersionUpdateScreen extends StatelessWidget {
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
              "App Version Settings",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Gap(defaultPadding),
            Consumer<VersionProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading && provider.versionInfo == null) {
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
                      _buildTextField(
                        controller: provider.latestVersionCtrl,
                        label: "Latest Version",
                        hint: "e.g. 1.0.5",
                      ),
                      Gap(defaultPadding),
                      _buildTextField(
                        controller: provider.minVersionCtrl,
                        label: "Minimum Required Version",
                        hint: "e.g. 1.0.4",
                      ),
                      Gap(defaultPadding),
                      Row(
                        children: [
                          Text("Force Update: "),
                          Switch(
                            value: provider.forceUpdate,
                            onChanged: (value) => provider.updateForceUpdate(value),
                            activeColor: primaryColor,
                          ),
                          Gap(10),
                          Text(
                            provider.forceUpdate ? "Yes (Mandatory)" : "No (Optional)",
                            style: TextStyle(
                              color: provider.forceUpdate ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gap(defaultPadding),
                      _buildTextField(
                        controller: provider.messageCtrl,
                        label: "Update Message",
                        hint: "Enter the message to show to users",
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
                              : () => provider.updateVersionInfo(),
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
            _buildInstructionCard(),
          ],
        ),
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

  Widget _buildInstructionCard() {
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
              Icon(Icons.info_outline, color: primaryColor),
              Gap(10),
              Text(
                "How Versioning Works",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          Gap(10),
          _bulletPoint("Latest Version: The most recent version available in the store."),
          _bulletPoint("Min Required Version: Any version below this will trigger a FORCE update."),
          _bulletPoint("Force Update Toggle: If ON, even users with a version between Min and Latest will see a MANDATORY dialog."),
          _bulletPoint("Message: This text is displayed to the user in the update dialog."),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("• ", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
          Expanded(child: Text(text, style: TextStyle(color: Colors.white60, fontSize: 13))),
        ],
      ),
    );
  }
}
