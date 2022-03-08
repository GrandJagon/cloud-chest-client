class Right {
  final String v;

  Right(this.v);

  String get value => v;
}

class AdminRight extends Right {
  AdminRight(value) : super(value);
}

class ViewRight extends Right {
  ViewRight(value) : super(value);
}

class PostRight extends Right {
  PostRight(value) : super(value);
}

class DeleteRight extends Right {
  DeleteRight(value) : super(value);
}
