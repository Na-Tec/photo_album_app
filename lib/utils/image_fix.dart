String fixImageUrl(String originalUrl) {
  // Extract the last part (color code) from the placeholder URL
  final color = originalUrl.split('/').last;
  // Replace with Picsum's seed-based URL
  return 'https://picsum.photos/seed/$color/150';
}
