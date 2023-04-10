import 'package:equatable/equatable.dart';

class NextEvolution implements Equatable {
  const NextEvolution({
    this.num = '',
    this.name = '',
  });

  factory NextEvolution.fromJson(Map<String, dynamic> json) {
    final num = json['num'] as String?;
    final name = json['name'] as String?;
    return NextEvolution(
      num: num ?? '',
      name: name ?? '',
    );
  }

  final String num;
  final String name;
  @override
  List<Object?> get props => [
        num,
        name,
      ];

  @override
  bool? get stringify => null;
}
