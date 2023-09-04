







// ArtistGlobalInfo generateTestArtistGlobalInfo(int primaryGenreName, int id) {
//   var primaryGenre = Genre(primaryGenreName.toString());
//   return ArtistGlobalInfo(Uri.parse(''), id.toString(), id.toString(), [primaryGenre]);
// }
import 'dart:io';

void main() async {
  var list = [5];
  await changelist(list);
  print(list[0]);
}


Future changelist(List<int> list) async {
  sleep(Duration(seconds:2));
  list[0] = 1;
}