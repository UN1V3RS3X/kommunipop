import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kommunipop/src/blocs/auth_bloc/bloc.dart';
import 'package:kommunipop/src/resources/firebase_repository.dart';

class Home extends StatefulWidget {
  final UserRepository userRepository;

  Home({Key key, @required this.userRepository}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

enum WidgetMarker { inicio, soporte, perfil }

class _HomeState extends State<Home> {
  int _selectedItemIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: MenuLateral(),
      // bottomNavigationBar: Row(
      //   children: <Widget>[
      //     buildNavBarItem(Icons.home, 0),
      //     buildNavBarItem(Icons.star, 1),
      //     buildNavBarItem(Icons.shopping_cart, 2),
      //     buildNavBarItem(Icons.account_box, 3),
      //   ],
      // ),
      body: Center(
        child: Text('Hola mundo'),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width / 4,
        decoration: index == _selectedItemIndex
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 4, color: Colors.green),
                ),
                gradient: LinearGradient(colors: [
                  Colors.blue.withOpacity(0.3),
                  Colors.blue.withOpacity(0.015),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter))
            : BoxDecoration(),
        child: Icon(
          icon,
          color: index == _selectedItemIndex ? Colors.green : Colors.black54,
        ),
      ),
    );
  }
}

class MenuLateral extends StatelessWidget {
  UserRepository userRepository = new UserRepository();

  MenuLateral({Key key}) : super(key: key);

  Future<String> waitEmail() async {
    return await userRepository.getEmail();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: waitEmail(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return drawer(context, snapshot.data);
          }
          return CircularProgressIndicator();
        });
  }

  Widget drawer(BuildContext context, String email) {
    return new Drawer(
      child: ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            height: 150,
            child: DrawerHeader(
              child: ListTile(
                subtitle: GestureDetector(
                  onTap: () {},
                  child: Text(
                    email,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                title: Text(
                  "Hola",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
                trailing: Container(
                  height: 70,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                        "https://www.pngitem.com/pimgs/m/508-5087240_clip-art-my-profile-icon-clipart-circle-hd.png"),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xFFF8FAFB),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.black54,
            ),
            title: Text(
              'Inicio',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            onTap: () {
              Navigator.pop(context);
            },
            //
          ),
          ListTile(
            leading: Icon(
              Icons.close,
              color: Colors.black54,
            ),
            title: Text(
              'Cerrar Sesión',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
            onTap: () {
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            //
          ),
        ],
      ),
    );
  }
}
