import 'dart:async';
import 'dart:convert';
import 'package:demo1/Chat/displayuserhome.dart';
import 'package:demo1/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'Profilepage.dart';
import 'input data/TripDataPage.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({Key? key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Timer? _debounce;
  List<dynamic> _suggestions = []; // This stores the suggestions.
  int _selectedIndex = 0;
  String _distance = '';
  String _time = '';
  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  LatLng? _destinationPosition;
  String? _destinationAddress;
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _destinationLocationController =
      TextEditingController();

  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _getPlaceSuggestions(query);
      } else {
        setState(() {
          _suggestions.clear();
        });
      }
    });
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enable location services')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied. Please enable them in settings.'),
        ),
      );
      return;
    }

    // Fetch current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });

    // Reverse geocoding to get the address
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      setState(() {
        _currentLocationController.text =
            '${place.locality}, ${place.administrativeArea}, ${place.country}';
      });
    }

    // Move the camera to current location
    if (_mapController != null && _currentPosition != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: _currentPosition!, zoom: 14),
        ),
      );
    }
  }

  // Convert address to LatLng and set the destination marker
  Future<void> _setDestinationLocation() async {
    List<Location> locations =
        await locationFromAddress(_destinationLocationController.text);
    if (locations.isNotEmpty) {
      setState(() {
        _destinationPosition =
            LatLng(locations.first.latitude, locations.first.longitude);
        _destinationAddress = _destinationLocationController.text;
      });

      // Move camera to destination
      if (_mapController != null && _destinationPosition != null) {
        _mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _destinationPosition!, zoom: 14),
          ),
        );
      }
    }
  }

  // Draw polyline between current location and destination
  Future<void> _drawRoute() async {
    if (_currentPosition == null || _destinationPosition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Set both current and destination locations')),
      );
      return;
    }

    final osrmApi = 'https://router.project-osrm.org/route/v1/driving/'
        '${_currentPosition!.longitude},${_currentPosition!.latitude};'
        '${_destinationPosition!.longitude},${_destinationPosition!.latitude}?geometries=geojson';

    try {
      final response = await http.get(Uri.parse(osrmApi));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final route =
            data['routes'][0]['geometry']['coordinates'] as List<dynamic>;

        final points = route.map((coord) {
          return LatLng(coord[1], coord[0]); // Flip to LatLng format
        }).toList();

        // Extracting the distance and time from the API response
        final distance = data['routes'][0]['distance']; // Distance in meters
        final duration = data['routes'][0]['duration']; // Duration in seconds

        final distanceInKm =
            (distance / 1000).toStringAsFixed(2); // Convert to km
        final durationInHours =
            (duration / 3600).toStringAsFixed(2); // Convert to hours
        final durationInMinutes =
            (duration / 60).toStringAsFixed(0); // Convert to minutes

        setState(() {
          _polylines.clear();
          _polylines.add(
            Polyline(
              polylineId: const PolylineId('route'),
              points: points,
              color: Colors.orange,
              width: 5,
            ),
          );

          // Store the distance and time in state
          _distance = '$distanceInKm km';
          _time = '$durationInMinutes minutes';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Route drawn successfully!')),
        );
      } else {
        throw Exception('Failed to load route');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching route: $e')),
      );
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  double? _distanceInKm; // Variable to store the distance

// Calculate distance between current and destination positions
  void _calculateDistance() {
    if (_currentPosition != null && _destinationPosition != null) {
      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        _destinationPosition!.latitude,
        _destinationPosition!.longitude,
      );

      setState(() {
        _distanceInKm = distance / 1000; // Convert meters to kilometers
      });
    }
  }

  Future<void> _getPlaceSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _suggestions.clear();
      });
      return;
    }

    final url = Uri.encodeFull(
        'https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1&limit=2');

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Set a 10-second timeout
      print('Fetching suggestions from: $url');
      print('Response Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response Body: ${response.body}');
        setState(() {
          _suggestions = data;
        });
      } else {
        throw Exception('Failed to load suggestions');
      }
    } on TimeoutException {
      print('Request timed out.');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request timed out. Please try again.')),
      );
    } catch (e) {
      print('Error fetching suggestions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching suggestions: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        title: const Text(
          'Your Location',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(248, 247, 250, 1),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.07,
          vertical: screenHeight * 0.01,
        ),
        child: Column(
          children: [
            TextField(
              controller: _currentLocationController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.my_location),
                labelText: 'Current Location',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              enabled: false, // Make this non-editable
            ),
            SizedBox(height: screenHeight * 0.02),
            TextField(
              controller: _destinationLocationController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                labelText: 'Search Destination',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
            if (_suggestions.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion['display_name']),
                    onTap: () {
                      setState(() {
                        _destinationLocationController.text =
                            suggestion['display_name'];
                        _destinationPosition = LatLng(
                          double.parse(suggestion['lat']),
                          double.parse(suggestion['lon']),
                        );
                        _suggestions.clear();
                      });
                    },
                  );
                },
              ),
            SizedBox(height: screenHeight * 0.02),
            Align(
              child: ElevatedButton(
                onPressed: () {
                  if (_currentPosition != null &&
                      _destinationPosition != null) {
                    _drawRoute();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Set both current and destination locations'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  minimumSize: Size(screenWidth * 0.7, screenHeight * 0.07),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize
                      .min, // Ensures the button size fits the content
                  children: [
                    Icon(Icons.arrow_outward_sharp), // Your prefix icon
                    // Add space between icon and text
                    Text('Direction'), // Button text
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Distance Text
                Text(
                  'Distance: $_distance ',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Time Text
                Text(
                  'Time: $_time',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.03),
            Expanded(
                child: _currentPosition == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition!,
                          zoom: 14,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        },
                        onTap: (LatLng tappedPoint) async {
                          setState(() {
                            _destinationPosition = tappedPoint;
                          });

                          // Reverse geocoding to get the address of the tapped location
                          List<Placemark> placemarks =
                              await placemarkFromCoordinates(
                                  tappedPoint.latitude, tappedPoint.longitude);

                          if (placemarks.isNotEmpty) {
                            Placemark place = placemarks.first;
                            setState(() {
                              _destinationAddress =
                                  '${place.locality}, ${place.administrativeArea}, ${place.country}';
                              _destinationLocationController.text =
                                  _destinationAddress ?? '';
                            });
                          }

                          // Clear the polyline when the destination marker is tapped
                          setState(() {
                            _polylines.clear();
                          });
                        },
                        markers: {
                          Marker(
                            markerId: const MarkerId('currentLocation'),
                            position: _currentPosition!,
                            infoWindow:
                                const InfoWindow(title: 'Current Location'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
                          ),
                          if (_destinationPosition != null)
                            Marker(
                              markerId: const MarkerId('destinationLocation'),
                              position: _destinationPosition!,
                              infoWindow: InfoWindow(
                                  title: _destinationAddress ?? 'Destination'),
                              icon: BitmapDescriptor.defaultMarkerWithHue(
                                  BitmapDescriptor.hueRed),
                            ),
                        },
                        polylines: _polylines,
                      )),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.wallet),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TripDataPage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => DisplayUserHome(),
                ),);
              },
            ),
            const SizedBox(width: 5),
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.orange,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Homepage(),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            IconButton(
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profilepage.Profilepage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
