import 'package:flutter/material.dart';
import 'package:rheel_estate/utils/dimensions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MySearchBar extends StatefulWidget {
  final String hintText;
  final Function(String) onLocationSelected; // Callback for location selection

  const MySearchBar({
    super.key,
    required this.hintText,
    required this.onLocationSelected, // Add this
  });

  @override
  State<MySearchBar> createState() => _MySearchBarState();
}

class _MySearchBarState extends State<MySearchBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _locations = [];
  List<String> _filteredLocations = [];
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
    if(!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final List<dynamic> response =
          await Supabase.instance.client.from('locations').select('address');

      setState(() {
        _locations =
            response.map((location) => location['address'] as String).toList();
        _filteredLocations = _locations; // Initialize filtered list
      });
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
          .where((location) =>
              location.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
                    onTap: () {
                      setState(() {
                        _controller.text = location;
                        _filteredLocations.clear();
                      });
                      _unfocus();
                      widget.onLocationSelected(
                          location); // Pass selected location
                    },
                  );
                },
              ),
            ),
          if (_isFocused &&
              _filteredLocations.isEmpty &&
              !_isLoading &&
              _controller.text.isNotEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('No results found.'),
            ),
        ],
      ),
    );
  }
}
