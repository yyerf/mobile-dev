import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart'; // Add `intl: ^0.19.0` to your pubspec.yaml

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet\'s Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1a1a1a),
        fontFamily: 'Inter', // Make sure to add Inter font to your project
      ),
      home: const PetGalleryLockScreen(),
    );
  }
}

class PetGalleryLockScreen extends StatefulWidget {
  const PetGalleryLockScreen({super.key});

  @override
  State<PetGalleryLockScreen> createState() => _PetGalleryLockScreenState();
}

class _PetGalleryLockScreenState extends State<PetGalleryLockScreen> {
  late String _timeString;

  final List<String> _imagePaths = [
    'assets/images/pet_1.jpg',
    'assets/images/pet_2.jpg',
    'assets/images/pet_3.jpg',
    'assets/images/pet_4.jpg',
    'assets/images/pet_5.jpg',
    'assets/images/pet_6.jpg',
    'assets/images/pet_7.jpg',
    'assets/images/pet_8.jpg',
    'assets/images/pet_9.jpg',
    'assets/images/pet_10.jpg',
    'assets/images/pet_11.jpg',
    'assets/images/pet_12.jpg',
  ];


  @override
  void initState() {
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    // Update the time every second
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    if (mounted) {
      setState(() {
        _timeString = formattedDateTime;
      });
    }
  }

  String _formatDateTime(DateTime dateTime) {
    // Formats the time to a 12-hour format with AM/PM (e.g., 11:34 AM)
    return DateFormat('h:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // These are the target dimensions. We'll use them to calculate aspect ratio.
    const double targetWidth = 900;
    const double targetHeight = 1600;
    const double aspectRatio = targetWidth / targetHeight;

    return Scaffold(
      body: Center(
        // AspectRatio widget forces its child to conform to a specific aspect ratio.
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            // This container simulates the phone's body
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40.0),
              border: Border.all(color: const Color(0xFF333333), width: 8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.1),
                  blurRadius: 40.0,
                  spreadRadius: 0.0,
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias, // Clips the content to the rounded corners
            child: Column(
              children: [
                // 1. Status Bar
                _buildStatusBar(),

                // 2. Header
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0), // Reduced padding
                  child: Text(
                    "Pet's Gallery",
                    style: TextStyle(
                      fontSize: 40.0, // Reduced font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),

                // 3. Image Grid
                Expanded(
                  child: _buildImageGrid(),
                ),

                // 4. Footer
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the top status bar with time and icons.
  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _timeString,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
            ),
          ),
          const Row(
            children: [
              Icon(Icons.wifi, color: Colors.white, size: 24.0),
              SizedBox(width: 8),
              Icon(Icons.signal_cellular_alt, color: Colors.white, size: 24.0),
              SizedBox(width: 8),
              Icon(Icons.battery_full, color: Colors.white, size: 24.0),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the main 3x4 grid of images.
  Widget _buildImageGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      // GridView.builder is efficient for creating grids.
      child: GridView.builder(
        // Prevents the GridView from scrolling.
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 3 columns
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: 12, // 12 items for a 3x4 grid
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            // Using Image.asset to load local images.
            child: Image.asset(
              _imagePaths[index],
              fit: BoxFit.cover,
              // Shows an error icon if the image fails to load.
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: const Color(0xFF333333),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red),
                      SizedBox(height: 4),
                      Text("Not Found", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// Builds the semi-transparent footer.
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
      decoration: BoxDecoration(
        // Semi-transparent background for a "frosted glass" effect
        color: Colors.black.withOpacity(0.4),
      ),
      child: const Text(
        'Geoffrey Diapz and Kurt Vince Lopena',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16.0,
          color: Color(0xFFd0d0d0), // Slightly brighter for better contrast
        ),
      ),
    );
  }
}
