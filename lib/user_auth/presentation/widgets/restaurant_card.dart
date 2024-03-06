import 'package:flutter/material.dart';
//import 'package:hueca_movil/features/user_auth/presentation/widgets/restaurant_info.dart';

class RestaurantCard extends StatelessWidget {
  final String id;
  final String name;
  final String description;
  final String address;
  final double rating;
  final String imageUrl;

  const RestaurantCard({
    Key? key,
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.rating,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) =>
          //         RestaurantInfo(id: id), // Pasa el ID al nuevo widget
          //   ),
          // );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Card(
            clipBehavior: Clip.antiAlias,
            elevation: 4.0,
            shadowColor: Colors.grey.withOpacity(0.5),
            color: Colors.white,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0,
                      horizontal:
                          15.0), // Ajusta el valor del padding según necesites
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        8.0), // Ajusta el radio del borde para controlar el redondeo
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      height: 150.0,
                      width: double.infinity,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        address,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 24,
                          ),
                          Text(
                            '$rating',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
