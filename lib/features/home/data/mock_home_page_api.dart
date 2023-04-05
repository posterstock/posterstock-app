import 'package:poster_stock/features/home/data/i_home_page_api.dart';

class MockHomePageApi implements IHomePageApi {
  @override
  Future<Map<String, dynamic>> getPosts(String token, int offset) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return {
      'data': {
        'posts': [
          {
            'name': 'The Lord of the Rings: The Fellowship of the Ring',
            'year': 2001,
            'poster':
                'https://upload.wikimedia.org/wikipedia/en/8/8a/The_Lord_of_the_Rings_The_Fellowship_of_the_Ring_%282001%29.jpg',
            'user': {
              'name': 'Mikhail Kiva',
              'username': 'itsmishakiva',
              'followed': true
            },
            'time': '12:03',
            'likes': [
              {
                'name': 'Mikhail Kiva',
                'username': 'itsmishakiva',
              },
              {
                'name': 'Ian Rakeda',
                'username': 'ianrakeda',
              },
              {
                'name': 'User',
                'username': 'user',
              },
              {
                'name': 'null',
                'username': 'null',
              },
            ],
            'description':
                "Set in Middle-earth, the story tells of the Dark Lord Sauron, who seeks the One Ring, which contains part of his might, to return to power. The Ring has found its way to the young hobbit Frodo Baggins. The fate of Middle-earth hangs in the balance as Frodo and eight companions (who form the Fellowship of the Ring) begin their journey to Mount Doom in the land of Mordor, the only place where the Ring can be destroyed. The Fellowship of the Ring was financed and distributed by American studio New Line Cinema, but filmed and edited entirely in Jackson's native New Zealand, concurrently with the other two parts of the trilogy.",
          },
        ],
      },
    };
  }
}
