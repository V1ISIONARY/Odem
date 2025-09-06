import 'package:flutter/material.dart';
import 'package:odem/backend/properties/local_properties.dart';

class CategoryCard extends StatefulWidget {
  final Function(String) onCategoryChanged;
  final String selectedCategory;

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
                  .map((ext) => _buildCategoryItem(ext.exName, value: ext.key))
                  .toList(),
                const SizedBox(width: 15),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryItem(String label, {String? value}) {
    final categoryValue = value ?? label; 
    final bool isSelected = widget.selectedCategory == categoryValue;

    return GestureDetector(
      onTap: () {
        widget.onCategoryChanged(categoryValue); 
        setState(() {});
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