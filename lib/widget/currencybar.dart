import 'package:flutter/material.dart';

class CurrencyBar extends StatefulWidget {
  var titleKey;
  var value;
  VoidCallback? myCallback;
  CurrencyBar(
      {required this.titleKey, required this.value, required this.myCallback});

  @override
  State<CurrencyBar> createState() => _CurrencyBarState();
}

class _CurrencyBarState extends State<CurrencyBar> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.myCallback,
      child: Card(
        elevation: 1.1,
        color: Colors.transparent,
        child: ListTile(
          tileColor: Colors.transparent,
          leading: Image(image: AssetImage("assets/comparison.png")),
          title: Text("${widget.titleKey}",
              style: Theme.of(context).textTheme.bodyLarge),
          trailing: Text("${widget.value.toStringAsFixed(2)}",
              style: Theme.of(context).textTheme.bodyLarge),
        ),
      ),
    );
  }
}
