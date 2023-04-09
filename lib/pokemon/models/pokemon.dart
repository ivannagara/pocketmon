import 'package:equatable/equatable.dart';

class Pokemon extends Equatable {
  const Pokemon({
    this.name = '',
  });
  
  final String name;

  @override
  List<Object?> get props => [
        name,
      ];
}
