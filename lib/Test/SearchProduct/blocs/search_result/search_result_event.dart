abstract class SearchResultEvent {}

class SearchResultFetchEvent extends SearchResultEvent {
  final String query;
  SearchResultFetchEvent({required this.query});
}

class SearchResultClearEvent extends SearchResultEvent {}
