import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import 'dashboard_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final username = _userController.text.trim();
    final pass = _passController.text.trim();
    if (username.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter credentials')));
      return;
    }
    context.read<AuthBloc>().add(LoginRequested(username, pass));
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, DashboardPage.routeName);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App title / logo
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: primary,
                          child: Icon(Icons.eco, color: Colors.white, size: 28),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('G.One', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                            Text('Waste Management', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 28),
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    child: Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Column(
                        children: [
                          Text('Welcome', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Sign in to manage waste',
                              style: TextStyle(color: Colors.grey[600], fontSize: 13), textAlign: TextAlign.center),
                          SizedBox(height: 18),
                          TextField(
                            controller: _userController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                          SizedBox(height: 12),
                          TextField(
                            controller: _passController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              prefixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            obscureText: true,
                          ),
                          SizedBox(height: 18),
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              final loading = state is AuthLoading;
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: loading ? null : _onLoginPressed,
                                 
                                  child: Padding(
                                    
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: loading ? SizedBox(height: 18, width: 18,
                                     child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : Text('LOGIN', style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1.0)),),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 10),
                          TextButton(onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Reset flow - coming soon'))),
                              child: Text('Forgot password?', style: TextStyle(color: primary))),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

