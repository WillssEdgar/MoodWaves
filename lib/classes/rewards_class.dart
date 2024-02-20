

class Rewards {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final int points;

  Rewards({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.points,
  });
}

var sampleRewards = [
  Rewards(
    id: "1",
    title: "Free Coffee",
    description: "Get a free coffee at any of our outlets",
    imageUrl: "assets/images/coffee.jpg",
    points: 100,
  ),
  Rewards(
    id: "2",
    title: "Free Pizza",
    description: "Get a free pizza at any of our outlets",
    imageUrl: "assets/images/pizza.jpg",
    points: 200,
  ),
  Rewards(
    id: "3",
    title: "Free Burger",
    description: "Get a free burger at any of our outlets",
    imageUrl: "assets/images/burger.jpg",
    points: 150,
  ),
  Rewards(
    id: "4",
    title: "Free Ice Cream",
    description: "Get a free ice cream at any of our outlets",
    imageUrl: "assets/images/ice_cream.jpg",
    points: 50,
  ),
  Rewards(
    id: "5",
    title: "Free Donut",
    description: "Get a free donut at any of our outlets",
    imageUrl: "assets/images/donut.jpg",
    points: 75,
  ),
  Rewards(
    id: "6",
    title: "Free Sandwich",
    description: "Get a free sandwich at any of our outlets",
    imageUrl: "assets/images/sandwich.jpg",
    points: 125,
  ),
  Rewards(
    id: "7",
    title: "Free Salad",
    description: "Get a free salad at any of our outlets",
    imageUrl: "assets/images/salad.jpg",
    points: 100,
  ),
  Rewards(
    id: "8",
    title: "Free Fries",
    description: "Get a free fries at any of our outlets",
    imageUrl: "assets/images/fries.jpg",
    points: 75,
  ),
  Rewards(
    id: "9",
    title: "Free Milkshake",
    description: "Get a free milkshake at any of our outlets",
    imageUrl: "assets/images/milkshake.jpg",
    points: 150,
  ),
  Rewards(
    id: "10",
    title: "Free Smoothie",
    description: "Get a free smoothie at any of our outlets",
    imageUrl: "assets/images/smoothie.jpg",
    points: 125 
  ),
];