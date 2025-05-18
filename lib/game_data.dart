import 'dart:math';

class GameData {
  static List<String> teams = []; // Stores team names
  static Map<String, int> teamScores = {}; // Tracks scores for each team
  
  // New data structure for storing words by category
  static Map<String, List<String>> wordsByCategory = {
    'Famous Person': [],
    'Film': [],
    'Song': [],
    'Place in Egypt': [],
    'Food': [],
    'Popular proverb': [],
  };
  
  // Used words for each round to prevent repetition
  static Set<String> usedWordsInRound1 = {};
  static Set<String> usedWordsInRound2 = {};
  static Set<String> usedWordsInRound3 = {};
  
  // Track skipped words per team per round
  static Map<String, Map<int, Set<String>>> skippedWords = {};

  // Initializes team scores at the start
  static void initializeScores() {
    for (String team in teams) {
      teamScores[team] = 0;
    }
  }

  // Increases the score for a team when they get a correct answer
  static void addScore(String teamName) {
    if (teamScores.containsKey(teamName)) {
      teamScores[teamName] = teamScores[teamName]! + 1;
    } else {
      teamScores[teamName] = 1;
    }
  }
  
  // Add a word to its appropriate category
  static void addWord(String category, String word) {
    if (wordsByCategory.containsKey(category)) {
      // Only add if not already in the list
      if (!wordsByCategory[category]!.contains(word)) {
        wordsByCategory[category]!.add(word);
      }
    }
  }
  
  // Check if a word has been used in a specific round or skipped by the current team
  static bool _isWordUsedInRound(String word, int roundNumber, [String? teamName]) {
    // First check if it's used in the current game's rounds
    bool isUsed = usedWordsInRound1.contains(word) || 
                  usedWordsInRound2.contains(word) || 
                  usedWordsInRound3.contains(word);
    
    // If team is specified, also check if this team skipped this word
    if (!isUsed && teamName != null && skippedWords.containsKey(teamName)) {
      return skippedWords[teamName]?[roundNumber]?.contains(word) ?? false;
    }
    
    return isUsed;
  }
  
  // Get a random word from a specific category that hasn't been used in the specified round
  static Map<String, String>? getRandomWord(int roundNumber, [String? teamName]) {
    // Combine all categories into one list
    List<String> allCategories = wordsByCategory.keys.toList();
    if (allCategories.isEmpty) return null;
    
    // Shuffle categories to get a random one
    allCategories.shuffle();
    
    // First try to find a word that hasn't been used by anyone
    for (String category in allCategories) {
      List<String> availableWords = wordsByCategory[category]!
          .where((word) => !_isWordUsedInRound(word, roundNumber, teamName))
          .toList();
      
      if (availableWords.isNotEmpty) {
        // Shuffle to get a random word
        availableWords.shuffle();
        String selectedWord = availableWords.first;
        
        // Mark as used in the appropriate round
        _markWordAsUsed(selectedWord, roundNumber);
        
        // Return both the word and its category
        return {
          'word': selectedWord,
          'category': category,
        };
      }
    }
    
    // If we're in the last round and no unused words are available,
    // try to use words that were skipped by other teams but not by this team
    if (roundNumber == 3) {
      for (String category in allCategories) {
        List<String> allWords = wordsByCategory[category]!;
        
        for (String word in allWords) {
          // Check if this word was skipped by other teams but not by this team
          bool skippedByOthers = false;
          bool skippedByThisTeam = false;
          
          for (String team in skippedWords.keys) {
            if (skippedWords[team]?[roundNumber]?.contains(word) ?? false) {
              if (team == teamName) {
                skippedByThisTeam = true;
              } else {
                skippedByOthers = true;
              }
            }
          }
          
          // If the word was skipped by others but not by this team, use it
          if (skippedByOthers && !skippedByThisTeam) {
            _markWordAsUsed(word, roundNumber);
            return {
              'word': word,
              'category': category,
            };
          }
        }
      }
    }
    
    return null; // No unused words available
  }
  
  // Add a word to the skipped words for a team in a specific round
  static void addSkippedWord(String teamName, int roundNumber, String word) {
    // Initialize the team's skipped words map if it doesn't exist
    skippedWords.putIfAbsent(teamName, () => {});
    
    // Initialize the round's skipped words set if it doesn't exist
    skippedWords[teamName]!.putIfAbsent(roundNumber, () => {});
    
    // Add the word to the skipped words set
    skippedWords[teamName]![roundNumber]!.add(word);
  }
  
  // Mark a word as used in a specific round
  static void _markWordAsUsed(String word, int roundNumber) {
    switch (roundNumber) {
      case 1:
        usedWordsInRound1.add(word);
        break;
      case 2:
        usedWordsInRound2.add(word);
        break;
      case 3:
        usedWordsInRound3.add(word);
        break;
    }
  }

  // Resets all game data (Clears everything for a new game)
  static void resetGame() {
    teams.clear();
    teamScores.clear();
    usedWordsInRound1.clear();
    usedWordsInRound2.clear();
    usedWordsInRound3.clear();
    skippedWords.clear(); // Add this line to clear skipped words
    // Don't clear wordsByCategory as we want to keep the word database
  }

  // Determines the winner at the end of the game
  static String getWinner() {
    if (teamScores.isEmpty) return "No teams available!";
    
    // Find the highest score
    int highestScore = teamScores.values.reduce((a, b) => a > b ? a : b);
    
    // Find all teams with the highest score
    List<String> teamsWithHighestScore = teamScores.entries
        .where((entry) => entry.value == highestScore)
        .map((entry) => entry.key)
        .toList();
    
    // If more than one team has the highest score, it's a draw
    if (teamsWithHighestScore.length > 1) {
      return "DRAW";
    }
    
    // Otherwise, return the winning team
    return teamsWithHighestScore.first;
  }
  
  // Helper method to convert answers from old format to new category-based format
  static void migrateAnswersToCategories(Map<String, Map<int, List<String>>> oldAnswers) {
    oldAnswers.forEach((team, playerMap) {
      playerMap.forEach((playerIndex, answers) {
        if (answers.length >= 4) {
          // Based on the index, add to appropriate category
          if (answers[0].isNotEmpty) addWord('Famous Person', answers[0]);
          if (answers[1].isNotEmpty) addWord('Film', answers[1]);
          if (answers[2].isNotEmpty) addWord('Song', answers[2]);
          if (answers[3].isNotEmpty) addWord('Place in Egypt', answers[3]);
        }
      });
    });
  }
  
  // Get a skipped word for a team in a specific round
  static Map<String, String>? getSkippedWord(String teamName, int roundNumber) {
    // Check if the team has any skipped words for this round
    if (skippedWords.containsKey(teamName) && 
        skippedWords[teamName]!.containsKey(roundNumber) && 
        skippedWords[teamName]![roundNumber]!.isNotEmpty) {
      
      // Get a random skipped word
      final skippedWordsSet = skippedWords[teamName]![roundNumber]!;
      final word = skippedWordsSet.elementAt(Random().nextInt(skippedWordsSet.length));
      
      // Find the category for this word
      String category = "Unknown Category";
      for (var entry in wordsByCategory.entries) {
        if (entry.value.contains(word)) {
          category = entry.key;
          break;
        }
      }
      
      // Remove the word from skipped words to avoid repetition
      skippedWordsSet.remove(word);
      
      
      return {
        'word': word,
        'category': category
      };
    }
    
    return null; // No skipped words available
  }
}
