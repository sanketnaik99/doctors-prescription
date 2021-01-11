import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_prescription/components/detail_row.dart';
import 'package:flutter/material.dart';

class MedicineDetailCard extends StatelessWidget {
  final String name;
  final String id;
  final String image;
  final String category;
  final String weight;
  bool hasAddedReminder;
  final Function showBottomSheet;

  MedicineDetailCard({
    this.name,
    this.id,
    this.image,
    this.category,
    this.weight,
    this.hasAddedReminder,
    this.showBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: CachedNetworkImage(
                    imageUrl: this.image,
                    placeholder: (context, url) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailRow(
                        title: 'Name',
                        data: this.name,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DetailRow(
                        title: 'Category',
                        data: this.category,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DetailRow(
                        title: 'Weight',
                        data: this.weight,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
