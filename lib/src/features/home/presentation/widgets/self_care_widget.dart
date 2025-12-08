import 'package:flutter/material.dart';

class SelfCareWidget extends StatelessWidget {
  const SelfCareWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD), // Light Blue
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Text(
            "SELF-CARE",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3142),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "FOR WHEN YOU DON'T HAVE\nTIME TO SPARE",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF546E7A),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.1,
            children: [
              _buildCareItem(
                Icons.sentiment_very_satisfied,
                "do something\nfun-for you!",
                const Color(0xFFFFCC80),
              ),
              _buildCareItem(
                Icons.phonelink_lock,
                "take a break\nfrom your devices",
                const Color(0xFF90CAF9),
              ),
              _buildCareItem(
                Icons.edit,
                "write down\nwhat you're\ngrateful for",
                const Color(0xFFFFF59D),
              ),
              _buildCareItem(
                Icons.music_note,
                "listen to\nsongs that\nuplift you",
                const Color(0xFFFFAB91),
              ),
              _buildCareItem(
                Icons.spa,
                "meditate\neven for just\n5 minutes",
                const Color(0xFF80DEEA),
              ),
              _buildCareItem(
                Icons.image,
                "spend time in nature\n(or look at\nlandscape photos!)",
                const Color(0xFFB39DDB),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCareItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF2D3142),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}
