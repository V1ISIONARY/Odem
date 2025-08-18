import 'package:flutter/material.dart';
import 'package:odem/backend/properties/local_properties.dart';

class CategoryCard extends StatefulWidget {
  final String selectedCategory;
  final Function(String) onCategoryChanged;

  const CategoryCard({
    Key? key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  }) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  final localProperties = LocalProperties();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 30,
      child: ValueListenableBuilder<List<dynamic>>(
        // listen to the ValueNotifier of extensions
        valueListenable: localProperties.installedExtension,
        builder: (context, extensions, _) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 15),
                _buildCategoryItem('All'),
                _buildCategoryItem('Downloads'),
                ...extensions
                    .map((ext) => _buildCategoryItem(ext.exName))
                    .toList(),
                const SizedBox(width: 15),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(String label) {
    final bool isSelected = widget.selectedCategory == label;

    return GestureDetector(
      onTap: () {
        widget.onCategoryChanged(label);
        setState(() {}); // re-render selected state
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: isSelected ? Colors.white : Colors.white70,
          ),
        ),
        height: 30,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white70,
              fontSize: 9,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}