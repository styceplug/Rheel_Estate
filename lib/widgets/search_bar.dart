import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:rheel_estate/controllers/properties_controller.dart';
import 'package:rheel_estate/models/products_data.dart';
import 'package:rheel_estate/screens/additional_screens/search_list_screen.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import '../utils/app_constants.dart';

class MySearchBar extends StatefulWidget {
  final String hintText;
  final Function(String, List<dynamic>) onLocationSelected;


  const MySearchBar({
    super.key,
    required this.hintText,
    required this.onLocationSelected,
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  PropertiesController propertyController  = Get.find<PropertiesController>();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _locations = [];
  List<String> _filteredLocations = [];
  List<PropertiesModel> _properties = [];

  bool _isLoading = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  Future<void> _fetchLocations() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('${AppConstants.BASE_URL}${AppConstants.GET_PROPERTIES}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          List<dynamic> properties = data['data'];

          Set<String> locationsSet = properties
              .map<String>((property) => property['location'].toString())
              .toSet();

          _properties = propertyController.properties;

          setState(() {
            _locations = locationsSet.toList();
            _filteredLocations = _locations;
            // _properties = properties;
          });
        } else {
          throw Exception("Unexpected JSON structure: 'data' key not found");
        }
      } else {
        throw Exception('Failed to fetch locations');
      }
    } catch (e) {
      debugPrint('Error fetching locations: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterLocations(String query) {
    setState(() {
      _filteredLocations = _locations
          .where((location) => location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _selectLocation(String location) {
    print(_filteredLocations);
    print(location);
    List<PropertiesModel> filteredProperties = _properties
        .where((property) => property.location.toLowerCase().contains(location.toLowerCase()))
        .toList();
    print(filteredProperties);
    
    Get.to(()=>SearchListScreen(properties: filteredProperties));

    setState(() {
      _controller.text = location;
      // _filteredLocations.clear();
      _controller.clear();
    });

    _properties.clear();
    _unfocus();
    widget.onLocationSelected(location, filteredProperties);
  }

  void _unfocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _unfocus,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            onChanged: _filterLocations,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              hintText: widget.hintText,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _isFocused
                  ? IconButton(
                icon: const Icon(Icons.cancel, color: Colors.grey),
                onPressed: () {
                  setState(() {
                    _controller.clear();
                    _filteredLocations.clear();
                    _isFocused = false;
                  });
                  _unfocus();
                },
              )
                  : null,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      width: Dimensions.width5 / Dimensions.width20,
                      color: Colors.black.withOpacity(0.4))),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide: BorderSide(
                  width: Dimensions.width5 / Dimensions.width20,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius30),
                borderSide: BorderSide(
                  width: Dimensions.width5 / Dimensions.width20,
                  color: Colors.black.withOpacity(0.4),
                ),
              ),
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          if (_isFocused && _filteredLocations.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                   BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredLocations.length,
                itemBuilder: (context, index) {
                  final location = _filteredLocations[index];
                  return ListTile(
                    title: Text(location),
                    onTap: () => _selectLocation(location),
                  );
                },
              ),
            ),
          if (_isFocused && _filteredLocations.isEmpty && !_isLoading && _controller.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No results found.'),
            ),
        ],
      ),
    );
  }
}