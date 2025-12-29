import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:web_admin_bulls_asset/providers/live_class_provider.dart';
import 'package:web_admin_bulls_asset/theme/app_colors.dart';
import 'package:web_admin_bulls_asset/widgets/admin_layout.dart';
import '../models/live_class_model.dart';

class LiveClassesScreen extends StatefulWidget {
  const LiveClassesScreen({Key? key}) : super(key: key);

  @override
  State<LiveClassesScreen> createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LiveClassProvider>().fetchLiveClasses();
    });
  }

  Future<void> _showAddLiveClassDialog() async {
    final titleController = TextEditingController();
    final instructorController = TextEditingController();
    final roomIdController = TextEditingController();
    DateTime selectedStartTime = DateTime.now();
    DateTime selectedEndTime = DateTime.now().add(const Duration(hours: 1));

    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Schedule Live Class'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Class Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: instructorController,
                  decoration: const InputDecoration(
                    labelText: 'Instructor Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: roomIdController,
                  decoration: const InputDecoration(
                    labelText: 'Room ID / Meeting Link',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Start Time'),
                  subtitle: Text(
                    DateFormat(
                      'MMM dd, yyyy - hh:mm a',
                    ).format(selectedStartTime),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedStartTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedStartTime),
                      );
                      if (time != null) {
                        setState(() {
                          selectedStartTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
                ListTile(
                  title: const Text('End Time'),
                  subtitle: Text(
                    DateFormat(
                      'MMM dd, yyyy - hh:mm a',
                    ).format(selectedEndTime),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: selectedEndTime,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(selectedEndTime),
                      );
                      if (time != null) {
                        setState(() {
                          selectedEndTime = DateTime(
                            date.year,
                            date.month,
                            date.day,
                            time.hour,
                            time.minute,
                          );
                        });
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.isNotEmpty &&
                    instructorController.text.isNotEmpty &&
                    roomIdController.text.isNotEmpty) {
                  final liveClass = LiveClass(
                    id: '',
                    title: titleController.text,
                    instructor: instructorController.text,
                    roomId: roomIdController.text,
                    startTime: selectedStartTime,
                    endTime: selectedEndTime,
                    isLive: false,
                  );

                  try {
                    await context.read<LiveClassProvider>().addLiveClass(
                      liveClass,
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Live class scheduled successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteLiveClass(String id, String title) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Live Class'),
        content: Text('Are you sure you want to delete "$title"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await context.read<LiveClassProvider>().deleteLiveClass(id);
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Live class deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final liveClassProvider = context.watch<LiveClassProvider>();

    return AdminLayout(
      currentRoute: '/live-classes',
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.live_tv, size: 32, color: Colors.red),
                          const SizedBox(width: 12),
                          Text(
                            'Live Classes',
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Schedule and manage live trading sessions.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _showAddLiveClassDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Schedule Class'),
                ),
              ],
            ),
          ),

          liveClassProvider.liveClasses.isEmpty
              ? Card(
                  child: Padding(
                    padding: const EdgeInsets.all(48),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.live_tv_outlined,
                            size: 64,
                            color: AppColors.lightMutedForeground,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No Live Classes Scheduled',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Schedule your first live class to get started!',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: AppColors.lightMutedForeground,
                                ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: _showAddLiveClassDialog,
                            icon: const Icon(Icons.add),
                            label: const Text('Schedule Your First Class'),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: liveClassProvider.liveClasses.length,
                  itemBuilder: (context, index) {
                    final liveClass = liveClassProvider.liveClasses[index];
                    return LiveClassCard(
                      liveClass: liveClass,
                      onDelete: () =>
                          _deleteLiveClass(liveClass.id, liveClass.title),
                      onToggleLive: () async {
                        if (liveClass.isLive) {
                          await context.read<LiveClassProvider>().endLiveClass(
                            liveClass.id,
                          );
                        } else {
                          await context
                              .read<LiveClassProvider>()
                              .startLiveClass(liveClass.id);
                        }
                      },
                    );
                  },
                ),
        ],
      ),
    );
  }
}

class LiveClassCard extends StatelessWidget {
  final LiveClass liveClass;
  final VoidCallback onDelete;
  final VoidCallback onToggleLive;

  const LiveClassCard({
    Key? key,
    required this.liveClass,
    required this.onDelete,
    required this.onToggleLive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isUpcoming = liveClass.startTime.isAfter(now);
    final isOngoing =
        liveClass.startTime.isBefore(now) && liveClass.endTime.isAfter(now);
    final isPast = liveClass.endTime.isBefore(now);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: liveClass.isLive
                    ? Colors.red.withOpacity(0.1)
                    : AppColors.sidebarPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                liveClass.isLive ? Icons.live_tv : Icons.video_call,
                color: liveClass.isLive ? Colors.red : AppColors.sidebarPrimary,
                size: 40,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          liveClass.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (liveClass.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.circle, color: Colors.white, size: 8),
                              SizedBox(width: 4),
                              Text(
                                'LIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (isUpcoming)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Upcoming',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        )
                      else if (isPast)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Completed',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: 16,
                        color: AppColors.lightMutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        liveClass.instructor,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 20),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.lightMutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat(
                          'MMM dd, hh:mm a',
                        ).format(liveClass.startTime),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.meeting_room,
                        size: 16,
                        color: AppColors.lightMutedForeground,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Room: ${liveClass.roomId}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.lightMutedForeground,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                if (isOngoing || isUpcoming)
                  ElevatedButton.icon(
                    onPressed: onToggleLive,
                    icon: Icon(
                      liveClass.isLive ? Icons.stop : Icons.play_arrow,
                    ),
                    label: Text(liveClass.isLive ? 'End' : 'Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: liveClass.isLive
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete, size: 16),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
