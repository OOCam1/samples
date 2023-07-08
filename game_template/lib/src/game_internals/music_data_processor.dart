

class MusicDataProcessor {

  static final MusicDataProcessor _instance = MusicDataProcessor._internal();

  MusicDataProcessor._internal();
  factory MusicDataProcessor() {return _instance;}

  //calculates dtanh(ax + b) + c given two input x's and results. Outputs value between 0 and maxResult
  // static _convertLinearScoreToHeight(double score, double firstLinear, double firstResult, double secondLinear, double secondResult, double maxResult) {
  //   //c = -tanhb
  //   //b = tanh-1(1-max/d)
  //
  // }
}