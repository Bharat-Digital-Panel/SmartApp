import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('com.example.sms/send');
  final TextEditingController _phoneController = TextEditingController();

  // Future<void> _loadSavedPhoneNumber() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? savedPhone = prefs.getString('mobile_number');
  //   if (savedPhone != null) {
  //     _phoneController.text = savedPhone;
  //   }
  // }

  // Future<void> _savePhoneNumber(String phone) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('mobile_number', phone);
  // }

  Future<void> _sendSms(String message) async {
    final phone = _phoneController.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter a mobile number')));
      return;
    }

    await Permission.sms.request();

    try {
      await platform.invokeMethod('sendSms', {
        "phone": phone,
        "message": message,
      });
      // await _savePhoneNumber(phone);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('SMS sent to $phone')));
    } on PlatformException catch (e) {
      print("Error: ${e.message}");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to send SMS')));
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Enter starter mobile number',
                border: OutlineInputBorder(),
                prefixText: '+91 ',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4CAF50),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _sendSms("ON"),
                  child: const Text('ON'),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF44336),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _sendSms("OFF"),
                  child: const Text('OFF'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0,191,255, 1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _sendSms("STS"),
                  child: const Text('Status'),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(0,0,128,1),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => _sendSms("SET 10"),
                  child: const Text('Current Set'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
