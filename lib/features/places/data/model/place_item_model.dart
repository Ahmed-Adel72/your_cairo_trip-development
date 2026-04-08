class PlaceItemModel {
  final String title;
  final String description;
  final String imageUrl;
  final bool isFree;
  final String price;
  final String workingHours;
  final List<String> activities;

  const PlaceItemModel({
    required this.title,
    required this.description,
    required this.imageUrl,
    this.isFree = true,
    this.price = 'مجاني',
    this.workingHours = ' ',
    this.activities = const [],
  });
}

// ─── Static Data ──────────────────────────────────────────────────────────────

class PlacesListData {
  PlacesListData._();

  static const List<PlaceItemModel> cairoPlaces = [
    // 1 - الأزهر
    PlaceItemModel(
      title: 'المشي في الأزهر / المساجد الكبيرة',
      description: 'دخول عام، لكن قد تكون هناك رسوم لبعض المناطق',
      imageUrl: 'assets/images/azhar.jpg',
      isFree: true,
      price: 'مجاني',
      workingHours: 'AM 12:00 - AM 9:00',
      activities: [
        'الاستمتاع بالإطلالة البانورامية',
        'استكشاف المساجد التاريخية',
        'زيارة المعبر الفكري',
      ],
    ),

    // 2 - خان الخليلي
    PlaceItemModel(
      title: 'خان الخليلي',
      description: 'دخول السوق مجاني، لكن المشتريات بمصاريف',
      imageUrl: 'assets/images/khaan.jpg',
      isFree: true,
      price: 'مجاني',
      workingHours: 'AM 10:00 - PM 11:00',
      activities: [
        'التسوق في الأسواق التراثية',
        'تذوق المأكولات الشعبية',
        'التصوير في الأزقة التاريخية',
      ],
    ),

    // 3 - الأهرامات
    PlaceItemModel(
      title: 'أهرامات الجيزة',
      description: 'رسوم دخول تختلف للمصريين والأجانب',
      imageUrl: 'assets/images/pyramids.jpg',
      isFree: false,
      price: '150 EGP',
      workingHours: 'AM 8:00 - PM 5:00',
      activities: [
        'مشاهدة الأهرامات الثلاثة',
        'زيارة أبو الهول',
        'ركوب الجمال حول الأهرامات',
      ],
    ),

    // 4 - أبو الهول
    PlaceItemModel(
      title: 'أبو الهول',
      description: 'رسوم دخول تختلف للمصريين والأجانب',
      imageUrl: 'assets/images/sphinx.jpg',
      isFree: false,
      price: '100 EGP',
      workingHours: 'AM 8:00 - PM 5:00',
      activities: [
        'مشاهدة تمثال أبو الهول عن قرب',
        'التصوير مع الأهرامات في الخلفية',
        'الاستماع لشرح المرشد السياحي',
      ],
    ),

    // 5 - المتحف المصري
    PlaceItemModel(
      title: 'المتحف المصري',
      description: 'رسوم دخول تختلف للمصريين والأجانب',
      imageUrl: 'assets/images/the_Grand_Egyptian_Museum.jpg',
      isFree: false,
      price: '200 EGP',
      workingHours: 'AM 9:00 - PM 5:00',
      activities: [
        'مشاهدة مقتنيات توت عنخ آمون',
        'زيارة قاعة المومياوات',
        'استكشاف الآثار الفرعونية',
      ],
    ),

    // 6 - برج القاهرة
    PlaceItemModel(
      title: 'برج القاهرة',
      description: 'رسوم دخول للصعود لأعلى البرج والاستمتاع بالمنظر',
      imageUrl: 'assets/images/cairo_tower.jpg',
      isFree: false,
      price: '150 EGP',
      workingHours: 'AM 9:00 - AM 12:00',
      activities: [
        'الاستمتاع بالإطلالة البانورامية',
        'استكشاف الطابق الدوار',
        'زيارة المطعم الفكري',
      ],
    ),
  ];
}
