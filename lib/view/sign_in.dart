import 'package:flutter/material.dart';
import 'package:food_ordering_app/navigation/bottom_navigation_screen.dart';
import 'package:food_ordering_app/utils/validator.dart';
import 'package:food_ordering_app/view/sign_up.dart';
import 'package:food_ordering_app/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      body: Stack(
        children: [
          // ── glow top-left ──
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 340,
              height: 340,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFCC0000).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ── glow bottom-right ──
          Positioned(
            bottom: 40,
            right: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFCC0000).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),

                    // ── Brand ──
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCC0000),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'VhokLayo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.07),

                    // ── Heading ──
                    const Text(
                      'Hey,\nWelcome\nBack ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        height: 1.1,
                        letterSpacing: -1.5,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Sign in to order your favourite food.',
                      style: TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    SizedBox(height: size.height * 0.055),

                    // ── Email ──
                    const Text(
                      'EMAIL',
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.alternate_email_rounded,
                            color: Color(0xFFCC0000),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: emailController,
                              validator: Validator.email,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'youremail@example.com',
                                hintStyle: TextStyle(
                                  color: Color(0xFF3C3C3C),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // ── Password ──
                    const Text(
                      'PASSWORD',
                      style: TextStyle(
                        color: Color(0xFF555555),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1C),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFF2A2A2A)),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0xFFCC0000),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: passwordController,
                              validator: Validator.password,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Min. 8 characters',
                                hintStyle: TextStyle(
                                  color: Color(0xFF3C3C3C),
                                  fontSize: 14,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: const Color(0xFF555555),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── Remember + Forgot ──
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () =>
                              setState(() => _rememberMe = !_rememberMe),
                          child: Row(
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  color: _rememberMe
                                      ? const Color(0xFFCC0000)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: _rememberMe
                                        ? const Color(0xFFCC0000)
                                        : const Color(0xFF444444),
                                    width: 1.5,
                                  ),
                                ),
                                child: _rememberMe
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 13,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Remember me',
                                style: TextStyle(
                                  color: Color(0xFF666666),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          'Forgot password?',
                          style: TextStyle(
                            color: Color(0xFFCC0000),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // ── Sign In button ──
                    GestureDetector(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          final authViewModel = context.read<AuthViewModel>();
                          bool success = await authViewModel.logIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                          if (success) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NavigationScreen(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Invalid email or password"),
                              ),
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 58,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE80000), Color(0xFF8B0000)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFCC0000).withOpacity(0.4),
                              blurRadius: 28,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.3,
                              ),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    // ── Divider ──
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFF222222),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'or sign in with',
                            style: TextStyle(
                              color: Color(0xFF444444),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: const Color(0xFF222222),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // ── Social ──
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1C),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF2A2A2A),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.g_mobiledata_rounded,
                                    color: Color(0xFF888888),
                                    size: 26,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Google',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
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
                              height: 52,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1C),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFF2A2A2A),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.apple_rounded,
                                    color: Color(0xFF888888),
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Apple',
                                    style: TextStyle(
                                      color: Color(0xFF888888),
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

                    const SizedBox(height: 40),

                    // ── Go to Sign Up ──
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => SignUpScreen()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            style: TextStyle(
                              color: Color(0xFF555555),
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(text: "Don't have an account?  "),
                              TextSpan(
                                text: 'Sign Up',
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
