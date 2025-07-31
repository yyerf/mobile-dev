import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';
import '../models/pet.dart';

class AddEditReminderScreen extends StatefulWidget {
  final Reminder? reminder;
  final List<Pet> pets;
  final Function(Reminder) onSave;
  final VoidCallback? onDelete;

  const AddEditReminderScreen({
    super.key,
    this.reminder,
    required this.pets,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditReminderScreen> createState() => _AddEditReminderScreenState();
}

class _AddEditReminderScreenState extends State<AddEditReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  Pet? _selectedPet;
  ReminderType _selectedType = ReminderType.vet;
  DateTime _selectedDateTime = DateTime.now().add(const Duration(hours: 1));
  bool _isRepeating = false;
  int _repeatInterval = 30; // days

  bool get isEditing => widget.reminder != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _titleController.text = widget.reminder!.title;
      _descriptionController.text = widget.reminder!.description;
      _selectedType = widget.reminder!.type;
      _selectedDateTime = widget.reminder!.dateTime;
      _isRepeating = widget.reminder!.isRepeating;
      _repeatInterval = widget.reminder!.repeatInterval ?? 30;
      _selectedPet = widget.pets.where((pet) => pet.id == widget.reminder!.petId).isNotEmpty 
          ? widget.pets.where((pet) => pet.id == widget.reminder!.petId).first 
          : null;
    } else if (widget.pets.isNotEmpty) {
      _selectedPet = widget.pets.first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null && mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _saveReminder() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedPet == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a pet')),
      );
      return;
    }

    final reminder = Reminder(
      id: isEditing ? widget.reminder!.id : 0, // ID will be assigned by parent
      petId: _selectedPet!.id,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      type: _selectedType,
      dateTime: _selectedDateTime,
      isRepeating: _isRepeating,
      repeatInterval: _isRepeating ? _repeatInterval : null,
      isCompleted: isEditing ? widget.reminder!.isCompleted : false,
    );

    widget.onSave(reminder);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing ? 'Reminder updated successfully' : 'Reminder added successfully',
        ),
      ),
    );
  }

  void _deleteReminder() {
    if (!isEditing || widget.onDelete == null) return;

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reminder'),
        content: const Text('Are you sure you want to delete this reminder?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              widget.onDelete!();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reminder deleted successfully')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Reminder' : 'Add Reminder'),
        actions: [
          if (isEditing && widget.onDelete != null)
            IconButton(
              onPressed: _deleteReminder,
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Pet selection
            DropdownButtonFormField<Pet>(
              value: _selectedPet,
              decoration: const InputDecoration(
                labelText: 'Select Pet *',
                border: OutlineInputBorder(),
              ),
              items: widget.pets.map((pet) {
                return DropdownMenuItem(
                  value: pet,
                  child: Text('${pet.name} (${pet.species})'),
                );
              }).toList(),
              onChanged: (pet) {
                setState(() {
                  _selectedPet = pet;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a pet';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Reminder type
            DropdownButtonFormField<ReminderType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Reminder Type *',
                border: OutlineInputBorder(),
              ),
              items: ReminderType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(_getTypeDisplayName(type)),
                );
              }).toList(),
              onChanged: (type) {
                if (type != null) {
                  setState(() {
                    _selectedType = type;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Title field
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Date and time selection
            ListTile(
              title: const Text('Date & Time'),
              subtitle: Text(DateFormat('MMM dd, yyyy - hh:mm a').format(_selectedDateTime)),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selectDateTime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Colors.grey.shade400),
              ),
            ),
            const SizedBox(height: 16),

            // Repeating reminder
            SwitchListTile(
              title: const Text('Repeat Reminder'),
              subtitle: _isRepeating 
                  ? Text('Every $_repeatInterval days')
                  : const Text('One-time reminder'),
              value: _isRepeating,
              onChanged: (value) {
                setState(() {
                  _isRepeating = value;
                });
              },
            ),

            if (_isRepeating) ...[
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _repeatInterval.toString(),
                decoration: const InputDecoration(
                  labelText: 'Repeat every (days)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final interval = int.tryParse(value);
                  if (interval != null && interval > 0) {
                    _repeatInterval = interval;
                  }
                },
              ),
            ],

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _saveReminder,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isEditing ? 'Update Reminder' : 'Add Reminder',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeDisplayName(ReminderType type) {
    switch (type) {
      case ReminderType.vet:
        return 'Vet Appointment';
      case ReminderType.vaccination:
        return 'Vaccination';
      case ReminderType.feeding:
        return 'Feeding';
      case ReminderType.medication:
        return 'Medication';
      case ReminderType.grooming:
        return 'Grooming';
      case ReminderType.other:
        return 'Other';
    }
  }
}
