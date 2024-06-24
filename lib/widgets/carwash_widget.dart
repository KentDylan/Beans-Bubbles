import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/car_wash_order.dart';
import '../auth/auth_service.dart'; // Sesuaikan dengan lokasi AuthService


class CarWashWidget extends StatefulWidget {
  const CarWashWidget({Key? key}) : super(key: key);

  @override
  State<CarWashWidget> createState() => _CarWashWidgetState();
}

class _CarWashWidgetState extends State<CarWashWidget> {
  late CalendarFormat _calendarFormat;
  late DateTime _selectedDay;
  late DateTime _focusedDay;
  TimeOfDay _selectedTimeOfDay = TimeOfDay(hour: 9, minute: 0);
  bool _isDateSelected = false;
  TextEditingController _timeController = TextEditingController();
  String? _selectedWash;
  String? _selectedCarType;
  bool _isVoucherValid = true;
  final AuthService _authService = AuthService();

  final int _basePrice = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, int> _washPrices = {
    'Basic': 50000,
    'Premium': 60000,
    'Ultimate': 70000,
  };

  Map<String, int> _carTypePrices = {
    'Sedan': 10000,
    'SUV': 20000,
    'Truck': 40000,
  };

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay.add(Duration(days: 1));
    _timeController.text = 'Time';
  }

  @override
  void dispose() {
    _timeController.dispose();
    super.dispose();
  }

  Future<void> _bookCarWash() async {
    try {
      // Hitung total biaya seperti sebelumnya
          int totalCost = _basePrice +
        (_isDateSelected &&
                (_selectedDay.weekday == DateTime.saturday ||
                    _selectedDay.weekday == DateTime.sunday)
            ? 20000
            : 0) +
        (_selectedWash != null ? _washPrices[_selectedWash!]! : 0) +
        (_selectedCarType != null ? _carTypePrices[_selectedCarType!]! : 0);

    if (_isVoucherValid && _selectedWash != null && _selectedCarType != null) {
      double discount = totalCost * 0.15;
      totalCost -= discount.toInt();
    }
      // Dapatkan userId dari AuthService
      String userId = _authService.getCurrentUserId();

      // Buat objek CarWashOrder
      final newOrder = CarWashOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: DateFormat.yMMMd().format(_selectedDay),
        time: _timeController.text,
        washType: _selectedWash!,
        carType: _selectedCarType!,
        totalCost: totalCost,
      );

      // Simpan ke Firestore dalam collection 'users/$userId/carwash_orders'
      await _firestore.collection('users').doc(userId).collection('carwash_orders').doc(newOrder.id).set(newOrder.toMap());

      // Berikan notifikasi sukses
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking confirmed! Total cost: Rp ${NumberFormat('#,##0', 'id_ID').format(totalCost)}')),
      );
    } catch (e) {
      print('Error booking car wash: $e');
      // Tangani kesalahan sesuai kebutuhan
    }
  }

  @override
  Widget build(BuildContext context) {
    var isSmallScreen = MediaQuery.of(context).size.width < 600;
    var padding = EdgeInsets.symmetric(horizontal: isSmallScreen ? 15 : 25, vertical: 20);
    var buttonHeight = isSmallScreen ? 45.0 : 50.0;

    // Hitung total biaya
    int totalCost = _basePrice +
        (_isDateSelected &&
                (_selectedDay.weekday == DateTime.saturday ||
                    _selectedDay.weekday == DateTime.sunday)
            ? 20000
            : 0) +
        (_selectedWash != null ? _washPrices[_selectedWash!]! : 0) +
        (_selectedCarType != null ? _carTypePrices[_selectedCarType!]! : 0);

    if (_isVoucherValid && _selectedWash != null && _selectedCarType != null) {
      double discount = totalCost * 0.15;
      totalCost -= discount.toInt();
    }

    final NumberFormat currencyFormat = NumberFormat('#,##0', 'id_ID');

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
      child: Container(
        height: isSmallScreen ? 500 : 600,
        color: Colors.white,
        padding: padding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.0),

              FormField<String>(
                builder: (FormFieldState<String> state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputDecorator(
                        decoration: InputDecoration(
                          labelText: _isDateSelected ? 'Date' : 'Date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 20.0),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _showCalendar(context, state);
                            },
                            icon: Icon(Icons.calendar_today),
                          ),
                          suffixIconConstraints:
                              BoxConstraints(minWidth: 40.0),
                        ),
                        child: Text(
                          _isDateSelected
                              ? DateFormat.yMMMd().format(_selectedDay)
                              : 'Date',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),

                      if (state.errorText != null)
                        Text(
                          state.errorText!,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  );
                },
              ),

              SizedBox(height: 20.0),

              TextFormField(
                readOnly: true,
                controller: _timeController,
                decoration: InputDecoration(
                  labelText: 'Time',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _showTimePicker(context);
                    },
                    icon: Icon(Icons.access_time),
                  ),
                  suffixIconConstraints: BoxConstraints(minWidth: 40.0),
                ),
              ),

              SizedBox(height: 20.0),

              DropdownButtonFormField<String>(
                value: _selectedWash,
                hint: Text('Select Wash Type'),
                decoration: InputDecoration(
                  labelText: 'Wash Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                items: ['Basic', 'Premium', 'Ultimate'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWash = newValue!;
                  });
                },
              ),
              SizedBox(height: 20.0),

              DropdownButtonFormField<String>(
                value: _selectedCarType,
                hint: Text('Select Car Type'),
                decoration: InputDecoration(
                  labelText: 'Car Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                ),
                items: ['Sedan', 'SUV', 'Truck'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCarType = newValue!;
                  });
                },
              ),
              SizedBox(height: 20.0),

              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Voucher Code',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 20.0),
                ),
                onChanged: (value) {
                  if (value.toLowerCase() == 'devressed') {
                    setState(() {
                      _isVoucherValid = true;
                    });
                  } else {
                    setState(() {
                      _isVoucherValid = false;
                    });
                  }
                },
              ),

              if (!_isVoucherValid)
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Invalid voucher code',
                    style: TextStyle(color: Colors.red),
                  ),
                ),

              SizedBox(height: 20.0),

              Text(
                'Rp ${currencyFormat.format(totalCost)}',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),

              ElevatedButton(
                onPressed: _selectedWash != null &&
                        _selectedCarType != null &&
                        _selectedDay != null
                    ? _bookCarWash
                    : null,
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                  minimumSize: Size(double.infinity, buttonHeight),
                ),
                child: Text('Book'),
              ),
              SizedBox(height: 20.0),
	                    ],
            ),
          ),
        ),
      )
    ;
  }

  void _showCalendar(BuildContext context, FormFieldState<String> state) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDay,
      firstDate: DateTime.now().add(Duration(days: 0)),
      lastDate: DateTime(2026, 12, 31),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.orange,
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              secondary: Colors.orange,
            ),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDay) {
      setState(() {
        _selectedDay = DateTime(picked.year, picked.month, picked.day);
        state.didChange(DateFormat.yMMMd().format(picked));
        _isDateSelected = true;
      });
    }
  }

  void _showTimePicker(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTimeOfDay,
    );
    if (picked != null && picked != _selectedTimeOfDay) {
      setState(() {
        _selectedTimeOfDay = picked;
        _timeController.text = picked.format(context);
      });
    }
  }
}