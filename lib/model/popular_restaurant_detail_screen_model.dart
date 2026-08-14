class PopularRestaurantDetailScreenModel {
  final String image;
  final String name;
  final String location;
  final String time;
  final String deliveryBadge;
  final Map<String, List<Map<String, dynamic>>> menuItems;
  final List<Map<String, String>> categories;

  PopularRestaurantDetailScreenModel({
    required this.image,
    required this.name,
    required this.location,
    required this.time,
    required this.menuItems,
    required this.categories,
    this.deliveryBadge = 'Free delivery on orders above Rs.1000',
  });
}

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
    image: "assets/images/freshelements.png",
    name: "Fresh Elements",
    location: "Pokhara, Nepal",
    time: '10-20 mins delivery',
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
    image: 'assets/images/roadhousecafe.png',
    name: 'Road House Cafe',
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
  PopularRestaurantDetailScreenModel(
    image: 'assets/images/byanjangrestaurant.png',
    name: 'Byanjang Restaurant',
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
    image: 'assets/images/chelithakali.png',
    name: 'CheliThakali',
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
