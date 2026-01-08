import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'onboarding_controller.dart';
import 'user_provider.dart';

/// A multi-page onboarding screen that collects user information and goals.
///
/// This screen guides the user through a series of questions to personalize
/// their experience, including name, habits, and energy levels. It uses
/// [OnboardingController] to save the collected data.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  final TextEditingController _nameController = TextEditingController();
  int _currentPage = 0;

  // Data collection
  String _selectedReason = '';
  String _selectedEnergy = '';
  String _selectedTrouble = '';
  String _selectedGoal = '';

  @override
  Widget build(BuildContext context) {
    ref.listen(onboardingControllerProvider, (prev, next) {
      if (!next.isLoading && !next.hasError && next.hasValue) {
        ref.read(userProvider.notifier).refresh();
        context.go('/');
      }
      if (next.hasError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${next.error}')));
      }
    });

    final isLoading = ref.watch(onboardingControllerProvider).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // 2. Gradient Overlay for readability
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(
                      0xFFE55D87,
                    ).withValues(alpha: 0.3), // Soft Pink tint
                    const Color(
                      0xFF5FC3E4,
                    ).withValues(alpha: 0.1), // Soft Blue tint
                  ],
                ),
              ),
            ),
          ),
          // 3. Content
          SafeArea(
            child: Column(
              children: [
                // Progress Indicator
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) =>
                        setState(() => _currentPage = page),
                    children: [
                      // Page 0: Intro / Name
                      _buildQuestionPage(
                        question:
                            'Let\'s start your journey.\nWhat should we call you?',
                        child: _buildNameInput(),
                      ),
                      // Page 1: Why habits?
                      _buildQuestionPage(
                        question:
                            'Why are you embarking on this journey to build healthy habits?',
                        child: _buildOptionsList(
                          options: [
                            'To feel better about myself',
                            'To improve my health',
                            'To set and achieve goals',
                            'To be more like someone who I admire',
                          ],
                          selected: _selectedReason,
                          onSelect: (val) {
                            setState(() => _selectedReason = val);
                            _nextPage();
                          },
                        ),
                      ),
                      // Page 2: Energy Levels
                      _buildQuestionPage(
                        question:
                            'Throughout your day, how are your energy levels?',
                        child: _buildOptionsList(
                          options: [
                            'High - energized throughout the day',
                            'Medium - I have bursts of energy',
                            'Low - my energy fades throughout the day',
                          ],
                          selected: _selectedEnergy,
                          onSelect: (val) {
                            setState(() => _selectedEnergy = val);
                            _nextPage();
                          },
                        ),
                      ),
                      // Page 3: Troubles
                      _buildQuestionPage(
                        question:
                            'Which of the habits below most troubles you?',
                        child: _buildOptionsList(
                          options: [
                            'Social Media',
                            'Negative Self-Talk',
                            'Disorganization',
                            'Procrastination',
                          ],
                          selected: _selectedTrouble,
                          onSelect: (val) {
                            setState(() => _selectedTrouble = val);
                            _nextPage();
                          },
                        ),
                      ),
                      // Page 4: Main Goal (Final)
                      _buildQuestionPage(
                        question:
                            'What single change would improve your life right now?',
                        child: _buildOptionsList(
                          options: [
                            'More energy',
                            'More productivity',
                            'More mindfulness',
                            'More sleep',
                          ],
                          selected: _selectedGoal,
                          onSelect: (val) {
                            setState(() => _selectedGoal = val);
                            // Finish
                            _completeOnboarding();
                          },
                          isLoading: isLoading,
                        ),
                      ),
                    ],
                  ),
                ),
                // Artist / Character Illustration placeholder space at bottom if needed
                // Based on image, character is at bottom.
                // We'll leave space or add a placeholder image if available.
                const SizedBox(height: 50),
              ],
            ),
          ),
          // Back Button
          if (_currentPage > 0)
            Positioned(
              top: 50,
              left: 16,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Completes the onboarding process.
  ///
  /// This method validates the input and then calls the [OnboardingController]
  /// to save the user's profile data.
  void _completeOnboarding() {
    if (_nameController.text.isEmpty) {
      // Should rely on validation before getting here, but safe fallback
      setState(() => _currentPage = 0);
      return;
    }

    ref
        .read(onboardingControllerProvider.notifier)
        .completeOnboarding(
          name: _nameController.text,
          wakeTime: const TimeOfDay(
            hour: 7,
            minute: 0,
          ), // Defaulting for now as UI changed
          mood:
              _selectedEnergy, // Mapping Energy to Mood for backend compatibility
          primaryGoal: _selectedGoal,
        );
  }

  Widget _buildQuestionPage({required String question, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.2,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          child,
        ],
      ),
    );
  }

  Widget _buildNameInput() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _nameController,
            style: const TextStyle(fontSize: 18, color: Color(0xFF2D3142)),
            decoration: const InputDecoration(
              hintText: 'Your Name',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty) {
                _nextPage();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF6B4EFF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Continue',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsList({
    required List<String> options,
    required String selected,
    required Function(String) onSelect,
    bool isLoading = false,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Column(
      children: options.map((option) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => onSelect(option),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 24,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A4E69), // Dark pastel blue-grey
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
