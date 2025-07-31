import 'package:flutter/material.dart';
import '../models/pet.dart';

class AddEditPetScreen extends StatefulWidget {
  final Pet? pet;
  final Function(Pet) onSave;
  final VoidCallback? onDelete;

  const AddEditPetScreen({
    super.key,
    this.pet,
    required this.onSave,
    this.onDelete,
  });

  @override
  State<AddEditPetScreen> createState() => _AddEditPetScreenState();
}

class _AddEditPetScreenState extends State<AddEditPetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _speciesController = TextEditingController();
  final _breedController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();

  bool get isEditing => widget.pet != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      _nameController.text = widget.pet!.name;
      _speciesController.text = widget.pet!.species;
      _breedController.text = widget.pet!.breed;
      _ageController.text = widget.pet!.age.toString();
      _weightController.text = widget.pet!.weight.toString();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _speciesController.dispose();
    _breedController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _savePet() {
    if (!_formKey.currentState!.validate()) return;

    final pet = Pet(
      id: isEditing ? widget.pet!.id : 0, // ID will be assigned by parent
      name: _nameController.text.trim(),
      species: _speciesController.text.trim(),
      breed: _breedController.text.trim(),
      age: int.parse(_ageController.text),
      weight: double.parse(_weightController.text),
    );

    widget.onSave(pet);
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing ? 'Pet updated successfully' : 'Pet added successfully',
        ),
      ),
    );
  }

  void _deletePet() {
    if (!isEditing || widget.onDelete == null) return;

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Pet'),
        content: const Text('Are you sure you want to delete this pet? This action cannot be undone.'),
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
                const SnackBar(content: Text('Pet deleted successfully')),
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
        title: Text(isEditing ? 'Edit Pet' : 'Add Pet'),
        actions: [
          if (isEditing)
            IconButton(
              onPressed: _deletePet,
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
            // Photo placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.pets, size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Photo placeholder', style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Pet Name *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Species field
            TextFormField(
              controller: _speciesController,
              decoration: const InputDecoration(
                labelText: 'Species *',
                hintText: 'e.g., Dog, Cat, Bird',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the species';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Breed field
            TextFormField(
              controller: _breedController,
              decoration: const InputDecoration(
                labelText: 'Breed *',
                hintText: 'e.g., Golden Retriever, Persian',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter the breed';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                // Age field
                Expanded(
                  child: TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age (years) *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter age';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age < 0) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),

                // Weight field
                Expanded(
                  child: TextFormField(
                    controller: _weightController,
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg) *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter weight';
                      }
                      final weight = double.tryParse(value);
                      if (weight == null || weight <= 0) {
                        return 'Please enter a valid weight';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _savePet,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                isEditing ? 'Update Pet' : 'Add Pet',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
