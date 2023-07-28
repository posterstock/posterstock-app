import 'package:poster_stock/features/home/data/i_home_page_api.dart';

class MockHomePageApi implements IHomePageApi {
  @override
  Future<Map<String, dynamic>> getPosts(String token, {bool getNewPosts = false}) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    return {
      'data': {
        'posts': [
          {
            'collection': [
              {
                'name': 'The Lord of the Rings: The Fellowship of the Ring',
                'year': 2001,
                'poster':
                    'https://m.media-amazon.com/images/I/A1yy50fuVnL._RI_.jpg',
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                  'avatar':
                      'https://avatars.githubusercontent.com/u/62376075?v=4',
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
                'comments': [
                  {
                    'user': {
                      'name': 'Mikhail Kiva',
                      'username': 'itsmishakiva',
                    },
                    'comment':
                        'I did not hit her, its not true, i did not hit her, i did noot',
                    'time': '13:25',
                  },
                  {
                    'user': {
                      'name': 'Mikhail Kiva',
                      'username': 'itsmishakiva',
                    },
                    'comment': 'Oh, Hi, Mark',
                    'time': '13:25',
                  },
                ],
                'description':
                    "Set in Middle-earth, the story tells of the Dark Lord Sauron, who seeks the One Ring, which contains part of his might, to return to power. The Ring has found its way to the young hobbit Frodo Baggins. The fate of Middle-earth hangs in the balance as Frodo and eight companions (who form the Fellowship of the Ring) begin their journey to Mount Doom in the land of Mordor, the only place where the Ring can be destroyed. The Fellowship of the Ring was financed and distributed by American studio New Line Cinema, but filmed and edited entirely in Jackson's native New Zealand, concurrently with the other two parts of the trilogy.",
              },
              {
                'name': 'Star Wars',
                'year': 1978,
                'poster':
                    'https://i.pinimg.com/originals/ba/2d/2e/ba2d2eb63d696bdbe4ace03d0af26c69.jpg',
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
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
                'description': "Lorem Ipsum dolorum bla bla, great movie",
              },
            ],
          },
          {
            'name': 'The Lord of the Rings: The Fellowship of the Ring',
            'year': 2001,
            'poster':
                'https://m.media-amazon.com/images/I/A1yy50fuVnL._RI_.jpg',
            'user': {
              'name': 'Mikhail Kivaaaaaaaaa',
              'username': 'itsmishakiva',
              'followed': false,
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
            'comments': [
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                    'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                    'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                    'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                    'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
            ],
            'description':
                "Set in Middle-earth, the story tells of the Dark Lord Sauron, who seeks the One Ring, which contains part of his might, to return to power. The Ring has found its way to the young hobbit Frodo Baggins. The fate of Middle-earth hangs in the balance as Frodo and eight companions (who form the Fellowship of the Ring) begin their journey to Mount Doom in the land of Mordor, the only place where the Ring can be destroyed. The Fellowship of the Ring was financed and distributed by American studio New Line Cinema, but filmed and edited entirely in Jackson's native New Zealand, concurrently with the other two parts of the trilogy.",
          },
          {
            'name': 'The Lord of the Rings: The Fellowship of the Ring',
            'year': 2001,
            'poster':
                'https://m.media-amazon.com/images/I/A1yy50fuVnL._RI_.jpg',
            'user': {
              'name': 'Mikhail',
              'username': 'itsmishakiva',
              'followed': true
            },
            'time': '12:03',
            'likes': [
              {
                'name': 'Mikhail Kivaaaaaaaaaa',
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
          {
            'name': 'The Lord of the Rings: The Fellowship of the Ring',
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
            ],
            'comments': [
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment':
                'I did not hit her, its not true, i did not hit her, i did noot',
                'time': '13:25',
              },
              {
                'user': {
                  'name': 'Mikhail Kiva',
                  'username': 'itsmishakiva',
                },
                'comment': 'Oh, Hi, Mark',
                'time': '13:25',
              },
            ],
            'description':
                "Set in Middle-earth, the story tells of the Dark Lord Sauron, who seeks the One Ring, which contains part of his might, to return to power. The Ring has found its way to the young hobbit Frodo Baggins. The fate of Middle-earth hangs in the balance as Frodo and eight companions (who form the Fellowship of the Ring) begin their journey to Mount Doom in the land of Mordor, the only place where the Ring can be destroyed. The Fellowship of the Ring was financed and distributed by American studio New Line Cinema, but filmed and edited entirely in Jackson's native New Zealand, concurrently with the other two parts of the trilogy.",
            'posters': [
              'https://m.media-amazon.com/images/I/A1yy50fuVnL._RI_.jpg',
              'https://m.media-amazon.com/images/I/A1yy50fuVnL._RI_.jpg',
              'https://m.media-amazon.com/images/I/A1yy50fuVnL._RI_.jpg',
            ],
            'titles' : [
              'Joker',
              'The Lord of the Rings',
              'Hello there',
            ]
          },
        ],
      },
    };
  }

  @override
  Future<void> setLike(String token, int id, bool like) {
    // TODO: implement setLike
    throw UnimplementedError();
  }


}
