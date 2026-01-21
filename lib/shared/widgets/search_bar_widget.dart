import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/service/city_search_service.dart';


class SearchBarWidget extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onLocationPressed;
  final String? hintText;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.onLocationPressed,
    this.hintText,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final CitySearchService _citySearchService = CitySearchService();
  
  List<CityResult> _suggestions = [];
  Timer? _debounceTimer;
  bool _isLoading = false;
  bool _showSuggestions = false;

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isNotEmpty) {
      setState(() => _showSuggestions = false);
      FocusScope.of(context).unfocus();
      widget.onSearch(query);
    }
  }

  void _onTextChanged(String value) {
    _debounceTimer?.cancel();
    
    if (value.trim().length >= 2) {
      setState(() => _isLoading = true);
      _debounceTimer = Timer(const Duration(milliseconds: 400), () {
        _searchCities(value);
      });
    } else {
      setState(() {
        _suggestions = [];
        _showSuggestions = false;
        _isLoading = false;
      });
    }
  }

  Future<void> _searchCities(String query) async {
    try {
      final results = await _citySearchService.searchCities(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _showSuggestions = results.isNotEmpty;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _showSuggestions = false;
        });
      }
    }
  }

  void _selectCity(CityResult city) {
    _controller.text = city.name;
    setState(() => _showSuggestions = false);
    FocusScope.of(context).unfocus();
    widget.onSearch(city.name);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Search input
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20),
              
              // Text field
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(fontSize: 15, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: widget.hintText ?? 'Search city...',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    isCollapsed: true,
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _handleSearch(),
                  onChanged: _onTextChanged,
                ),
              ),
              
              // Loading indicator
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              
              // Clear button
              if (_controller.text.isNotEmpty && !_isLoading)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    setState(() {
                      _suggestions = [];
                      _showSuggestions = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Icon(Icons.close, color: Colors.grey[500], size: 20),
                  ),
                ),
              
              // Search button
              GestureDetector(
                onTap: _handleSearch,
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.only(right: 4),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2196F3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.search, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        
        // Suggestions
        if (_showSuggestions && _suggestions.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final city = _suggestions[index];
                return ListTile(
                  leading: Icon(
                    Icons.location_city,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(
                    city.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    city.state != null && city.state!.isNotEmpty
                        ? '${city.state}, ${city.country}'
                        : city.country,
                  ),
                  dense: true,
                  onTap: () => _selectCity(city),
                );
              },
            ),
          ),
      ],
    );
  }
}
