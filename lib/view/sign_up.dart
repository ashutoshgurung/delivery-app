import 'package:flutter/material.dart';
import 'package:food_ordering_app/utils/validator.dart';
import 'package:food_ordering_app/view/sign_in.dart';
import 'package:food_ordering_app/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _agreed = false;
  int _strength = 0;

  void _onPasswordChanged(String val) {
    int s = 0;
    if (val.length >= 8) s++;
    if (val.contains(RegExp(r'[A-Z]'))) s++;
    if (val.contains(RegExp(r'[0-9]'))) s++;
    if (val.contains(RegExp(r'[!@#\$&*~]'))) s++;
    setState(() => _strength = s);
  }

  Color get _strengthColor {
    if (_strength <= 1) return const Color(0xFFCC0000);
    if (_strength == 2) return const Color(0xFFFF6600);
    if (_strength == 3) return const Color(0xFFFFAA00);
    return const Color(0xFF22AA55);
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please agree to the Terms of Service and Privacy Policy"),
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    final success = await authViewModel.signUp(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account created successfully")),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SignInScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? "Sign up failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthViewModel>().isLoading;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFFCC0000),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
            ),
          ),
          Positioned(
            top: 30,
            right: 30,
            child: Column(
              children: List.generate(
                3,
                (row) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: List.generate(
                      3,
                      (col) => Container(
                        margin: const EdgeInsets.only(left: 8),
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Create\nAccount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 30,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'EMAIL ADDRESS',
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFEEEEEE)),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                const Icon(
                                  Icons.alternate_email_rounded,
                                  color: Color(0xFFCC0000),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: emailController,
                                    validator: Validator.email,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(
                                      color: Color(0xFF111111),
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'youremail@example.com',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFEEEEEE)),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFFCC0000),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: passwordController,
                                    validator: Validator.password,
                                    obscureText: _obscurePass,
                                    onChanged: _onPasswordChanged,
                                    style: const TextStyle(
                                      color: Color(0xFF111111),
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Min. 8 characters',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _obscurePass = !_obscurePass,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 14),
                                    child: Icon(
                                      _obscurePass
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFFBBBBBB),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_strength > 0) ...[
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                ...List.generate(
                                  4,
                                  (i) => Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        right: i < 3 ? 5 : 0,
                                      ),
                                      height: 3,
                                      decoration: BoxDecoration(
                                        color: i < _strength
                                            ? _strengthColor
                                            : const Color(0xFFEEEEEE),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 20),
                          const Text(
                            'CONFIRM PASSWORD',
                            style: TextStyle(
                              color: Color(0xFFAAAAAA),
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F8F8),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFEEEEEE)),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 14),
                                const Icon(
                                  Icons.lock_outline_rounded,
                                  color: Color(0xFFCC0000),
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: confirmPasswordController,
                                    validator: (value) =>
                                        Validator.confirmPassword(
                                          value,
                                          passwordController.text,
                                        ),
                                    obscureText: _obscureConfirm,
                                    style: const TextStyle(
                                      color: Color(0xFF111111),
                                      fontSize: 14,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Repeat password',
                                      hintStyle: TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 13,
                                      ),
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => setState(
                                    () => _obscureConfirm = !_obscureConfirm,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 14),
                                    child: Icon(
                                      _obscureConfirm
                                          ? Icons.visibility_off_outlined
                                          : Icons.visibility_outlined,
                                      color: const Color(0xFFBBBBBB),
                                      size: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          GestureDetector(
                            onTap: () => setState(() => _agreed = !_agreed),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  width: 22,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color: _agreed
                                        ? const Color(0xFFCC0000)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: _agreed
                                          ? const Color(0xFFCC0000)
                                          : const Color(0xFFCCCCCC),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: _agreed
                                      ? const Icon(
                                          Icons.check_rounded,
                                          size: 14,
                                          color: Colors.white,
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: RichText(
                                    text: const TextSpan(
                                      style: TextStyle(
                                        color: Color(0xFF888888),
                                        fontSize: 12,
                                        height: 1.5,
                                      ),
                                      children: [
                                        TextSpan(text: 'I agree to the '),
                                        TextSpan(
                                          text: 'Terms of Service',
                                          style: TextStyle(
                                            color: Color(0xFFCC0000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(text: ' and '),
                                        TextSpan(
                                          text: 'Privacy Policy',
                                          style: TextStyle(
                                            color: Color(0xFFCC0000),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: isLoading ? null : _handleSignUp,
                      child: Container(
                        height: 58,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCC0000),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCC0000).withOpacity(0.35),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE5E5E5),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or sign up with',
                            style: TextStyle(
                              color: Color(0xFFBBBBBB),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFFE5E5E5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFEEEEEE),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.g_mobiledata_rounded,
                                    color: Color(0xFF777777),
                                    size: 26,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      color: Color(0xFF555555),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFEEEEEE),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple_rounded,
                                    color: Color(0xFF777777),
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Apple',
                                    style: TextStyle(
                                      color: Color(0xFF555555),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SignInScreen()),
                        ),
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Color(0xFF999999),
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(text: 'Already have an account?  '),
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: Color(0xFFCC0000),
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}