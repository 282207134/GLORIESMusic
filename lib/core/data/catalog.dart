import '../models/media.dart';

/// Static stand-in for a music backend. Every string here is copy that appears
/// in the GLORIES artboards, so the running app reads like the design.
abstract final class Catalog {
  static Track _t(
    int i,
    String title,
    String artist,
    int seconds, {
    bool downloaded = false,
  }) => Track(
    id: 't$i',
    title: title,
    artist: artist,
    duration: Duration(seconds: seconds),
    art: AppArt.album(i),
    isDownloaded: downloaded,
  );

  static final List<Track> chart = <Track>[
    _t(0, 'This is me', 'Sia', 214, downloaded: true),
    _t(1, 'Rewrite The Star', 'James Arthur', 197),
    _t(2, 'Fire On Fire', 'Sam Smith', 203),
    _t(0, "I'll never love again", 'Tom Holland', 188),
    _t(1, 'Perfect', 'Edsheeran', 263),
    _t(2, 'Next to me', 'Sia', 192),
  ];

  static final List<Track> fresh = <Track>[
    _t(1, 'We are born', 'Hay, Le Klint, Muuto', 226),
    _t(2, 'Party Monster', 'Oluce, Foscarini', 174),
    _t(0, 'Wall Lamps', 'Charlie Puh', 241),
  ];

  static final List<Track> bieber = <Track>[
    _t(0, 'Lonely', 'Justin Bieber', 150),
    _t(1, 'Baby (feat. Ludacris)', 'Justin Bieber', 216),
    _t(2, 'Yummy', 'Justin Bieber', 190),
    _t(0, 'Love Youself', 'Justin Bieber', 232),
    _t(1, 'What do you mean?', 'Justin Bieber', 175),
    _t(2, 'Boyfriends', 'Justin Bieber', 168),
    _t(0, 'As Long As You Love Me', 'Justin Bieber', 234),
  ];

  static final List<Track> mix = <Track>[...chart, ...fresh];

  static final Collection dailyMix = Collection(
    id: 'mix1',
    title: 'Daily Mix 1',
    subtitle: 'Tyler, Sia, Ariel Pink and more',
    kind: CollectionKind.dailyMix,
    art: AppArt.album01,
    tracks: mix,
  );

  static final Collection playlist = Collection(
    id: 'pl1',
    title: 'Daily Mix 1',
    subtitle: 'Tyler, Sia, Ariel Pink and more',
    kind: CollectionKind.playlist,
    art: AppArt.album02,
    tracks: mix,
    backLabel: 'Playlist',
  );

  static final Collection radio = Collection(
    id: 'ra1',
    title: 'Office DJ',
    subtitle: 'Capi Music',
    kind: CollectionKind.radio,
    art: AppArt.album03,
    tracks: chart,
    backLabel: 'Back',
  );

  static final Collection dancing = Collection(
    id: 'cat-dancing',
    title: 'Dancing',
    subtitle: 'Lonely · Sep 19, 2020',
    kind: CollectionKind.album,
    art: AppArt.catDancing,
    tracks: bieber,
    backLabel: 'Back',
  );

  static const List<Collection> recentlyPlayed = <Collection>[
    Collection(
      id: 'rp1',
      title: 'Office DJ',
      subtitle: 'Capi Music',
      kind: CollectionKind.playlist,
      art: AppArt.album01,
      tracks: [],
    ),
    Collection(
      id: 'rp2',
      title: 'Easy Rock',
      subtitle: 'Various Artists',
      kind: CollectionKind.playlist,
      art: AppArt.album02,
      tracks: [],
    ),
    Collection(
      id: 'rp3',
      title: 'A Peaceful Day',
      subtitle: "Let's enjoy the soft gentle piano music for relax.",
      kind: CollectionKind.playlist,
      art: AppArt.album03,
      tracks: [],
    ),
  ];

  static const List<Collection> newReleases = <Collection>[
    Collection(
      id: 'nr1',
      title: 'Look Back At It',
      subtitle: 'Sander W',
      kind: CollectionKind.album,
      art: AppArt.album01,
      tracks: [],
    ),
    Collection(
      id: 'nr2',
      title: 'Seven- EP',
      subtitle: 'Martin Garixx',
      kind: CollectionKind.album,
      art: AppArt.album02,
      tracks: [],
    ),
    Collection(
      id: 'nr3',
      title: 'Dillion Francis',
      subtitle: 'Sander W',
      kind: CollectionKind.album,
      art: AppArt.album03,
      tracks: [],
    ),
  ];

  static const List<Category> categories = <Category>[
    Category(id: 'c1', title: 'Dancing', art: AppArt.catDancing),
    Category(id: 'c2', title: 'Hip-Hop', art: AppArt.catHipHop),
    Category(id: 'c3', title: 'Ballad', art: AppArt.catElectronic),
    Category(id: 'c4', title: 'Opera', art: AppArt.catDancing),
    Category(id: 'c5', title: 'Country', art: AppArt.catHipHop),
    Category(id: 'c6', title: 'Feel Good', art: AppArt.catElectronic),
  ];

  static const List<Artist> artists = <Artist>[
    Artist(id: 'a1', name: 'Justin Bieber', art: AppArt.artist01),
    Artist(id: 'a2', name: 'The Weeknd', art: AppArt.artist02),
  ];

  static const List<String> genres = <String>[
    'Alternative',
    'New wave',
    'Soul',
    'Darkcore Jungle',
    'Garage blues',
    'Electronic',
    'Blue',
    'Progressive house',
    'R&B and soul',
  ];

  static const List<String> searchSuggestions = <String>[
    'justin biber',
    'juice wrld',
    'joji',
    'j. cole',
    'jason derulo',
  ];

  /// Lyric lines for the Now Playing #3 sheet; the first is the active line.
  static const List<String> lyrics = <String>[
    'Oh, and do I deserve to be',
    'Is that the question?',
    'And if so, if so, who answers, who answers',
  ];

  static const List<String> equalizerBands = <String>[
    '0Hz',
    '160Hz',
    '400Hz',
    '1KHz',
    '2.4KHz',
    '15KHz',
    '19KHz',
  ];

  /// Two curves, matching the pink/blue polylines in Setting #2.
  static const List<double> equalizerLeft = <double>[
    0.18,
    0.72,
    0.34,
    0.28,
    0.52,
    0.14,
    0.10,
    0.86,
    0.30,
    0.58,
  ];
  static const List<double> equalizerRight = <double>[
    0.28,
    0.52,
    0.12,
    0.24,
    0.30,
    0.62,
    0.94,
    0.82,
    0.90,
    0.44,
  ];

  static const String userName = 'Ackerman';
  static const String userPhone = '+7 (812) 982-32-32';
  static const String userCity = 'Saint Petersburg';

  /// Top line then second line, exactly as the Profile artboard stacks them —
  /// the first column leads with the number, the other two lead with the label.
  static const List<(String, String)> userStats = <(String, String)>[
    ('90 030', 'Followers'),
    ('Songs', '120'),
    ('Videos', '66'),
  ];
}
