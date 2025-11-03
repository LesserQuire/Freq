import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const DetailsPage({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final from = extra?['from'] ?? '';
    final isFromSearch = from == 'search';
    final isFromHome = from == 'home';
    final isSponsored = extra?['sponsored'] == true;

    const stationName = 'Freq Radio';
    const stationDescription =
        'Streaming the best curated music, talk, and live shows 24/7. '
        'Join our listeners worldwide and chat with other fans!';
    const followers = 12800;
    const listeners = 512;
    const category = 'Music • Talk • Live';

    String buttonLabel;
    VoidCallback onPressedAction;
    Color buttonColor;

    if (isFromSearch) {
      buttonLabel = 'Add';
      onPressedAction = () => context.pop();
      buttonColor = Theme.of(context).colorScheme.primary;
    } else if (isFromHome && isSponsored) {
      buttonLabel = 'Subscribe to Remove';
      onPressedAction = () => context.push('/account');
      buttonColor = Colors.amber.shade700;
    } else {
      buttonLabel = 'Remove';
      onPressedAction = () => context.pop();
      buttonColor = Colors.redAccent;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$stationName Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/images/station_banner.png',
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.radio, size: 64, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            stationName,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            category,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 16),
          Text(stationDescription, style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(Icons.people, '$followers followers'),
              _buildStat(Icons.headphones, '$listeners listening'),
            ],
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.push('/chat'),
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.white),
            label: const Text('Enter Chatroom',
                style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              minimumSize: const Size.fromHeight(50),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPressedAction,
            icon: Icon(
              isFromSearch
                  ? Icons.add
                  : isSponsored
                      ? Icons.star
                      : Icons.remove,
              color: Colors.white,
            ),
            label: Text(buttonLabel,
                style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              minimumSize: const Size.fromHeight(50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
