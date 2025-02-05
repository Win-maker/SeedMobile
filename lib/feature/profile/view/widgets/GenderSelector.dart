import 'package:flutter/material.dart';

class GenderSelector extends StatefulWidget {
  final String selectedGender;
  final ValueChanged<String> onGenderChanged;

const GenderSelector({super.key, required this.selectedGender, required this.onGenderChanged});
  // const GenderSelector({super.key, required this.selectedGender});
  @override
  State<GenderSelector> createState() => _GenderSelectorState();
}

class _GenderSelectorState extends State<GenderSelector> {
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _gender = widget.selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Gender:', style: TextStyle(fontSize: 16)),
        SizedBox(width: 20),
        Row(
          children: [
            Radio<String>(
              value: 'male',
              groupValue: _gender,
              onChanged: (String? value) {
                setState(() {
                  _gender = value!;
                  widget.onGenderChanged(_gender);
                });
              },
              activeColor: _gender == 'male' ? Colors.green : Colors.grey,
            ),
            Text('Male'),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: 'female',
              groupValue: _gender,
              onChanged: (String? value) {
                setState(() {
                  _gender = value!;
                  // widget.onGenderChanged(_gender);
                });
              },
              activeColor: _gender == 'female' ? Colors.green : Colors.grey,
            ),
            Text('Female'),
          ],
        ),
      ],
    );
  }
}
