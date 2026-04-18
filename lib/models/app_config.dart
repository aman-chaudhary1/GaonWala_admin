class AppConfig {
  bool? isOrderingEnabled;
  String? welcomeMessage;
  String? orderBlockedMessage;
  bool? showWelcomePopup;
  bool? reviewEnabled;

  AppConfig({
    this.isOrderingEnabled,
    this.welcomeMessage,
    this.orderBlockedMessage,
    this.showWelcomePopup,
    this.reviewEnabled,
  });

  AppConfig.fromJson(Map<String, dynamic> json) {
    isOrderingEnabled = json['isOrderingEnabled'];
    welcomeMessage = json['welcomeMessage'];
    orderBlockedMessage = json['orderBlockedMessage'];
    showWelcomePopup = json['showWelcomePopup'];
    reviewEnabled = json['reviewEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isOrderingEnabled'] = this.isOrderingEnabled;
    data['welcomeMessage'] = this.welcomeMessage;
    data['orderBlockedMessage'] = this.orderBlockedMessage;
    data['showWelcomePopup'] = this.showWelcomePopup;
    data['reviewEnabled'] = this.reviewEnabled;
    return data;
  }
}
