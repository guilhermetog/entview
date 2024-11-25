library entview;

import 'package:ent/ent.dart';
import 'package:flutter/material.dart';

export 'package:ent/ent.dart';
export 'package:flutter/material.dart';

abstract class EntView<T extends Ent> extends StatelessWidget {
  final ValueNotifier listenable = ValueNotifier(false);
  final T get;

  EntView(this.get, {super.key}) {
    get["_initialized"] = false;
  }

  sync(List<String> props) {
    for (final prop in props) {
      get.listen(prop, (_) {
        listenable.value = !listenable.value;
      });
    }
  }

  double height(double percentage) =>
      (get["height"] ?? 100.0) / 100.0 * percentage;
  double width(double percentage) =>
      (get["width"] ?? 100.0) / 100.0 * percentage;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: listenable,
        builder: (context, _) {
          return LayoutBuilder(builder: (context, _) {
            if (!get["_initialized"]) {
              _calculateSize(context);
            }

            get["_initialized"] = true;
            return render(context);
          });
        });
  }

  Widget render(BuildContext context);

  _calculateSize(BuildContext context) {
    final parent =
        (context.findRenderObject() as RenderBox).parent as RenderBox;

    get["height"] = (get["height"] ?? 100.0) /
        100.0 *
        (parent.hasSize
            ? parent.size.height
            : MediaQuery.of(context).size.height);
    get["width"] = (get["width"] ?? 100.0) /
        100.0 *
        (parent.hasSize
            ? parent.size.width
            : MediaQuery.of(context).size.width);
  }
}
