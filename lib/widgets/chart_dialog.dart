import 'package:biketheft_berlin/general_provider.dart';
import 'package:biketheft_berlin/screens/plot_thefts_to_report_date_fl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChartDialog extends HookWidget {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ChartDialog(),
    );
  }

  const ChartDialog();

  @override
  Widget build(BuildContext context) {
    final title = useProvider(selectedLorProvider).state?.item2;

    return SafeArea(
      maintainBottomViewPadding: true,
      child: AspectRatio(
        aspectRatio: 4 / 8,
        child: Card(
          color: Theme.of(context).primaryColor,
          margin: EdgeInsets.fromLTRB(40, 180, 40, 150),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: PlotTheftsToReportDateFl(),
                  ),
                  Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Zurück'),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Zeitraum'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
