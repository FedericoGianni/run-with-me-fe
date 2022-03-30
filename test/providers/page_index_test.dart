import 'package:flutter_test/flutter_test.dart';
import 'package:runwithme/providers/page_index.dart';

void main() {
  PageIndex pageIndex = PageIndex();

  group('[PAGE INDEX]', () {
    test('pageIndex is set correctly', () {
      pageIndex.setPage(Screens.HOME.index);
      expect(pageIndex.index, Screens.HOME.index);

      pageIndex.setPage(Screens.SEARCH.index);
      expect(pageIndex.index, Screens.SEARCH.index);

      pageIndex.setPage(Screens.NEW.index);
      expect(pageIndex.index, Screens.NEW.index);

      pageIndex.setPage(Screens.EVENTS.index);
      expect(pageIndex.index, Screens.EVENTS.index);

      pageIndex.setPage(Screens.USER.index);
      expect(pageIndex.index, Screens.USER.index);
    });
  });
}
