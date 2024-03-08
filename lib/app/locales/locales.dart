import 'package:get/get.dart';

class AppLocales extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        /// English translations
        'en_US': {
          'boozin_fitness': "Boozin Fitness",
          "hi": "Hi!",
          'authorize': 'Authorize',
          'steps': 'Steps',
          'calories_burned': 'Calories Burned',
          'error_fetching_data': "Error fetching data",
          'goal': 'Goal',
          'set_calories_goal': "Set Calories Goal",
          'set_steps_goal': "Set Steps Goal",
          'calories_goal': "Calories Goal",
          'steps_goal': "Steps Goal",
          'success': "Success",
          'goal_was_set_sccuessfully': "Goal was set succesfully.",
          'goal_was_not_set': "Got an error while setting the goal.",
          'save': "Save",
          'error': "Error",
          'error_in_auth': "Error in authorization.",
          'error_in_step': "Error in fetching step count.",
          'error_in_energy': "Error in fetching calories burnt.",
        },

        /// Hindi translations
        'hi_IN': {
          'boozin_fitness': "बूज़िंग फिटनेस",
          "hi": "नमस्ते!",
          'authorize': 'अनुमति दें',
          'steps': 'कदम',
          'calories_burned': 'कैलोरी खर्च',
          'error_fetching_data': "डाटा प्राप्त करने में एरर",
          'goal': 'लक्ष्य',
          'set_calories_goal': "कैलोरी लक्ष्य सेट करें",
          'set_steps_goal': "कदम लक्ष्य सेट करें",
          'calories_goal': "कैलोरी लक्ष्य",
          'steps_goal': "कदम लक्ष्य",
          'success': "सफलता",
          'goal_was_set_sccuessfully': "लक्ष्य सफलतापूर्वक सेट किया गया।",
          'goal_was_not_set': "लक्ष्य सेट करते समय त्रुटि हुई।",
          'save': "सहेजें",
          'error': "एरर",
          'error_in_auth': "अनुमति एरर।",
          'error_in_step': "कदम प्राप्त करने में एरर।",
          'error_in_energy': "कैलोरी प्राप्त करने में एरर।",
        }
      };
}
