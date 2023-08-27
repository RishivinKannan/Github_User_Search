import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child:  MyApp(),
      ),
    );

class AppThemes {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.blue,
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class GithubApiClient {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> searchUsers(String query) async {
    try {
      final response = await _dio.get(
        'https://api.github.com/search/users?q=$query',
      );
      return response.data;
    } catch (error) {
      throw Exception('Failed to search users');
    }
  }

  Future<Map<String, dynamic>> getUser(String username) async {
    try {
      final response = await _dio.get(
        'https://api.github.com/users/$username',
      );
      return response.data;
    } catch (error) {
      throw Exception('Failed to get user details');
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'GitHub User Search',
      theme:
          themeProvider.isDarkMode ? AppThemes.darkTheme : AppThemes.lightTheme,
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final GithubApiClient _apiClient = GithubApiClient();
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  String _error = '';

  void _searchUsers(String query) async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _error = '';
      });
      return;
    }

    try {
      final result = await _apiClient.searchUsers(query);
      setState(() {
        _searchResults = result['items'];
        _error = ''; // Clear any previous errors
      });
    } catch (error) {
      setState(() {
        _error = 'Failed to search users'; // Set error message
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub User Search'),
        actions: [
          Row(children: [
            Icon(
              Icons.light_mode,
            ),
            Switch(
              value: themeProvider.isDarkMode,
              onChanged: (value) {
                themeProvider.toggleTheme();
              },
            ),
            Icon(
              Icons.dark_mode,
            ),
          ])
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchUsers,
              decoration: InputDecoration(
                labelText: 'Enter GitHub Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchController.clear();
                    _searchUsers('');
                  },
                ),
              ),
            ),
          ),
          if (_error.isNotEmpty)
            Text(
              _error,
              style: TextStyle(color: Colors.red),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (ctx, index) {
                final user = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(user['avatar_url']),
                  ),
                  title: Text(user['login']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDetailsScreen(username: user['login']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class UserDetailsScreen extends StatefulWidget {
  final String username;

  UserDetailsScreen({required this.username});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final GithubApiClient _apiClient = GithubApiClient();
  Map<String, dynamic> _userDetails = {};

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    try {
      final result = await _apiClient.getUser(widget.username);
      setState(() {
        _userDetails = result;
      });
    } catch (error) {
      // Handle error gracefully
      print('Error: $error');
      // Show an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(_userDetails['avatar_url'] ?? ''),
                radius: 50,
              ),
              SizedBox(height: 30),
              Text('${_userDetails['login']}', style: TextStyle(fontSize: 24)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 100,
                      padding: new EdgeInsets.all(10.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                          child:
                              Center(child: Text('Followers: ${_userDetails['followers']}'))),
                    ),
                    Container(
                      width: 200,
                      height: 100,
                      padding: new EdgeInsets.all(10.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                      child: 
                        Center(child: Text('Repositories: ${_userDetails['public_repos']}')),
                    ),
                    ),  
                  ],
                ),
              ),
              if(_userDetails['bio'] != null)
                      Container(
                        width: 800,
                        height: 200,
                        padding: new EdgeInsets.all(20.0),
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          elevation: 10,
                        child: Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              children: [
                                Text('${_userDetails['bio']}'),
                              ],
                            ),
                          ))),
                      ),
            ],
          ),
        ),
      ),
    );
  }
}
