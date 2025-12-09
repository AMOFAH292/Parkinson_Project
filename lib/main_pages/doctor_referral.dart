import 'package:flutter/material.dart';

// Doctor model
class Doctor {
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;
  final String experience;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
    required this.experience,
  });
}

class DoctorReferralScreen extends StatelessWidget {
  const DoctorReferralScreen({super.key});

  // Mock data for doctors
  static const List<Doctor> doctors = [
    Doctor(
      name: 'Dr. Sarah Johnson',
      specialty: 'Neurologist',
      rating: 4.8,
      imageUrl: 'assets/images/doctor1.jpeg',
      experience: '15 years',
    ),
    Doctor(
      name: 'Dr. Michael Chen',
      specialty: 'Movement Disorder Specialist',
      rating: 4.9,
      imageUrl: 'assets/images/doctor2.jpg',
      experience: '12 years',
    ),
    Doctor(
      name: 'Dr. Emily Rodriguez',
      specialty: 'Parkinson\'s Disease Specialist',
      rating: 4.7,
      imageUrl: 'assets/images/doctor3.jpg',
      experience: '10 years',
    ),
    Doctor(
      name: 'Dr. David Kim',
      specialty: 'Neurologist',
      rating: 4.6,
      imageUrl: 'assets/images/doctor4.webp',
      experience: '18 years',
    ),
    Doctor(
      name: 'Dr. Lisa Thompson',
      specialty: 'Geriatric Neurologist',
      rating: 4.5,
      imageUrl: 'assets/images/doctor5.jpg',
      experience: '14 years',
    ),
    Doctor(
      name: 'Dr. Robert Martinez',
      specialty: 'Clinical Neurophysiologist',
      rating: 4.7,
      imageUrl: 'assets/images/doctor6.jpg',
      experience: '16 years',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Doctor Referrals',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 0.6,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: DoctorCard(doctor: doctors[index]),
          );
        },
      ),
    );
  }
}

class BookingBottomSheet extends StatefulWidget {
  final Doctor doctor;

  const BookingBottomSheet({super.key, required this.doctor});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet> {
  String? selectedTimeSlot;

  final List<String> availableSlots = [
    'Today, 10:00 AM',
    'Today, 2:00 PM',
    'Tomorrow, 9:00 AM',
    'Tomorrow, 3:00 PM',
    'Friday, 11:00 AM',
    'Friday, 4:00 PM',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  widget.doctor.imageUrl,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 50,
                    width: 50,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(Icons.person, size: 25, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      widget.doctor.specialty,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.doctor.rating} • ${widget.doctor.experience} experience',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Available Time Slots',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          // Time slots
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableSlots.map((slot) {
              final isSelected = selectedTimeSlot == slot;
              return ChoiceChip(
                label: Text(slot),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    selectedTimeSlot = selected ? slot : null;
                  });
                },
                selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                backgroundColor: Colors.grey.shade100,
                labelStyle: TextStyle(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.black,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          // Book button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedTimeSlot != null
                  ? () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Appointment booked with ${widget.doctor.name} at $selectedTimeSlot!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with profile pic and name
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                // Profile Picture
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    doctor.imageUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 40,
                      width: 40,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, size: 20, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Name and specialty
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctor.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        doctor.specialty,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      '${doctor.rating}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Main Image
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: Image.asset(
              doctor.imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 200,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.person, size: 50, color: Colors.grey),
              ),
            ),
          ),
          // Reactions and actions
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reaction buttons
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.favorite_border, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.comment_outlined, color: Colors.black),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.share_outlined, color: Colors.black),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.bookmark_border, color: Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
                // Description
                Text(
                  '${doctor.name} is a board-certified ${doctor.specialty.toLowerCase()} with ${doctor.experience} of experience in neurological care. Schedule your appointment to receive personalized treatment.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                // Book Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Show booking bottom sheet
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) => BookingBottomSheet(doctor: doctor),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Book Appointment'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}