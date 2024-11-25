library entview;

import 'package:ent/ent.dart';
import 'package:flutter/material.dart';

export 'package:ent/ent.dart';
export 'package:flutter/material.dart';

abstract class EntView<T extends Ent> extends StatelessWidget {
  final ValueNotifier listenable = ValueNotifier(false);
  final T get;

  EntView(this.get, {super.key});

  sync(List<String> props) {
    for (final prop in props) {
      get.listen(prop, (_) {
        listenable.value = !listenable.value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: listenable,
        builder: (context, _) {
          return render(context);
        });
  }

  Widget render(BuildContext context);
}
