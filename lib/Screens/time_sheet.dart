import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:developer' as developer;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:swat_poc/Data/calendar.dart';
import 'package:swat_poc/Repositories/calendars/repository.dart';

class TimeSheet extends HookWidget {
  final FlutterSecureStorage storage;
  final CalendarRepository calendarRepository;

  const TimeSheet(
      {Key? key, required this.storage, required this.calendarRepository})
      : super(key: key);

  logout(context) {
    storage.deleteAll();

    Navigator.pushReplacementNamed(context, '/login');
  }

  Future<Calendar> fetchCalendar(context) async {
    final token = await storage.read(key: 'token');

    if (token == null) {
      developer.log('fetchCalendar > no token');
      logout(context);
      return Calendar.empty();
    }

    try {
      developer.log('fetchCalendar...');

      return await calendarRepository.fetchCalendar();
    } catch (error) {
      developer.log('fetchCalendar > error: $error');
      // logout();
      return Calendar.empty();
    }
  }

  @override
  Widget build(BuildContext context) {
    final calendar = useState<Calendar>(Calendar.empty());

    useEffect(() {
      fetchCalendar(context).then((value) {
        calendar.value = value;
      });
    }, []);

    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () => logout(context),
        ),
      ]),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Time Sheet',
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
