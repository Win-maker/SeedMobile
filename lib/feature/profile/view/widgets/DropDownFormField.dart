import 'package:flutter/material.dart';

class PrefixDropdown extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onChanged;

  const PrefixDropdown({
    super.key,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<PrefixDropdown> createState() => _PrefixDropdownState();
}

class _PrefixDropdownState extends State<PrefixDropdown> {
  late String _selectedPrefix;

  @override
  void initState() {
    super.initState();
    _selectedPrefix = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButtonFormField<String>(
        value: _selectedPrefix,
        onChanged: (String? newValue) {
          setState(() {
            _selectedPrefix = newValue!;
          });
          widget.onChanged(newValue!);
        },
        decoration: InputDecoration(labelText: 'Prefix'),
        items: ['Mr.', 'Mrs.', 'Miss'].map((String prefix) {
          return DropdownMenuItem<String>(
            value: prefix,
            child: Text(prefix),
          );
        }).toList(),
      ),
    );
  }
}
