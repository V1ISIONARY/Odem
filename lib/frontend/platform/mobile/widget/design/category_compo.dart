import 'package:flutter/material.dart';

class CategoryCompo extends StatefulWidget {

  final List<String> tags;
  const CategoryCompo(this.tags, {Key? key}) : super(key: key);

  @override
  _CategoryCompoState createState() => _CategoryCompoState();
}

class _CategoryCompoState extends State<CategoryCompo> {

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
            ...widget.tags.map((tag) => _buildCategoryItem(tag)).toList(),
            const SizedBox(width: 15),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 10), 
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5), 
        border: Border.all(
          width: 1,
          color: Colors.white70
        )
      ),
      height: 30, 
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 9,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

}