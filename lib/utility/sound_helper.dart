import 'dart:html' as html;

class SoundHelper {
  static void playNotificationSound() {
    try {
      print("Sound System: Attempting to play assets/sounds/orderget.wav");
      final audio = html.AudioElement('assets/sounds/orderget.wav');
      audio.play();
      print("Sound System: Playback triggered successfully");
    } catch (e) {
      print("Sound System: Error playing sound: $e");
      print("Sound System Note: Browsers often require a user gesture (click) before playing sound.");
    }
  }
}
