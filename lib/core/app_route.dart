import 'package:nasa/screens/finish_level_screen.dart';
import 'package:nasa/screens/game_screen.dart';
import 'package:nasa/screens/home/home.dart';
import 'package:nasa/screens/levels_screen.dart';
import 'package:nasa/screens/multiplayer_search_screen.dart';
import 'package:nasa/screens/offline_game_screen.dart';
import 'package:nasa/screens/offline_multiplayer_result_screen.dart';
import 'package:nasa/screens/offline_multiplayer_screen.dart';
import 'package:nasa/screens/online_finish_screen.dart';
import 'package:nasa/screens/settings/settings_screen.dart';
import 'package:nasa/screens/signin_screen.dart';
import 'package:nasa/screens/signup_screen.dart';
import 'package:nasa/screens/leaderboard_screen.dart';
import '../screens/welcome_screen.dart';

class AppRoute {
  const AppRoute._();

  static const home = '/home';
  static const signin = '/signin';
  static const signup = '/signup';
  static const welcome = '/welcome';
  static const leaderboard = '/leaderboard';
  static const multiplayerSearch = '/multiplayer-search';
  static const game = '/game';
  static const levels = '/levels';
  static const offlineGame = '/offline-game';
  static const finishLevel = '/finish-Level';
  static const onlineFinish = '/online-finish';
  static const settings = '/settings';
  static const offlineMultiplayer = '/offline_multiplayer';
  static const offlineMultiplayerResult = '/offline-multiplayer-resutl';

  static final routes = {
    home: (context) => const Home(),
    leaderboard: (context) => const LeaderboardScreen(),
    multiplayerSearch: (context) => const MultiplayerSearchScreen(),
    game: (context) => const GameScreen(),
    offlineGame: (context) => const OfflineGameScreen(),
    levels: (context) => const LevelsScreen(),
    finishLevel: (context) => const FinishLevelScreen(),
    welcome: (context) => const WelcomeScreen(),
    signin: (context) => const SigninScreen(),
    signup: (context) => const SignupScreen(),
    onlineFinish: (context) => const OnlineFinishScreen(),
    settings: (context) => const SettingsScreen(),
    offlineMultiplayer: (context) => const OfflineMultiplayerScreen(),
    offlineMultiplayerResult: (context) =>
        const OfflineMultiplayerResultScreen(),
  };
}
