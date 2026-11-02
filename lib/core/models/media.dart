/// Asset paths exported from the GLORIES artboards. Only frames that embed a
/// real bitmap are used; the rest of the design ships placeholder fills.
abstract final class AppArt {
  static const String album01 = 'assets/images/album_01.png';
  static const String album02 = 'assets/images/album_02.png';
  static const String album03 = 'assets/images/album_03.png';
  static const String artist01 = 'assets/images/artist_01.png';
  static const String artist02 = 'assets/images/artist_02.png';
  static const String catDancing = 'assets/images/cat_dancing.png';
  static const String catElectronic = 'assets/images/cat_electronic.png';
  static const String catHipHop = 'assets/images/cat_hiphop.png';

  static const List<String> albums = <String>[album01, album02, album03];
  static const List<String> categories = <String>[
    catDancing,
    catHipHop,
    catElectronic,
  ];
  static const List<String> artists = <String>[artist01, artist02];

  static String album(int index) => albums[index % albums.length];
  static String category(int index) => categories[index % categories.length];
  static String artist(int index) => artists[index % artists.length];
}

class Track {
  const Track({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.art,
    this.isDownloaded = false,
  });

  final String id;
  final String title;
  final String artist;
  final Duration duration;
  final String art;
  final bool isDownloaded;
}

enum CollectionKind { playlist, album, dailyMix, radio }

/// Anything that owns an ordered list of tracks: playlist, album, daily mix or
/// radio station. They share one detail screen, so they share one model.
class Collection {
  const Collection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.kind,
    required this.art,
    required this.tracks,
    this.backLabel = 'Library',
  });

  final String id;
  final String title;
  final String subtitle;
  final CollectionKind kind;
  final String art;
  final List<Track> tracks;
  final String backLabel;
}

class Artist {
  const Artist({required this.id, required this.name, required this.art});

  final String id;
  final String name;
  final String art;
}

class Category {
  const Category({required this.id, required this.title, required this.art});

  final String id;
  final String title;
  final String art;
}
