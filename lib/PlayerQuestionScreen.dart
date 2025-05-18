import 'package:flutter/material.dart';
import 'package:game/game_data.dart';

class PlayerQuestionsScreen extends StatefulWidget {
  final String teamName;
  final int playerIndex;

  const PlayerQuestionsScreen({
    super.key,
    required this.teamName,
    required this.playerIndex,
  });

  @override
  State<PlayerQuestionsScreen> createState() => _PlayerQuestionsScreenState();
}

class _PlayerQuestionsScreenState extends State<PlayerQuestionsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController famousPersonController = TextEditingController();
  final TextEditingController filmController = TextEditingController();
  final TextEditingController songController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController foodController = TextEditingController();
  final TextEditingController proverbController = TextEditingController();
  
  // Cache for duplicate check to avoid repeated calculations
  final Set<String> _existingWords = {};
  bool _isInitialized = false;
  
  // Animation controller
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Category mapping
  final List<String> categories = [
    'Famous Person',
    'Film',
    'Song',
    'Place in Egypt',
    'Food',
    'Popular proverb'
  ];
  
  final List<String> arabicLabels = [
    "اسم شخصية عامة",
    "فيلم",
    "أغنية",
    "مكان في مصر",
    "طعام",
    "مثل شعبي"
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    
    // Start the animation
    _animationController.forward();
    
    // Load existing words for duplicate checking
    _loadExistingWords();
    
    _isInitialized = true;
  }
  
  void _loadExistingWords() {
    // Clear existing cache
    _existingWords.clear();
    
    // Collect all words from all categories
    for (var category in GameData.wordsByCategory.keys) {
      _existingWords.addAll(GameData.wordsByCategory[category] ?? []);
    }
  }

  @override
  void dispose() {
    // Dispose text controllers to prevent memory leaks
    famousPersonController.dispose();
    filmController.dispose();
    songController.dispose();
    placeController.dispose();
    foodController.dispose();
    proverbController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  bool _isWordDuplicate(String word) {
    // Skip empty answers
    if (word.trim().isEmpty) return false;
    
    // Check against cached words for better performance
    return _existingWords.contains(word);
  }

  void _saveAnswers() {
    // Get all answers with their categories
    final answers = [
      {'category': categories[0], 'word': famousPersonController.text.trim()},
      {'category': categories[1], 'word': filmController.text.trim()},
      {'category': categories[2], 'word': songController.text.trim()},
      {'category': categories[3], 'word': placeController.text.trim()},
      {'category': categories[4], 'word': foodController.text.trim()},
      {'category': categories[5], 'word': proverbController.text.trim()},
    ];

    // Check for empty answers
    if (answers.any((answer) => answer['word']!.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all answers"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // Check for duplicates
    for (var answer in answers) {
      if (_isWordDuplicate(answer['word']!)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("'${answer['word']}' is already used! Please choose a different word."),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }
    }

    // Save words to their categories
    for (var answer in answers) {
      GameData.addWord(answer['category']!, answer['word']!);
    }

    // Add a smooth exit animation before popping
    _animationController.reverse().then((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Very small app bar
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Remove default back button
          flexibleSpace: Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                // Add smooth exit animation before popping
                _animationController.reverse().then((_) {
                  Navigator.pop(context);
                });
              },
            ),
          ),
        ),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/b4.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: _isInitialized 
            ? _buildContent(screenWidth, screenHeight)
            : const Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      ),
    );
  }
  
  Widget _buildContent(double screenWidth, double screenHeight) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Use RepaintBoundary for complex widgets that don't change often
                RepaintBoundary(
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [Colors.cyan, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds);
                    },
                    child: Text(
                      "Mix Grill",
                      style: TextStyle(
                        fontSize: screenWidth * 0.12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Hero widget for the player icon
                    Hero(
                      tag: 'player-icon-${widget.teamName}-${widget.playerIndex - 1}',
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 8),
                    // Hero widget for the player text
                    Hero(
                      tag: 'player-text-${widget.teamName}-${widget.playerIndex - 1}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          "${widget.teamName} - Player ${widget.playerIndex}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.03),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "لو الكلمة بالعربى تكتبها بالعربى و لو بالانجليزى تكتبها انجليزى ممنوع فرانكو عشان لو كلمة متكررة نقدر نعرفها و نبدلها",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Roboto',
                      shadows: [
                        Shadow(
                          blurRadius: 2.0,
                          color: Colors.black54,
                          offset: Offset(1.0, 1.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                
                // Category input fields
                _buildCategoryField(
                  arabicLabels[0], 
                  categories[0], 
                  famousPersonController, 
                  screenWidth,
                  Icons.person
                ),
                SizedBox(height: screenHeight * 0.02),
                
                _buildCategoryField(
                  arabicLabels[1], 
                  categories[1], 
                  filmController, 
                  screenWidth,
                  Icons.movie
                ),
                SizedBox(height: screenHeight * 0.02),
                
                _buildCategoryField(
                  arabicLabels[2], 
                  categories[2], 
                  songController, 
                  screenWidth,
                  Icons.music_note
                ),
                SizedBox(height: screenHeight * 0.02),
                
                _buildCategoryField(
                  arabicLabels[3], 
                  categories[3], 
                  placeController, 
                  screenWidth,
                  Icons.place
                ),
                SizedBox(height: screenHeight * 0.02),
                
                _buildCategoryField(
                  arabicLabels[4], 
                  categories[4], 
                  foodController, 
                  screenWidth,
                  Icons.fastfood
                ),
                SizedBox(height: screenHeight * 0.02),
                
                _buildCategoryField(
                  arabicLabels[5], 
                  categories[5], 
                  proverbController, 
                  screenWidth,
                  Icons.format_quote
                ),
                
                SizedBox(height: screenHeight * 0.05),
                
                // Submit button with optimized styling
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAnswers,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Submit and Next Player",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryField(
      String label, 
      String category, 
      TextEditingController controller, 
      double screenWidth,
      IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 8),
              Text(
                category,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: label,
              filled: true,
              fillColor: const Color(0xFF070C1F),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(
                color: Colors.white70, 
                fontSize: 14,
              ),
            ),
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
