import 'package:flutter/material.dart';

// constants
import 'package:proj/constants.dart';

// models
import 'package:provider/provider.dart';
import 'package:proj/models/notifiers.dart';

// views
import 'package:proj/views/main/history/components/no_history.dart';

class UserHistoryPage extends StatefulWidget {
  const UserHistoryPage({
    super.key,
    required this.changePageCallback
  });

  final VoidCallback changePageCallback;

  @override
  State<UserHistoryPage> createState() => _UserHistoryPageState();
}

class _UserHistoryPageState extends State<UserHistoryPage> {
  @override
  Widget build(BuildContext context) {

    return NoHistory(changePageCallback: widget.changePageCallback);
  }
}

