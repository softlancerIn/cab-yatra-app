import 'package:flutter/material.dart';

class AlertFilterScreen extends StatefulWidget {
  const AlertFilterScreen({super.key});

  @override
  State<AlertFilterScreen> createState() => _AlertFilterScreenState();
}

class _AlertFilterScreenState extends State<AlertFilterScreen> {
  List<String> selectedVehicles = [];
  bool manualPickup = true;
  List<String> pickupCities = [];
  final TextEditingController cityController = TextEditingController();

  @override
  void dispose() {
    cityController.dispose();
    super.dispose();
  }

  void toggleVehicle(String type) {
    setState(() {
      if (selectedVehicles.contains(type)) {
        selectedVehicles.remove(type);
      } else {
        selectedVehicles.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Alert',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back_ios, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'select vehicle type you require',
              style: TextStyle(color: Color(0xff787878), fontSize: 14),
            ),
            const SizedBox(height: 16),

            /// VEHICLE GRID
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                vehicleCard('hatchback'),
                vehicleCard('Sedan'),
                vehicleCard('SUV'),
                vehicleCard('Assured'),
                vehicleCard('Innova Crasta'),
                vehicleCard('Traveller'),
              ],
            ),

            const SizedBox(height: 20),

            /// SWITCH CARD
            Container(
              padding: const EdgeInsets.all(14),
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 4,
                    offset: Offset(0, 0),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Select Your Pickup City Manually',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xff3E4959)),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'this will help you to get one way and round trip Notifications',
                          style: TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    thumbColor: const WidgetStatePropertyAll(Colors.orange),
                    value: manualPickup,
                    onChanged: (val) {
                      setState(() {
                        manualPickup = val;
                      });
                    },
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// CONDITIONAL UI (SECOND IMAGE LOGIC)
            if (manualPickup) ...[
              Wrap(
                spacing: 8,
                children: pickupCities.map((city) {
                  return Chip(
                    backgroundColor: Colors.orange,
                    label: Text(
                      city,
                      style: const TextStyle(color: Colors.white),
                    ),
                    onDeleted: () {
                      setState(() {
                        pickupCities.remove(city);
                      });
                    },
                    deleteIcon:
                        const Icon(Icons.close, size: 18, color: Colors.white),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: cityController,
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    setState(() {
                      pickupCities.add(value.trim());
                      cityController.clear();
                    });
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Select Your Pickup City',
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],

            //const Spacer(),

            /// BOTTOM BUTTONS
          ],
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xff3E4959)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  setState(() {
                    selectedVehicles.clear();
                    pickupCities.clear();
                    manualPickup = false;
                  });
                },
                child: const Text(
                  'Clear Filter',
                  style: TextStyle(color: Color(0xff3E4959)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// VEHICLE CARD WIDGET
  Widget vehicleCard(String title) {
    final isSelected = selectedVehicles.contains(title);

    return GestureDetector(
      onTap: () => toggleVehicle(title),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 3.6,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.orange : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/carMO.png', // replace with your image
                  height: 40,
                ),
                const SizedBox(height: 3),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
          if (isSelected)
            const Positioned(
              right: 8,
              top: 6,
              child: CircleAvatar(
                radius: 8,
                backgroundColor: Colors.white,
                child: Icon(Icons.check, size: 12, color: Colors.orange),
              ),
            ),
        ],
      ),
    );
  }
}
