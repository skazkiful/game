import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/widgets/gradient_appbar.dart';

/// History page.
class HistoryPage extends StatefulWidget {
  const HistoryPage(this.prefs, {Key? key}) : super(key: key);

  /// [SharedPreferences] used to store and fetch some information.
  final SharedPreferences prefs;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

/// [State] of [HistoryPage].
class _HistoryPageState extends State<HistoryPage> {
  /// List of history results.
  List<String>? history = [];

  @override
  void initState() {
    history = widget.prefs.getStringList('history');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async => false,
        child: Container(
          decoration: const BoxDecoration(color: Color(0xFF0B3830)),
          child: Column(
            children: [
              GradientAppBar('history', widget.prefs),
              Expanded(
                child: (history != null)
                    ? ListView.separated(
                        itemBuilder: (context, i) => ListTile(
                          title: Text(
                            'Collected: ${history![i]}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        separatorBuilder: (context, i) => const Divider(
                          color: Colors.white,
                        ),
                        itemCount: history!.length,
                      )
                    : const Center(
                        child: Text('History is empty'),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
