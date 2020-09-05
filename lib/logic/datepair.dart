
class DatePair {

  final DateTime startDate;
  DateTime endDate;

  DatePair (this.startDate, { Duration duration }) {
    if (duration == null) {
      duration = Duration(days: 30);
    }
    this.endDate = this.startDate.add(duration);
  }

}

class DatePairGenerator {

  final DateTime startDate;

  final List<DatePair> datePairs = [];

  Duration durationBetweenPairs;

  DatePairGenerator (this.startDate, { this.durationBetweenPairs });

  DatePair next({ DateTime targetedDate }) {
    if (targetedDate != null) {
      if (targetedDate.millisecondsSinceEpoch < startDate.millisecondsSinceEpoch) {
        return null;
      } else {
        bool alreadyExists = datePairs.where((datePair) {
          return (targetedDate.millisecondsSinceEpoch >= datePair.startDate.millisecondsSinceEpoch
              && targetedDate.millisecondsSinceEpoch <= datePair.endDate.millisecondsSinceEpoch);
        }).toList().length > 0;
        if (alreadyExists)
          return null;
      }
    }
    DateTime start = startDate;
    if (datePairs.length > 0) {
      start = datePairs.last.endDate;
    }
    DatePair datePair = DatePair(start, duration: durationBetweenPairs);
    datePairs.add(datePair);
    return datePair;
  }

}