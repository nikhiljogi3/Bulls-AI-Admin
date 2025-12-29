import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:web_admin_bulls_asset/models/advisory_model.dart';
import 'package:web_admin_bulls_asset/providers/advisory_provider.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';

class AdvisoryScreen extends StatefulWidget {
  const AdvisoryScreen({Key? key}) : super(key: key);

  @override
  State<AdvisoryScreen> createState() => _AdvisoryScreenState();
}

class _AdvisoryScreenState extends State<AdvisoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdvisoryProvider>().fetchTips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AdvisoryProvider>();
    final f = DateFormat('dd MMM, yyyy hh:mm a');

    return AdminLayout(
      currentRoute: '/advisory',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.trending_up,
                            size: 32,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Advisory & Tips',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Manage stock recommendations and trading tips.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: provider.isLoading
                            ? null
                            : () async {
                                final removed = await provider.pruneOldTips();
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Removed $removed expired tips',
                                      ),
                                    ),
                                  );
                                }
                              },
                        icon: const Icon(Icons.cleaning_services, size: 18),
                        label: const Text('Remove Old'),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () => _showAddOrEditDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Tip'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (provider.isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(
                    color: AppColors.sidebarPrimary,
                  ),
                ),
              )
            else if (provider.error != null)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              )
            else if (provider.tips.isEmpty)
              Card(
                child: SizedBox(
                  height: 220,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lightbulb_outline,
                          size: 48,
                          color: AppColors.lightMutedForeground,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'No tips yet',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add your first advisory tip',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppColors.lightMutedForeground),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;
                  final crossAxisCount = maxWidth > 1200
                      ? 3
                      : maxWidth > 800
                      ? 2
                      : 1;
                  final aspectRatio = maxWidth > 1200
                      ? 1.5
                      : maxWidth > 800
                      ? 1.1
                      : 0.9;

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: aspectRatio,
                    ),
                    itemCount: provider.tips.length,
                    itemBuilder: (context, index) {
                      final tip = provider.tips[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.sidebarAccent,
                                      ),
                                      color: AppColors.sidebarPrimary
                                          .withOpacity(0.06),
                                      image:
                                          tip.logoUrl != null &&
                                              RegExp(
                                                r'^https?://',
                                              ).hasMatch(tip.logoUrl!)
                                          ? DecorationImage(
                                              image: NetworkImage(tip.logoUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null,
                                    ),
                                    child:
                                        tip.logoUrl == null ||
                                            tip.logoUrl!.isEmpty
                                        ? const Center(
                                            child: Text(
                                              'logo',
                                              style: TextStyle(
                                                color: AppColors
                                                    .lightMutedForeground,
                                              ),
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                tip.companyName,
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.titleLarge,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.sidebarAccent,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                '${tip.term[0].toUpperCase()}${tip.term.substring(1)} term',
                                                style: const TextStyle(
                                                  color: AppColors
                                                      .sidebarForeground,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          f.format(tip.publishedAt.toLocal()),
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors
                                                    .lightMutedForeground,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.sidebarAccent,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Target ₹${tip.targetPrice.toStringAsFixed(0)}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium,
                                      ),
                                    ),
                                    Icon(
                                      Icons.trending_up,
                                      color: AppColors.primaryGreen,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${tip.expectedReturnPercent.toStringAsFixed(0)}%',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Buying range',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors
                                                    .lightMutedForeground,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '₹${tip.buyMin.toStringAsFixed(0)} - ₹${tip.buyMax.toStringAsFixed(0)}',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 1,
                                    height: 40,
                                    color: AppColors.sidebarAccent,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Horizon',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors
                                                    .lightMutedForeground,
                                              ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${tip.horizonMinMonths} - ${tip.horizonMaxMonths} months',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Why this trade',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 6),
                              Flexible(
                                child: Text(
                                  tip.rationale,
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => _showAddOrEditDialog(
                                      context,
                                      existing: tip,
                                    ),
                                    child: const Text('Edit'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      await context
                                          .read<AdvisoryProvider>()
                                          .deleteTip(tip.id);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Tip deleted'),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    child: const Text('Delete'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Text(tip.action.toUpperCase()),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddOrEditDialog(
    BuildContext context, {
    AdvisoryTip? existing,
  }) async {
    final companyController = TextEditingController(
      text: existing?.companyName ?? '',
    );
    final logoController = TextEditingController(text: existing?.logoUrl ?? '');
    final term = ValueNotifier<String>(existing?.term ?? 'medium');
    final targetController = TextEditingController(
      text: existing?.targetPrice.toString() ?? '',
    );
    final returnController = TextEditingController(
      text: existing?.expectedReturnPercent.toString() ?? '',
    );
    final buyMinController = TextEditingController(
      text: existing?.buyMin.toString() ?? '',
    );
    final buyMaxController = TextEditingController(
      text: existing?.buyMax.toString() ?? '',
    );
    final horizonMinController = TextEditingController(
      text: existing?.horizonMinMonths.toString() ?? '',
    );
    final horizonMaxController = TextEditingController(
      text: existing?.horizonMaxMonths.toString() ?? '',
    );
    final rationaleController = TextEditingController(
      text: existing?.rationale ?? '',
    );
    final action = ValueNotifier<String>(existing?.action ?? 'BUY');
    DateTime publishedAt = existing?.publishedAt ?? DateTime.now();
    DateTime? expiresAt = existing?.expiresAt;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            existing == null ? 'Add Advisory Tip' : 'Edit Advisory Tip',
          ),
          content: SizedBox(
            width: 640,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _field('Company name', companyController),
                  _field('Logo URL', logoController),
                  _row([
                    _dropdown('Term', term, const ['short', 'medium', 'long']),
                    _dropdown('Action', action, const ['BUY', 'SELL', 'HOLD']),
                  ]),
                  _row([
                    _field(
                      'Target price',
                      targetController,
                      keyboard: TextInputType.number,
                    ),
                    _field(
                      'Expected return %',
                      returnController,
                      keyboard: TextInputType.number,
                    ),
                  ]),
                  _row([
                    _field(
                      'Buy min',
                      buyMinController,
                      keyboard: TextInputType.number,
                    ),
                    _field(
                      'Buy max',
                      buyMaxController,
                      keyboard: TextInputType.number,
                    ),
                  ]),
                  _row([
                    _field(
                      'Horizon min (months)',
                      horizonMinController,
                      keyboard: TextInputType.number,
                    ),
                    _field(
                      'Horizon max (months)',
                      horizonMaxController,
                      keyboard: TextInputType.number,
                    ),
                  ]),
                  _multiline('Why this trade', rationaleController),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: existing?.publishedAt ?? now,
                            firstDate: DateTime(now.year - 1),
                            lastDate: DateTime(now.year + 2),
                          );
                          if (picked != null) {
                            publishedAt = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
                          }
                        },
                        icon: const Icon(Icons.today),
                        label: const Text('Set Publish Date'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final now = DateTime.now();
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: existing?.expiresAt ?? now,
                            firstDate: DateTime(now.year - 1),
                            lastDate: DateTime(now.year + 3),
                          );
                          if (picked != null) {
                            expiresAt = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                            );
                          }
                        },
                        icon: const Icon(Icons.event_busy),
                        label: const Text('Set Expiry Date'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final tip = AdvisoryTip(
                  id: existing?.id ?? '',
                  companyName: companyController.text.trim(),
                  logoUrl: logoController.text.trim().isEmpty
                      ? null
                      : logoController.text.trim(),
                  term: term.value,
                  publishedAt: publishedAt.toUtc(),
                  expiresAt: expiresAt?.toUtc(),
                  targetPrice:
                      double.tryParse(targetController.text.trim()) ?? 0,
                  expectedReturnPercent:
                      double.tryParse(returnController.text.trim()) ?? 0,
                  buyMin: double.tryParse(buyMinController.text.trim()) ?? 0,
                  buyMax: double.tryParse(buyMaxController.text.trim()) ?? 0,
                  horizonMinMonths:
                      int.tryParse(horizonMinController.text.trim()) ?? 0,
                  horizonMaxMonths:
                      int.tryParse(horizonMaxController.text.trim()) ?? 0,
                  rationale: rationaleController.text.trim(),
                  action: action.value,
                  isActive: true,
                );

                if (existing == null) {
                  await context.read<AdvisoryProvider>().addTip(tip);
                } else {
                  await context.read<AdvisoryProvider>().updateTip(
                    tip.copyWith(id: existing.id),
                  );
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType? keyboard,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _multiline(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: 4,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    ValueNotifier<String> value,
    List<String> options,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ValueListenableBuilder<String>(
        valueListenable: value,
        builder: (context, v, _) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: v,
                onChanged: (nv) => value.value = nv ?? v,
                items: options
                    .map((o) => DropdownMenuItem(value: o, child: Text(o)))
                    .toList(),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 12),
        Expanded(child: children[1]),
      ],
    );
  }
}
