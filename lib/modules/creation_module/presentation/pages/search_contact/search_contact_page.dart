import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';
import 'package:messenger_mobile/core/utils/search_engine.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/creation_module/data/datasources/creation_module_datasource.dart';
import 'package:messenger_mobile/modules/creation_module/data/repositories/creation_module_repository.dart';
import 'package:messenger_mobile/modules/creation_module/domain/repositories/creation_module_repository.dart';
import 'package:messenger_mobile/modules/creation_module/domain/usecases/search_contacts.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/search_contact_cubit/search_contact_cubit.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contact_cell.dart';

class SearchContactPage extends StatefulWidget {
  
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => SearchContactPage());
  }
  
  @override
  _SearchContactPageState createState() => _SearchContactPageState();
}

class _SearchContactPageState extends State<SearchContactPage> implements SearchEngingeDelegate {
  
  // MARK: - Props

  SearchBar searchBar;
  SearchEngine searchEngine;
  PaginatedScrollController scrollController = PaginatedScrollController();
  SearchContactCubit _searchContactCubit;

  // MARK: - Life-Cycle

  @override
  void initState() {
    searchEngine = SearchEngine(delegate: this);
    searchBar = new SearchBar(
      inBar: true,
      closeOnSubmit: false,
      clearOnSubmit: false,
      setState: print,
      onSubmitted: (String text) {
        _searchContactCubit.showLoading(isPagination: false);
        searchEngine.onTextChanged(text);
      },
      buildDefaultAppBar: buildAppBar,
      onChanged: (String newStr) {
        _searchContactCubit.showLoading(isPagination: false);
        searchEngine.onTextChanged(newStr);
      }
    );

    searchBar.isSearching.value = true;

    scrollController.addListener(() {
      _onScroll(); 
    });

    _searchContactCubit = SearchContactCubit(
      searchContacts: SearchContacts(CreationModuleRepositoryImpl(
        networkInfo: sl(),
        dataSource: CreationModuleDataSourceImpl(
          client: sl()
        )
       ))
    );

    super.initState();
  }


  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchContactCubit>(
      create: (context) => _searchContactCubit,
      child: Scaffold(
        appBar: searchBar.build(context),
        body: BlocConsumer<SearchContactCubit, SearchContactState>(
          listener: (context, SearchContactState state) {
            if (state is SearchContactsError) {
              ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message))
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
          builder: (context, SearchContactState state) {
            return ListView.separated(
              controller: scrollController,
              itemBuilder: (context, int index) {
                if (
                  state is SearchContactsLoading && 
                  (!state.isPagination || 
                    index >= state.contacts.data.length
                  )) {
                  return CellShimmerItem(circleSize: 35,);
                } else {
                  return ContactCell(
                    contactItem: state.contacts.data[index],
                    onTrilinIconTapped: () async {
                      print("HERE START CHAT");
                    }
                  );
                }
              }, 
              separatorBuilder: (_, int index) => Divider(), 
              itemCount: state.contacts.data.length + (state is SearchContactsLoading ? 10 : 0)
            );
          }, 
        )
      ),
    );
  }

  // MARK: - UI Helpers

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Пользователи'),
      actions: [
        searchBar.getSearchAction(context)
      ]
    );
  }

  void _onScroll () {
    var state = _searchContactCubit.state;
    if (scrollController.isPaginated && !(state is SearchContactsLoading) && !state.contacts.paginationData.hasNextPage) {
      _searchContactCubit.search(
        phoneNumber: searchBar.controller.text.trim(),
        isPagination: true,
      );
    }
  }

  @override
  void startSearching({
    String text
  }) {
    _searchContactCubit.search(
      phoneNumber: text.trim(),
      isPagination: false,
    );
  }
}