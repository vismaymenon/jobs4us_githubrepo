import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jobs4us/pages/admin_login_page.dart';
import 'package:jobs4us/pages/create_admin_profile_page.dart';
import 'package:jobs4us/pages/create_profile_page.dart';
import 'package:jobs4us/pages/create_resident_profile_page.dart';
import 'package:jobs4us/pages/resident_login_page.dart';
import 'package:jobs4us/pages/resident_profile_page.dart';
import 'package:jobs4us/pages/user_management_page.dart';
import 'models/cart_item.dart';
import 'pages/login_page.dart';
import 'pages/minimart_page.dart';
import 'pages/product_page.dart';
import 'pages/request_cart_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY'] ?? '',
      authDomain: dotenv.env['AUTH_DOMAIN'] ?? '',
      projectId: dotenv.env['PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
      appId: dotenv.env['APP_ID'] ?? '',
      measurementId: dotenv.env['MEASUREMENT_ID'] ?? '',
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jobs4U',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(isAdmin: false),
        '/residentProfile': (context) => ResidentProfilePage(),
        '/residentLogin': (context) => ResidentLoginPage(),
        '/createResidentProfile': (context) => CreateResidentProfilePage(), 
        '/adminLogin': (context) => AdminLoginPage(),
        '/createAdminProfile': (context) => CreateAdminProfilePage(),
        '/createProfile': (context) => CreateProfilePage(isAdmin: false),
        '/minimart': (context) => MinimartPage(),
        '/userManagement': (context) => UserManagementPage(),
      },
    );
  }
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await dotenv.load(fileName: ".env");

//   await Firebase.initializeApp(
//     options: FirebaseOptions(
//       apiKey: dotenv.env['API_KEY'] ?? '',
//       authDomain: dotenv.env['AUTH_DOMAIN'] ?? '',
//       projectId: dotenv.env['PROJECT_ID'] ?? '',
//       storageBucket: dotenv.env['STORAGE_BUCKET'] ?? '',
//       messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
//       appId: dotenv.env['APP_ID'] ?? '',
//       measurementId: dotenv.env['MEASUREMENT_ID'] ?? '',
//     ),
//   );

//   // Run the app with shared cart items
//   runApp(MyApp());
// }

// class MyApp extends StatefulWidget {
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // Shared cart items across the app
//   final List<CartItem> cartItems = [];

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Jobs4U',
//       initialRoute: '/login',
//       routes: {
//         '/login': (context) => LoginPage(isAdmin: false, cartItems: cartItems), // Pass shared cart items
//         '/residentProfile': (context) => ResidentProfilePage(),
//         '/residentLogin': (context) => ResidentLoginPage(),
//         '/createResidentProfile': (context) => CreateResidentProfilePage(),
//         '/adminLogin': (context) => AdminLoginPage(),
//         '/createAdminProfile': (context) => CreateAdminProfilePage(),
//         '/createProfile': (context) => CreateProfilePage(isAdmin: false),
//         '/minimart': (context) => MinimartPage(cartItems: cartItems), // Pass shared cart items
//         '/userManagement': (context) => UserManagementPage(),
//       },
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
