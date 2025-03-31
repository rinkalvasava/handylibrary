import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  final String username;
  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, String>> topPicks = [
    {
      "name": "Atomic Habits",
      "author": "James Clear",
      "img": "assets/images/book1.png"
    },
    {
      "name": "The Art of Letting Go",
      "author": "Nick Trenton",
      "img": "assets/images/book2.png"
    },
    {
      "name": "The Practicing Mind",
      "author": "Thomas M. Strener",
      "img": "assets/images/book3.png"
    },
    {
      "name": "Think and Grow Rich",
      "author": "Napoleon Hill",
      "img": "assets/images/book4.png"
    },
    {
      "name": "Pollyanna",
      "author": "Eleanor H. Porter",
      "img": "assets/images/book5.png"
    },
    {
      "name": "What I Know for Sure",
      "author": "Oprah Winfrey",
      "img": "assets/images/book6.png"
    },
    {
      "name": "The Alchemist",
      "author": "Paulo Coelho",
      "img": "assets/images/book7.png"
    },
  ];

  final List<String> categories = [
    "Select your Degree",
    "CS/IT",
    "B.E",
    "BCA",
    "MCA",
    "BSC/IT",
    "MSC/IT"
  ];
  String selectedCategory = "Select your Degree";

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Align(
                    child: Transform.scale(
                      scale: 1.5,
                      origin: Offset(0, media.width * 0.8),
                      child: Container(
                        width: media.width * 0.68,
                        height: media.width * 0.95,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 51, 153, 255),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(140),
                            bottomLeft: Radius.circular(140),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: media.width * 0.15,
                    child: const Text(
                      'Our Latest Picks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  /// **Carousel Slider**
                  Padding(
                    padding: EdgeInsets.only(top: media.width * 0.25),
                    child: SizedBox(
                      height: media.width * 0.9,
                      child: CarouselSlider.builder(
                        itemCount: topPicks.length,
                        itemBuilder: (context, index, realIndex) {
                          var iObj = topPicks[index];
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(0, 2),
                                      blurRadius: 4,
                                    )
                                  ]),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.asset(
                                      iObj["img"].toString(),
                                      height: media.width * 0.5,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  iObj["name"]!,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  iObj["author"]!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 1,
                          enlargeCenterPage: true,
                          viewportFraction: 0.5,
                          enlargeFactor: 0.4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              /// **Dropdown List**
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                child: DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  icon: const Icon(Icons.menu_book_rounded, color: Colors.blue),
                  dropdownColor: Colors.white,
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(
                        category,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCategory = newValue!;
                    });
                  },
                ),
              ),

              /// **Content Sections**
              buildSection("Latest News",
                  "News Content for $selectedCategory Goes Here"),
              buildSection("Reference Books", "Reference Books Goes Here"),
              buildSection("Class Materials", "Class Materials Goes Here"),
              buildSection("Research Papers", "Research Papers Goes Here"),
              buildSection("Novels", "Novels Goes Here"),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// **Helper Function to Create Sections**
  Widget buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                content,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
