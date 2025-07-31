import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/reminder.dart';

class ReminderCard extends StatelessWidget {
  final Reminder reminder;
  final String petName;
  final VoidCallback? onTap;
  final VoidCallback? onComplete;

  const ReminderCard({
    super.key,
    required this.reminder,
    required this.petName,
    this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isUpcoming = reminder.dateTime.isAfter(DateTime.now());
    final isOverdue = reminder.dateTime.isBefore(DateTime.now()) && !reminder.isCompleted;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Type icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTypeColor(reminder.type).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getTypeIcon(reminder.type),
                      color: _getTypeColor(reminder.type),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Title and type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            decoration: reminder.isCompleted 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                        ),
                        Text(
                          reminder.typeDisplayName,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: _getTypeColor(reminder.type),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Complete button (only for upcoming reminders)
                  if (!reminder.isCompleted && onComplete != null)
                    IconButton(
                      onPressed: onComplete,
                      icon: const Icon(Icons.check_circle_outline),
                      color: Colors.green,
                    ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Pet name
              Row(
                children: [
                  Icon(
                    Icons.pets,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    petName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Date and time
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                    color: isOverdue ? Colors.red : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('MMM dd, yyyy - hh:mm a').format(reminder.dateTime),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isOverdue ? Colors.red : Colors.grey[600],
                      fontWeight: isOverdue ? FontWeight.w500 : null,
                    ),
                  ),
                  if (isOverdue) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'OVERDUE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              
              // Description (if available)
              if (reminder.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  reminder.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              
              // Repeating indicator
              if (reminder.isRepeating) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.repeat,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Repeats every ${reminder.repeatInterval} days',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getTypeIcon(ReminderType type) {
    switch (type) {
      case ReminderType.vet:
        return Icons.medical_services;
      case ReminderType.vaccination:
        return Icons.vaccines;
      case ReminderType.feeding:
        return Icons.restaurant;
      case ReminderType.medication:
        return Icons.medication;
      case ReminderType.grooming:
        return Icons.content_cut;
      case ReminderType.other:
        return Icons.event_note;
    }
  }

  Color _getTypeColor(ReminderType type) {
    switch (type) {
      case ReminderType.vet:
        return Colors.blue;
      case ReminderType.vaccination:
        return Colors.green;
      case ReminderType.feeding:
        return Colors.orange;
      case ReminderType.medication:
        return Colors.red;
      case ReminderType.grooming:
        return Colors.purple;
      case ReminderType.other:
        return Colors.grey;
    }
  }
}
