import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/stores_setting_model.dart';
import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminStoreSettingsScreen extends StatefulWidget {
  const AdminStoreSettingsScreen({super.key});

  @override
  State<AdminStoreSettingsScreen> createState() =>
      _AdminStoreSettingsScreenState();
}

class _AdminStoreSettingsScreenState extends State<AdminStoreSettingsScreen> {
  final _deliveryFeeCtrl = TextEditingController();
  final _minOrderCtrl = TextEditingController();
  final _etaCtrl = TextEditingController();
  bool _isOpen = true;
  bool _initialized = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AdminViewModel>().fetchStoreSettings();
      if (!mounted) return;
      final s = context.read<AdminViewModel>().storeSettings;
      setState(() {
        _isOpen = s.isOpen;
        _deliveryFeeCtrl.text = s.deliveryFee.toString();
        _minOrderCtrl.text = s.minOrderAmount.toString();
        _etaCtrl.text = s.estimatedDeliveryMinutes.toString();
        _initialized = true;
      });
    });
  }

  @override
  void dispose() {
    _deliveryFeeCtrl.dispose();
    _minOrderCtrl.dispose();
    _etaCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final settings = StoreSettingsModel(
      isOpen: _isOpen,
      deliveryFee: int.tryParse(_deliveryFeeCtrl.text.trim()) ?? 0,
      minOrderAmount: int.tryParse(_minOrderCtrl.text.trim()) ?? 0,
      estimatedDeliveryMinutes: int.tryParse(_etaCtrl.text.trim()) ?? 30,
    );

    final success =
        await context.read<AdminViewModel>().updateStoreSettings(settings);

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? 'Settings saved' : 'Failed to save settings'),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        title: Center(
          child: const Text(
            'Store Settings',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: !_initialized || vm.isLoadingSettings
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Store Status',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isOpen
                                  ? 'Open — accepting new orders'
                                  : 'Closed — new orders paused',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isOpen ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isOpen,
                        activeColor: const Color(0xFFCC0000),
                        onChanged: (v) => setState(() => _isOpen = v),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Delivery Fee (Rs.)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _deliveryFeeCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Minimum Order Amount (Rs.)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _minOrderCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Estimated Delivery Time (minutes)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _etaCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFCC0000),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _saving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Save Changes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ],
            ),
    );
  }
}