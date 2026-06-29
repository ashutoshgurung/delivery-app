import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/popular_restaurant_detail_screen_model.dart';
import 'package:food_ordering_app/view/cart_screen.dart';
import 'package:food_ordering_app/view/popular_restaurant_detail_screen.dart';
import 'package:food_ordering_app/viewmodel/addtoCart_view_model.dart';
import 'package:food_ordering_app/viewmodel/favourite_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final favouriteProvider = Provider.of<FavouriteViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),

            // ── Header ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.red),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VhokLayo',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Row(
                            children: [
                              Text('Pokhara', style: TextStyle(fontSize: 13)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Consumer<AddtocartProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.red,
                              size: 28,
                            ),
                            if (provider.cartCount > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${provider.cartCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ── Search bar ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search food, restaurants...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, color: Colors.red),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── Section title ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Restaurants',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            Consumer<FavouriteViewModel>(
              builder: (context, favouriteProvider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final r = restaurants[index];

                    final item = FavouriteModel(
                      image: r.image,
                      title: r.name,
                      subtitle: r.location,
                    );

                    final isFavourite = favouriteProvider.isFavourite(item);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                      child: Image.asset(
                                        r.image,
                                        height: 170,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () {
                                          favouriteProvider.toggleFavourite(
                                            item,
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.12,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isFavourite
                                                ? Icons.favorite_rounded
                                                : Icons
                                                      .favorite_border_outlined,
                                            color: isFavourite
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(r.location),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              top: 148,
                              right: 16,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PopularRestaurantDetailScreen(
                                            restaurant: r,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 42,
                                  width: 42,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 50),

            Container(
              height: 51,
              width: 349,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withValues(alpha: 0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
              ),
              child: Center(
                child: Text(
                  'View all restaurants',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

// ── All restaurant data defined here ────────────────────────
final List<PopularRestaurantDetailScreenModel> restaurants = [
  PopularRestaurantDetailScreenModel(
    image: 'assets/images/pizza.png',
    name: 'The Pizza Place',
    location: 'Pokhara, Nepal',
    time: '20-30 mins delivery',
    deliveryBadge: 'Free delivery on orders above Rs.1000',
    categories: [
      {'title': 'Combo Deals'},
      {'title': 'Classic Pizza'},
      {'title': 'Premium Pizza'},
      {'title': 'Sides'},
      {'title': 'Drinks'},
    ],
    menuItems: {
      'Combo Deals': [
        {
          'image': 'assets/images/kingsdeal.png',
          'name': 'Kings Deal',
          'sub': 'Any medium classic pizza + a chocolate pizza + a pet drink',
          'price': 500,
        },
      ],
      'Classic Pizza': [
        {
          'image': 'assets/images/bbqchicken.png',
          'name': 'BBQ Chicken',
          'sub': 'Pizza coated with BBQ sauce, cheese & grilled chicken',
          'price': 500,
        },
        {
          'image': 'assets/images/bbqbeef.png',
          'name': 'BBQ Beef',
          'sub': 'Pizza coated with BBQ sauce, cheese & topped with beef',
          'price': 500,
        },
        {
          'image': 'assets/images/veggiesupreme.png',
          'name': 'Veggie Supreme',
          'sub': 'Pizza coated with tomato sauce, cheese & vegetable toppings',
          'price': 500,
        },
      ],
      'Premium Pizza': [
        {
          'image': 'assets/images/bbqmega.png',
          'name': 'BBQ Mega',
          'sub': 'BBQ sauce, chicken, meatballs, smoked sausages & pepperoni',
          'price': 750,
        },
        {
          'image': 'assets/images/chickenbali.png',
          'name': 'Chicken Bali',
          'sub': 'Tomato sauce, cheese, grilled chicken, pineapple & mushrooms',
          'price': 750,
        },
        {
          'image': 'assets/images/extravaganzza.png',
          'name': 'ExtraVaganzza',
          'sub':
              'Tomato sauce, cheese, pepper pepperoni, beef, onions & olives',
          'price': 750,
        },
      ],
      'Sides': [
        {
          'image': 'assets/images/chickenwings.png',
          'name': 'Chicken Wings',
          'sub': 'Choose between - 6pcs, 12pcs or 18pcs',
          'price': 350,
        },
        {
          'image': 'assets/images/frenchfries.png',
          'name': 'French Fries',
          'sub': 'Choose between - extra large, large or regular',
          'price': 200,
        },
        {
          'image': 'assets/images/salad.png',
          'name': 'Salad',
          'sub': 'Choose between - Caesar, Avocado or Greek wedge',
          'price': 250,
        },
      ],
      'Drinks': [
        {
          'image': 'assets/images/soda.png',
          'name': 'Soda',
          'sub': 'Choose between a wide range of soda drinks',
          'price': 120,
        },
        {
          'image': 'assets/images/water.png',
          'name': 'Water',
          'sub': 'Choose between - regular or sparkling',
          'price': 80,
        },
      ],
    },
  ),

  PopularRestaurantDetailScreenModel(
    image: 'assets/images/icecream.png',
    name: 'The Icecream Factory',
    location: 'Pokhara, Nepal',
    time: '15-25 mins delivery',
    deliveryBadge: 'Free delivery on orders above Rs.500',
    categories: [
      {'title': 'Sundaes'},
      {'title': 'Cones'},
      {'title': 'Shakes'},
      {'title': 'Drinks'},
    ],
    menuItems: {
      'Sundaes': [
        {
          'image': 'assets/images/icecream.png',
          'name': 'Chocolate Sundae',
          'sub':
              'Rich chocolate ice cream topped with hot fudge & whipped cream',
          'price': 350,
        },
        {
          'image': 'assets/images/icecream.png',
          'name': 'Strawberry Sundae',
          'sub': 'Creamy strawberry ice cream with fresh strawberry sauce',
          'price': 350,
        },
      ],
      'Cones': [
        {
          'image': 'assets/images/icecream.png',
          'name': 'Classic Vanilla Cone',
          'sub': 'Smooth vanilla ice cream in a crispy waffle cone',
          'price': 200,
        },
        {
          'image': 'assets/images/icecream.png',
          'name': 'Double Scoop Cone',
          'sub': 'Choose any two flavours in a large waffle cone',
          'price': 300,
        },
      ],
      'Shakes': [
        {
          'image': 'assets/images/icecream.png',
          'name': 'Oreo Shake',
          'sub': 'Thick shake blended with Oreo cookies & vanilla ice cream',
          'price': 400,
        },
        {
          'image': 'assets/images/icecream.png',
          'name': 'Mango Shake',
          'sub': 'Fresh mango blended with creamy mango ice cream',
          'price': 380,
        },
      ],
      'Drinks': [
        {
          'image': 'assets/images/soda.png',
          'name': 'Soda',
          'sub': 'Choose between a wide range of soda drinks',
          'price': 120,
        },
        {
          'image': 'assets/images/water.png',
          'name': 'Water',
          'sub': 'Regular or sparkling',
          'price': 80,
        },
      ],
    },
  ),

  PopularRestaurantDetailScreenModel(
    image: 'assets/images/burger.png',
    name: 'Burger King',
    location: 'Pokhara, Nepal',
    time: '20-35 mins delivery',
    deliveryBadge: 'Free delivery on orders above Rs.800',
    categories: [
      {'title': 'Burgers'},
      {'title': 'Combos'},
      {'title': 'Sides'},
      {'title': 'Drinks'},
    ],
    menuItems: {
      'Burgers': [
        {
          'image': 'assets/images/burger.png',
          'name': 'Classic Whopper',
          'sub':
              'Flame-grilled beef patty with lettuce, tomato, mayo & pickles',
          'price': 550,
        },
        {
          'image': 'assets/images/burger.png',
          'name': 'Crispy Chicken Burger',
          'sub': 'Crispy fried chicken fillet with coleslaw & spicy mayo',
          'price': 500,
        },
        {
          'image': 'assets/images/burger.png',
          'name': 'Veggie Burger',
          'sub': 'Plant-based patty with fresh veggies & house sauce',
          'price': 450,
        },
      ],
      'Combos': [
        {
          'image': 'assets/images/burger.png',
          'name': 'Whopper Combo',
          'sub': 'Classic Whopper + large fries + large drink',
          'price': 850,
        },
        {
          'image': 'assets/images/burger.png',
          'name': 'Chicken Combo',
          'sub': 'Crispy Chicken Burger + medium fries + medium drink',
          'price': 750,
        },
      ],
      'Sides': [
        {
          'image': 'assets/images/frenchfries.png',
          'name': 'French Fries',
          'sub': 'Choose between - large, medium or small',
          'price': 180,
        },
        {
          'image': 'assets/images/chickenwings.png',
          'name': 'Chicken Nuggets',
          'sub': 'Choose between - 6pcs, 9pcs or 12pcs',
          'price': 300,
        },
      ],
      'Drinks': [
        {
          'image': 'assets/images/soda.png',
          'name': 'Soda',
          'sub': 'Choose between a wide range of soda drinks',
          'price': 120,
        },
        {
          'image': 'assets/images/water.png',
          'name': 'Water',
          'sub': 'Regular or sparkling',
          'price': 80,
        },
      ],
    },
  ),

  PopularRestaurantDetailScreenModel(
    image: 'assets/images/thecoffeehouse.png',
    name: 'The Coffee House',
    location: 'Pokhara, Nepal',
    time: '10-20 mins delivery',
    deliveryBadge: 'Free delivery on orders above Rs.600',
    categories: [
      {'title': 'Hot Coffee'},
      {'title': 'Cold Coffee'},
      {'title': 'Snacks'},
      {'title': 'Drinks'},
    ],
    menuItems: {
      'Hot Coffee': [
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Cappuccino',
          'sub': 'Espresso with steamed milk foam, served hot',
          'price': 280,
        },
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Latte',
          'sub': 'Espresso with smooth steamed milk & light foam',
          'price': 300,
        },
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Americano',
          'sub': 'Double espresso with hot water, bold & rich',
          'price': 250,
        },
      ],
      'Cold Coffee': [
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Iced Latte',
          'sub': 'Espresso over ice with cold milk & light cream',
          'price': 320,
        },
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Cold Brew',
          'sub': 'Slow-steeped cold brew, smooth & low acidity',
          'price': 350,
        },
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Mocha Frappe',
          'sub': 'Blended coffee with chocolate & whipped cream',
          'price': 380,
        },
      ],
      'Snacks': [
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Croissant',
          'sub': 'Buttery, flaky croissant — plain or with filling',
          'price': 220,
        },
        {
          'image': 'assets/images/thecoffeehouse.png',
          'name': 'Chocolate Muffin',
          'sub': 'Soft chocolate muffin baked fresh daily',
          'price': 180,
        },
      ],
      'Drinks': [
        {
          'image': 'assets/images/soda.png',
          'name': 'Soda',
          'sub': 'Choose between a wide range of soda drinks',
          'price': 120,
        },
        {
          'image': 'assets/images/water.png',
          'name': 'Water',
          'sub': 'Regular or sparkling',
          'price': 80,
        },
      ],
    },
  ),
];
