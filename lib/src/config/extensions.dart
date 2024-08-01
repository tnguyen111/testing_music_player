extension MoveElement<T> on List<T> {
  void move(int from, int to) => insert(to, removeAt(from));
}