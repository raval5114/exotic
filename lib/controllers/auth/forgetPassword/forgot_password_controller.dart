import 'package:exotic/view/auth/forgotPassword/SmsSendingScreen.dart';
import 'package:flutter/material.dart';

class ForgetPasswordComponent extends StatefulWidget {
  const ForgetPasswordComponent({super.key});

  @override
  State<ForgetPasswordComponent> createState() =>
      _ForgetPasswordComponentState();
}

class _ForgetPasswordComponentState extends State<ForgetPasswordComponent> {
  String _selectedOption = 'SMS';

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _onNextPressed() {
    print('Selected option: $_selectedOption');
    if (_selectedOption == 'SMS') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SmsSendingScreen()),
      );
    } else {}
  }

  void onCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background blob
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/src/login_blob_2.png',
            alignment: AlignmentDirectional.topStart,
          ),
        ),
        // Main UI
        Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              CircleAvatar(
                radius: 52,
                backgroundColor: Colors.white,
                child: CircleAvatar(radius: 48, child: Icon(Icons.person)),
              ),
              const SizedBox(height: 30),
              const Text(
                'Password Recovery',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'How you would like to restore your password?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              _buildOptionButton('SMS'),
              const SizedBox(height: 12),
              _buildOptionButton('Email'),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB44CFF),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: onCancel,
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton(String option) {
    final isSelected = _selectedOption == option;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: InkWell(
        onTap: () => _onOptionSelected(option),
        borderRadius: BorderRadius.circular(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color:
                isSelected ? const Color(0xFFEDE3FF) : const Color(0xFFFDEDEE),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isSelected ? const Color(0xFFB44CFF) : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                option,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF6B00B6) : Colors.black87,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              if (isSelected)
                const Icon(Icons.check_circle, color: Color(0xFFB44CFF)),
            ],
          ),
        ),
      ),
    );
  }
}
