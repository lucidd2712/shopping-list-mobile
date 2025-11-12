import 'package:flutter/material.dart';
import 'package:football_news/screens/newslist_form.dart';
import 'package:football_news/screens/news_entry_list.dart';
import 'package:football_news/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class Item {
  final String name;
  final IconData icon;

  const Item({required this.name, required this.icon});
}

class ItemCard extends StatelessWidget {
  final Item item;
  const ItemCard(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil CookieRequest dari Provider (wajib untuk logout)
    final request = context.watch<CookieRequest>();

    return Material(
      color: Colors.indigo.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        // dibuat async supaya bisa await logout
        onTap: () async {
          // SnackBar umum
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text("Kamu telah menekan tombol ${item.name}!"),
              ),
            );

          // Navigasi & aksi sesuai nama tombol
          if (item.name == "Add News") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewsFormPage(),
              ),
            );
          } else if (item.name == "See Football News") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NewsEntryListPage(),
              ),
            );
          }

          // Fitur LOGOUT
          else if (item.name == "Logout") {
            // GANTI URL SESUAI ENVIRONMENT:
            // - Emulator: http://10.0.2.2:8000/auth/logout/
            // - Chrome:   http://localhost:8000/auth/logout/
            final response = await request.logout(
              "http://10.0.2.2:8000/auth/logout/",
            );

            String message = response["message"];

            if (context.mounted) {
              if (response['status']) {
                String uname = response["username"];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("$message See you again, $uname."),
                  ),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(message),
                  ),
                );
              }
            }
          }
        },

        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(item.icon, size: 36),
              const SizedBox(height: 12),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
