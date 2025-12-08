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

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
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
      child: Row(
        children: [
          // Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              doctor.imageUrl,
              height: 60,
              width: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 60,
                width: 60,
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                child: const Icon(Icons.person, size: 30, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Doctor Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.specialty,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
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
                    const SizedBox(width: 8),
                    Text(
                      '${doctor.experience} experience',
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
          // Book Button
          ElevatedButton(
            onPressed: () {
              // Show booking dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Book Appointment with ${doctor.name}'),
                  content: const Text('Select a date and time for your appointment.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Appointment booked with ${doctor.name}!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: const Text('Book Now'),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }
}