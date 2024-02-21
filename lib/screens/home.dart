import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:random_user/models/random_users.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  RandomUsers? randomUsers;
  String? error;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Random User"),
        backgroundColor: Colors.amber,
      ),
      body: (randomUsers == null)
          ? (error == null)
              ? const Center(
                  child: Text("Loading..."),
                )
              : Center(
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
          : Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(32),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: NetworkImage(
                          randomUsers!.results.first.picture.large),
                    ),
                  ),
                  Text(
                    "${randomUsers!.results.first.name.first} ${randomUsers!.results.first.name.last}",
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.email),
                      const SizedBox(
                        width: 8,
                      ),
                      Text(
                        randomUsers!.results.first.email,
                      ),
                    ],
                  )
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: refresh,
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Future<void> refresh() async {
    var response = await http.get(Uri.parse("https://randomuser.me/api"));
    if (response.statusCode == 200) {
      randomUsers = randomUsersFromJson(response.body);
      error = "";
    } else {
      randomUsers = null;
      error = "Error getting data from API: ${response.statusCode}";
    }
    setState(() {});
  }
}
