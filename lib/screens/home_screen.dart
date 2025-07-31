import 'package:flutter/material.dart';
import '../models/pet.dart';
import '../models/reminder.dart';
import '../widgets/pet_card.dart';
import '../widgets/reminder_card.dart';
import 'add_edit_pet_screen.dart';
import 'add_edit_reminder_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<Pet> _pets = [];
  List<Reminder> _reminders = [];
  int _nextPetId = 1;
  int _nextReminderId = 1;

  @override
  void initState() {
    super.initState();
    _loadSampleData();
  }

  void _loadSampleData() {
    // Add some sample pets for demonstration
    _pets = [
      Pet(
        id: _nextPetId++,
        name: 'Maxxi',
        species: 'Dog',
        breed: 'Golden Retriever',
        age: 3,
        weight: 25.5,
      ),
      Pet(
        id: _nextPetId++,
        name: 'Mittens',
        species: 'Cat',
        breed: 'Persian',
        age: 2,
        weight: 4.2,
      ),
    ];

    // Add sample reminders
    _reminders = [
      Reminder(
        id: _nextReminderId++,
        petId: 1,
        title: 'Vet Checkup',
        description: 'Annual health checkup',
        type: ReminderType.vet,
        dateTime: DateTime.now().add(const Duration(days: 3)),
      ),
      Reminder(
        id: _nextReminderId++,
        petId: 2,
        title: 'Vaccination',
        description: 'Rabies vaccination due',
        type: ReminderType.vaccination,
        dateTime: DateTime.now().add(const Duration(days: 7)),
      ),
    ];
  }

  void _addPet(Pet pet) {
    setState(() {
      final newPet = pet.copyWith(id: _nextPetId++);
      _pets.insert(0, newPet);
    });
  }

  void _updatePet(Pet updatedPet) {
    setState(() {
      final index = _pets.indexWhere((pet) => pet.id == updatedPet.id);
      if (index != -1) {
        _pets[index] = updatedPet;
      }
    });
  }

  void _deletePet(int petId) {
    setState(() {
      _pets.removeWhere((pet) => pet.id == petId);
      _reminders.removeWhere((reminder) => reminder.petId == petId);
    });
  }

  void _addReminder(Reminder reminder) {
    setState(() {
      final newReminder = reminder.copyWith(id: _nextReminderId++);
      _reminders.add(newReminder);
    });
  }

  void _updateReminder(Reminder updatedReminder) {
    setState(() {
      final index = _reminders.indexWhere((r) => r.id == updatedReminder.id);
      if (index != -1) {
        _reminders[index] = updatedReminder;
      }
    });
  }

  void _deleteReminder(int reminderId) {
    setState(() {
      _reminders.removeWhere((reminder) => reminder.id == reminderId);
    });
  }

  void _markReminderCompleted(int reminderId) {
    setState(() {
      final index = _reminders.indexWhere((r) => r.id == reminderId);
      if (index != -1) {
        _reminders[index] = _reminders[index].copyWith(isCompleted: true);
      }
    });
  }

  Pet? _getPetById(int id) {
    try {
      return _pets.firstWhere((pet) => pet.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildPetsTab(),
      _buildRemindersTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Care Reminder'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Pets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Reminders',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedIndex == 0) {
            // Add pet
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditPetScreen(
                  onSave: _addPet,
                ),
              ),
            );
          } else {
            // Add reminder
            if (_pets.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please add a pet first before creating reminders'),
                ),
              );
              return;
            }

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditReminderScreen(
                  pets: _pets,
                  onSave: _addReminder,
                ),
              ),
            );
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPetsTab() {
    if (_pets.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pets,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No pets added yet',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap the + button to add your first pet',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _pets.length,
      itemBuilder: (context, index) {
        final pet = _pets[index];
        return PetCard(
          pet: pet,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditPetScreen(
                  pet: pet,
                  onSave: _updatePet,
                  onDelete: () => _deletePet(pet.id),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    final upcomingReminders = _reminders
        .where((r) => r.dateTime.isAfter(DateTime.now()) && !r.isCompleted)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final completedReminders = _reminders
        .where((r) => r.isCompleted)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Upcoming'),
              Tab(text: 'Completed'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildRemindersList(upcomingReminders, true),
                _buildRemindersList(completedReminders, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRemindersList(List<Reminder> reminders, bool showCompleteButton) {
    if (reminders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              showCompleteButton ? Icons.notifications_none : Icons.check_circle_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              showCompleteButton ? 'No upcoming reminders' : 'No completed reminders',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reminders.length,
      itemBuilder: (context, index) {
        final reminder = reminders[index];
        final pet = _getPetById(reminder.petId);
        return ReminderCard(
          reminder: reminder,
          petName: pet?.name ?? 'Unknown Pet',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddEditReminderScreen(
                  reminder: reminder,
                  pets: _pets,
                  onSave: _updateReminder,
                  onDelete: () => _deleteReminder(reminder.id),
                ),
              ),
            );
          },
          onComplete: showCompleteButton
              ? () => _markReminderCompleted(reminder.id)
              : null,
        );
      },
    );
  }
}
