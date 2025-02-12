import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  const CategoryCard({Key? key}) : super(key: key);

  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  String selectedCategory = 'Manhwa'; 

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            const SizedBox(width: 15),
            _buildCategoryItem('Manhwa'),
            _buildCategoryItem('Action'),
            _buildCategoryItem('Adventure'),
            _buildCategoryItem('Fantasy'),
            _buildCategoryItem('Shounen'),
            _buildCategoryItem('Mamamu'),
            _buildCategoryItem('Pulko'),
            _buildCategoryItem('Banana'),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String label) {
    bool isSelected = selectedCategory == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = label; 
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: isSelected ? Colors.blue : Colors.white70,
          ),
        ),
        height: 30,
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white70, // Change text color
              fontSize: 9,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}