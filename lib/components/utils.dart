bool checkCollision(player, block) {
  final playerX = player.position.x;
  final playerY = player.position.y;
  final playerWidth = player.width;
  final playerHeight = player.height;

  final blockX = block.x;
  final blockY = block.y;
  final blockwidth = block.width;
  final blockheight = block.height;

  final fixeX = player.scale.x < 0 ? playerX - playerWidth : playerX;

  return (playerY < blockY + blockheight &&
      playerY + playerHeight > blockY &&
      fixeX < blockX + blockwidth &&
      fixeX + playerWidth > blockX);
}
