class GameData {
  static List<String> teams = []; // Stores team names
  static Map<String, int> teamScores = {}; // Tracks scores for each team
  static Map<String, Map<int, List<String>>> answers = {}; // Stores answers by team and player

  // Used words for each round to prevent repetition
  static Set<String> usedWordsInRound1 = {};
  static Set<String> usedWordsInRound2 = {};
  static Set<String> usedWordsInRound3 = {};

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

  // Resets all game data (Clears everything for a new game)
  static void resetGame() {
    teams.clear();
    teamScores.clear();
    answers.clear();
    usedWordsInRound1.clear();
    usedWordsInRound2.clear();
    usedWordsInRound3.clear();
  }

  // Determines the winner at the end of the game
  static String getWinner() {
    if (teamScores.isEmpty) return "No teams available!";

    String winner = "";
    int highestScore = 0;

    teamScores.forEach((team, score) {
      if (score > highestScore) {
        highestScore = score;
        winner = team;
      }
    });

    return highestScore > 0 ? "🏆 Winner: $winner with $highestScore points!" : "No winner yet!";
  }
}
