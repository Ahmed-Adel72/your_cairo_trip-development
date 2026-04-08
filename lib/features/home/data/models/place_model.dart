class PlaceModel {
  final String imageUrl;
  final String name;

  const PlaceModel({required this.imageUrl, required this.name});
}

class PlacesData {
  PlacesData._();

  static const List<PlaceModel> cairoPlaces = [
    // 1 - الأهرامات
    PlaceModel(name: 'أهرامات الجيزة', imageUrl: 'assets/images/pyramids.jpg'),

    // 2 - أبو الهول
    PlaceModel(name: 'أبو الهول', imageUrl: 'assets/images/sphinx.jpg'),

    // 3 - الجامع الأزهر
    PlaceModel(name: 'الجامع الأزهر', imageUrl: 'assets/images/azhar.jpg'),

    // 4 - خان الخليلي
    PlaceModel(name: 'خان الخليلي', imageUrl: 'assets/images/khaan.jpg'),

    // 5 - برج القاهرة
    PlaceModel(name: 'برج القاهرة', imageUrl: 'assets/images/cairo_tower.jpg'),

    // 6 - المتحف المصري
    PlaceModel(
      name: 'المتحف المصري',
      imageUrl: 'assets/images/the_Grand_Egyptian_Museum.jpg',
    ),
  ];
}
