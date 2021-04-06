import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({
    Key/*?*/ key,
    this.color,
    this.scale = 0.6,
    this.zeroPad = false,
    this.dir = 'assets/images/',
    this.name = 'ic_launcher-playstore.png',
  })  : path = dir + name,
        super(key: key);

  final String dir;
  final String name;
  final String path;
  final double scale;
  final bool zeroPad;
  final Color/*?*/ color;

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
    if (zeroPad) {
      return Image.asset(path, color: color);
    } else {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Image.asset(path, color: color, height: MediaQuery.of(context).size.width * scale),
      );
    }
=======
    if (!isLogo) return Image.asset(Images.imgRoot + name);
    final Color _accent = Theme.of(context).accentColor;
    final Color _primary = Theme.of(context).primaryColor;
    return Container(
      margin: EdgeInsets.all(isLogo ? 30 : 0),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(shape: BoxShape.circle, color: _primary, border: Border.all(width: 3, color: _accent)),
      child: CircleAvatar(radius: radius, backgroundColor: _primary, child: SvgPicture.asset(Images.imgRoot + name, color: _accent)),
    );
>>>>>>> Stashed changes
  }
}
