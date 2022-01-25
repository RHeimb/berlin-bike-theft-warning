import 'package:biketheft_berlin/controller/data_sources_controller.dart';
import 'package:biketheft_berlin/general_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final modusStateProvider = StateProvider((ref) => 0);

final lorBikeAccidentsInfoProvider =
    FutureProvider<List<dynamic>?>((ref) async {
  final lor = ref.watch(selectedLorProvider).state?.item1;
  final accidents = await ref.watch(accidentsListProvider.future);

  // print(accidents);
  if (lor != null && accidents != null) {
    // print(lor);
    // accidents.forEach((r) => print(r.contains(int.parse(lor).toString())));

    return accidents
        .where((row) =>
            row.contains(int.parse(lor)) && row[13] == 1) // row[13] = isBike?
        .toList();
  }
});
