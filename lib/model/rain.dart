class Rain {
  num oneh;

  Rain({
    this.oneh
  });

  factory Rain.fromJson(Map<String, dynamic> json) {
    return Rain(
      oneh: json['1h']
    );
  }
}