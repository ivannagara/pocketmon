import 'home/repository/home_repository.dart';

abstract class Repository {
  HomeRepository get getHomeRepository;
}

class HTTPRepository implements Repository {
  @override
  HomeRepository get getHomeRepository => HomeHTTPRepository();
}
