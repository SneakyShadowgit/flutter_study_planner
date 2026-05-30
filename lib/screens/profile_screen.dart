import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/app_data.dart';
import '../services/hive_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Box profileBox;
  late Box tasksBox;
  late HiveService hiveService;
  final TextEditingController _nameController = TextEditingController();
  int _selectedAvatar = 0;

  final List<IconData> _avatarIcons = [
    Icons.person,
    Icons.school,
    Icons.auto_stories,
    Icons.psychology,
    Icons.emoji_objects,
    Icons.rocket_launch,
  ];

  @override
  void initState() {
    super.initState();
    profileBox = Hive.box('profileBox');
    tasksBox = Hive.box('tasksBox');
    hiveService = HiveService(tasksBox);
    _loadProfile();
  }

  void _loadProfile() {
    _nameController.text = profileBox.get('name', defaultValue: '');
    _selectedAvatar = profileBox.get('avatar', defaultValue: 0);
  }

  void _saveProfile() {
    profileBox.put('name', _nameController.text);
    profileBox.put('avatar', _selectedAvatar);
  }

  Map<String, int> _getStats() {
    final tasks = hiveService.loadTasks();
    final total = tasks.length;
    final completed = tasks.where((t) => t['completed'] == true).length;
    final pending = total - completed;
    return {'total': total, 'completed': completed, 'pending': pending};
  }

  void _showEditNameDialog() {
    final editController = TextEditingController(text: _nameController.text);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Set Your Name',
            style: TextStyle(
              color: Color(0xFF004D40),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            controller: editController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              filled: true,
              fillColor: const Color(0xFFE0F2F1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: Color(0xFF00897B),
                  width: 2,
                ),
              ),
              prefixIcon: const Icon(
                Icons.person_outline,
                color: Color(0xFF00897B),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF00695C)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00897B),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                setState(() {
                  _nameController.text = editController.text;
                });
                _saveProfile();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAvatarPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Choose Avatar',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(_avatarIcons.length, (index) {
                  final isSelected = _selectedAvatar == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedAvatar = index;
                      });
                      _saveProfile();
                      Navigator.pop(context);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00897B)
                            : const Color(0xFFB2F7EF),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFF004D40),
                                width: 3,
                              )
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: const Color(0xFF00897B)
                                      .withOpacity(0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        _avatarIcons[index],
                        size: 30,
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF004D40),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = _getStats();
    final name = _nameController.text.isEmpty ? 'Student' : _nameController.text;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: RefreshIndicator(
        color: const Color(0xFF00897B),
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ── Avatar & Name Card ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFB2F7EF),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _showAvatarPicker,
                    child: Stack(
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00897B),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00897B)
                                    .withOpacity(0.35),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            _avatarIcons[_selectedAvatar],
                            size: 44,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Color(0xFF00897B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF004D40),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Study Planner',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF00695C),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Stats Row ──
            Row(
              children: [
                _buildStatCard(
                  'Total',
                  '${stats['total']}',
                  Icons.assignment,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Done',
                  '${stats['completed']}',
                  Icons.check_circle_outline,
                ),
                const SizedBox(width: 12),
                _buildStatCard(
                  'Pending',
                  '${stats['pending']}',
                  Icons.pending_actions,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Settings Section ──
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildSettingsTile(
                    icon: Icons.person_outline,
                    title: 'Change Name',
                    subtitle: name,
                    onTap: _showEditNameDialog,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildSettingsTile(
                    icon: Icons.face,
                    title: 'Change Avatar',
                    subtitle: 'Tap to pick an icon',
                    onTap: _showAvatarPicker,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildSettingsTile(
                    icon: Icons.menu_book_outlined,
                    title: 'Manage Subjects',
                    subtitle: '${getSubjects().length} subjects',
                    onTap: _showManageSubjects,
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildSettingsTile(
                    icon: Icons.delete_sweep_outlined,
                    title: 'Clear All Tasks',
                    subtitle: 'Remove every task',
                    onTap: _confirmClearTasks,
                    isDestructive: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF00897B), size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004D40),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF00695C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive
              ? Colors.red.withOpacity(0.1)
              : const Color(0xFFE0F2F1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : const Color(0xFF00897B),
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : const Color(0xFF004D40),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 13,
          color: isDestructive
              ? Colors.red.withOpacity(0.7)
              : const Color(0xFF00695C),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: isDestructive ? Colors.red.withOpacity(0.5) : Colors.grey[400],
      ),
      onTap: onTap,
    );
  }

  void _confirmClearTasks() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Clear All Tasks?',
            style: TextStyle(
              color: Color(0xFF004D40),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'This will permanently delete all your tasks. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF00695C)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                tasksBox.delete('tasks');
                setState(() {});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('All tasks cleared')),
                );
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  void _showManageSubjects() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final subjectList = getSubjects();
            final addController = TextEditingController();

            void addSubject() {
              final name = addController.text.trim();
              if (name.isNotEmpty && !subjectList.contains(name)) {
                subjectList.add(name);
                saveSubjects(subjectList);
                addController.clear();
                setSheetState(() {});
                setState(() {}); // refresh profile tile subtitle
              }
            }

            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.4,
              maxChildSize: 0.85,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Column(
                    children: [
                      // ── Handle bar ──
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Manage Subjects',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Add Subject Field ──
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: addController,
                              textCapitalization: TextCapitalization.words,
                              decoration: InputDecoration(
                                hintText: 'New subject name',
                                filled: true,
                                fillColor: const Color(0xFFE0F2F1),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF00897B),
                                    width: 2,
                                  ),
                                ),
                                prefixIcon: const Icon(
                                  Icons.book_outlined,
                                  color: Color(0xFF00897B),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 0),
                              ),
                              onSubmitted: (_) => addSubject(),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Material(
                            color: const Color(0xFF00897B),
                            borderRadius: BorderRadius.circular(12),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: addSubject,
                              child: const SizedBox(
                                width: 48,
                                height: 48,
                                child: Icon(Icons.add, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ── Subject List ──
                      Expanded(
                        child: subjectList.isEmpty
                            ? const Center(
                                child: Text(
                                  'No subjects yet.\nAdd one above!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFF00695C),
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                itemCount: subjectList.length,
                                separatorBuilder: (_, _) =>
                                    const Divider(height: 1, indent: 48),
                                itemBuilder: (context, index) {
                                  final subject = subjectList[index];
                                  final isDefault =
                                      defaultSubjects.contains(subject);
                                  return Dismissible(
                                    key: ValueKey(subject),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (_) async {
                                      if (subjectList.length <= 1) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'You need at least one subject',
                                            ),
                                          ),
                                        );
                                        return false;
                                      }
                                      return true;
                                    },
                                    onDismissed: (_) {
                                      subjectList.removeAt(index);
                                      saveSubjects(subjectList);
                                      setSheetState(() {});
                                      setState(() {});
                                    },
                                    background: Container(
                                      alignment: Alignment.centerRight,
                                      padding:
                                          const EdgeInsets.only(right: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 2,
                                      ),
                                      leading: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFB2F7EF),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.menu_book,
                                          color: Color(0xFF00897B),
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        subject,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF004D40),
                                        ),
                                      ),
                                      subtitle: isDefault
                                          ? const Text(
                                              'Default',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF00695C),
                                              ),
                                            )
                                          : const Text(
                                              'Custom · swipe to delete',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF00695C),
                                              ),
                                            ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
