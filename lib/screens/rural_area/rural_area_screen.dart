import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utility/constants.dart';
import 'provider/rural_area_provider.dart';
import '../../../models/rural_area.dart';

class RuralAreaScreen extends StatefulWidget {
  @override
  _RuralAreaScreenState createState() => _RuralAreaScreenState();
}

class _RuralAreaScreenState extends State<RuralAreaScreen> {
  String? selectedBlockId;
  String? selectedPanchayatId;

  final blockNameController = TextEditingController();
  final panchayatNameController = TextEditingController();
  final villageNameController = TextEditingController();
  final deliveryFeeController = TextEditingController();
  @override
  void dispose() {
    blockNameController.dispose();
    panchayatNameController.dispose();
    villageNameController.dispose();
    deliveryFeeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RuralAreaProvider>().fetchBlocks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Rural Areas")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: "Blocks",
              child: Column(
                children: [
                  _buildAddRow(
                    controller: blockNameController,
                    hint: "Enter Block Name",
                    onAdd: () {
                      if (blockNameController.text.isNotEmpty) {
                        context.read<RuralAreaProvider>().addBlock(blockNameController.text);
                        blockNameController.clear();
                      }
                    },
                  ),
                  SizedBox(height: 10),
                  Consumer<RuralAreaProvider>(
                    builder: (context, provider, child) {
                      return Wrap(
                        spacing: 8,
                        children: provider.blocks.map((block) {
                          bool isSelected = selectedBlockId == block.sId;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                selectedBlockId = isSelected ? null : block.sId;
                                selectedPanchayatId = null;
                              });
                              if (!isSelected) provider.fetchPanchayats(block.sId!);
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(block.name ?? ""),
                                  SizedBox(width: 8),
                                  IconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.edit, size: 16, color: Colors.blue),
                                    onPressed: () => _showEditDialog(
                                      context,
                                      title: "Edit Block Name",
                                      initialValue: block.name ?? "",
                                      onSave: (newName) => provider.updateBlock(block.sId!, newName),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    constraints: BoxConstraints(),
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.delete, size: 16, color: Colors.red),
                                    onPressed: () => _showDeleteDialog(
                                      context,
                                      title: "Delete Block",
                                      content: "Are you sure you want to delete block '${block.name}'? This will also delete all its panchayats and villages.",
                                      onDelete: () => provider.deleteBlock(block.sId!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (selectedBlockId != null)
              _buildSection(
                title: "Panchayats",
                child: Column(
                  children: [
                    _buildAddRow(
                      controller: panchayatNameController,
                      hint: "Enter Panchayat Name",
                      onAdd: () {
                        if (panchayatNameController.text.isNotEmpty) {
                          context.read<RuralAreaProvider>().addPanchayat(
                                panchayatNameController.text,
                                selectedBlockId!,
                              );
                          panchayatNameController.clear();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Consumer<RuralAreaProvider>(
                      builder: (context, provider, child) {
                        return Wrap(
                          spacing: 8,
                          children: provider.panchayats.map((p) {
                            bool isSelected = selectedPanchayatId == p.sId;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  selectedPanchayatId = isSelected ? null : p.sId;
                                });
                                if (!isSelected) provider.fetchVillages(p.sId!);
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8),
                                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: isSelected ? Colors.blue : Colors.grey),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(p.name ?? ""),
                                    SizedBox(width: 8),
                                    IconButton(
                                      constraints: BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.edit, size: 16, color: Colors.blue),
                                      onPressed: () => _showEditDialog(
                                        context,
                                        title: "Edit Panchayat Name",
                                        initialValue: p.name ?? "",
                                        onSave: (newName) => provider.updatePanchayat(p.sId!, newName, selectedBlockId!),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    IconButton(
                                      constraints: BoxConstraints(),
                                      padding: EdgeInsets.zero,
                                      icon: Icon(Icons.delete, size: 16, color: Colors.red),
                                      onPressed: () => _showDeleteDialog(
                                        context,
                                        title: "Delete Panchayat",
                                        content: "Are you sure you want to delete panchayat '${p.name}'? This will delete all its villages.",
                                        onDelete: () => provider.deletePanchayat(p.sId!, selectedBlockId!),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            SizedBox(height: 20),
            if (selectedPanchayatId != null)
              _buildSection(
                title: "Villages",
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextField(
                            controller: villageNameController,
                            decoration: InputDecoration(hintText: "Village Name"),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: deliveryFeeController,
                            decoration: InputDecoration(hintText: "Fee"),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (villageNameController.text.isNotEmpty) {
                              double fee = double.tryParse(deliveryFeeController.text) ?? 0.0;
                              context.read<RuralAreaProvider>().addVillage(
                                    villageNameController.text,
                                    selectedPanchayatId!,
                                    fee,
                                  );
                              villageNameController.clear();
                              deliveryFeeController.clear();
                            }
                          },
                          child: Text("Add"),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Consumer<RuralAreaProvider>(
                      builder: (context, provider, child) {
                        return Wrap(
                          spacing: 8,
                          children: provider.villages.map((v) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 8),
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text("${v.name} (₹${v.deliveryFee})"),
                                SizedBox(width: 8),
                                IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.edit, size: 16, color: Colors.blue),
                                  onPressed: () => _showEditVillageDialog(
                                    context,
                                    village: v,
                                    onSave: (newName, newFee) => provider.updateVillage(v.sId!, newName, newFee, selectedPanchayatId!),
                                  ),
                                ),
                                SizedBox(width: 8),
                                IconButton(
                                  constraints: BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.delete, size: 16, color: Colors.red),
                                  onPressed: () => _showDeleteDialog(
                                    context,
                                    title: "Delete Village",
                                    content: "Are you sure you want to delete village '${v.name}'?",
                                    onDelete: () => provider.deleteVillage(v.sId!, selectedPanchayatId!),
                                  ),
                                ),
                              ],
                            ),
                          );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          Divider(),
          child,
        ],
      ),
    );
  }

  Widget _buildAddRow({
    required TextEditingController controller,
    required String hint,
    required VoidCallback onAdd,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(onPressed: onAdd, child: Text("Add")),
      ],
    );
  }

  void _showEditDialog(BuildContext context, {required String title, required String initialValue, required Function(String) onSave}) {
    final controller = TextEditingController(text: initialValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(controller: controller, decoration: InputDecoration(hintText: "Enter Name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                onSave(controller.text);
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showEditVillageDialog(BuildContext context, {required Village village, required Function(String, double) onSave}) {
    final nameController = TextEditingController(text: village.name);
    final feeController = TextEditingController(text: village.deliveryFee.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Village"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: InputDecoration(hintText: "Village Name")),
            SizedBox(height: 10),
            TextField(controller: feeController, decoration: InputDecoration(hintText: "Delivery Fee"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                double fee = double.tryParse(feeController.text) ?? 0.0;
                onSave(nameController.text, fee);
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, {required String title, required String content, required VoidCallback onDelete}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              onDelete();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }
}
