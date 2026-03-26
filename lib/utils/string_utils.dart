class StringUtils {
  /// Calculate the Levenshtein distance between two strings.
  /// The Levenshtein distance is the minimum number of insertions, deletions, and substitutions
  /// needed to transform one string into another.
  static int levenshteinDistance(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    List<List<int>> matrix = List.generate(s.length + 1, (i) => List.filled(t.length + 1, 0));

    for (int i = 0; i <= s.length; i++) { matrix[i][0] = i; }
    for (int j = 0; j <= t.length; j++) { matrix[0][j] = j; }

    for (int i = 1; i <= s.length; i++) {
      for (int j = 1; j <= t.length; j++) {
        int cost = (s[i - 1] == t[j - 1]) ? 0 : 1;
        matrix[i][j] = [
          matrix[i - 1][j] + 1, // Deletion
          matrix[i][j - 1] + 1, // Insertion
          matrix[i - 1][j - 1] + cost // Substitution
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[s.length][t.length];
  }
} 