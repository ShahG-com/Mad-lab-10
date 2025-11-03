import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll & Sliver Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  // Random pics from Picsum
  final List<String> images = List.generate(
    6,
    (index) => 'https://picsum.photos/seed/${index + 1}/600/400',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // --- SliverAppBar (Collapsing Header)
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Explore the View'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://picsum.photos/seed/nature/900/600',
                    fit: BoxFit.cover,
                  ),
                  Container(color: Colors.black45),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      "Welcome Traveler 🌍",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Grid Section
          SliverPadding(
            padding: EdgeInsets.all(8),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          images[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          color: Colors.black54,
                          padding: EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          child: Text(
                            "Photo #${index + 1}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                childCount: images.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
            ),
          ),

          // --- List Section
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/user${index + 10}/100/100',
                    ),
                  ),
                  title: Text('Traveler ${index + 1}'),
                  subtitle: Text('Enjoying the journey ✈️'),
                  trailing: Icon(Icons.favorite_border),
                );
              },
              childCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}
