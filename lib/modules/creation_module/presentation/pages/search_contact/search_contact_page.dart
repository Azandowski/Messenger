import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/bloc/open_chat_cubit/open_chat_listener.dart';
import 'package:messenger_mobile/modules/groupChat/domain/usecases/create_chat_group.dart';
import '../../../../../core/utils/paginated_scroll_controller.dart';
import '../../../../../core/utils/search_engine.dart';
import '../../../../../core/utils/snackbar_util.dart';
import '../../../../../core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import '../../../../chat/presentation/chats_screen/pages/chat_screen_import.dart';
import '../../../data/datasources/creation_module_datasource.dart';
import '../../../data/repositories/creation_module_repository.dart';
import '../../../domain/entities/contact.dart';
import '../../../domain/usecases/search_contacts.dart';
import '../../bloc/search_contact_cubit/search_contact_cubit.dart';
import '../../widgets/contact_cell.dart';

abstract class SearchContactDelegate {
  void didSelectContact (ContactEntity contact);
}


class SearchContactPage extends StatefulWidget {

  final List<ContactEntity> initialContacts;
  final SearchContactDelegate delegate;

  SearchContactPage({
    @required this.initialContacts,
    this.delegate
  });

  static Route route({
    List<ContactEntity> initialContacts,
    SearchContactDelegate delegate
  }) {
    return MaterialPageRoute<void>(builder: (_) => SearchContactPage(
      initialContacts: initialContacts,
      delegate: delegate
    ));
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
      setState: setState,
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

    _searchContactCubit.initInitialContacts(widget.initialContacts ?? []);

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
              SnackUtil.showError(context: context, message: state.message);
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
          builder: (context, SearchContactState state) {
            return BlocProvider<OpenChatCubit>(
              create: (context) => OpenChatCubit(
                createChatGruopUseCase: sl<CreateChatGruopUseCase>()
              ),
              child: BlocConsumer<OpenChatCubit, OpenChatState>(
                listener: (context, openChatState) {
                  OpenChatListener().handleStateUpdate(context, openChatState);
                },
                builder: (context, openChatState) {
                  return ListView.separated(
                    controller: scrollController,
                    itemBuilder: (context, int index) {
                      if (index >= state.contacts.data.length) {
                        return CellShimmerItem(circleSize: 35);
                      }
      
                      return ContactCell(
                        contactItem: state.contacts.data[index],
                        onTrilinIconTapped: () async {
                          context.read<OpenChatCubit>().createChatWithUser(state.contacts.data[index].id);
                        },
                        onTap: widget.delegate != null ? () {
                          widget.delegate.didSelectContact(state.contacts.data[index]);
                        } : () {
                          context.read<OpenChatCubit>().createChatWithUser(state.contacts.data[index].id);
                        },
                      );
                    }, 
                    separatorBuilder: (_, int index) => Divider(), 
                    itemCount: state.contacts.data.length + (state is SearchContactsLoading ? 3 : 0)
                  );
                },
              ),
            );
          }, 
        )
      ),
    );
  }

  // MARK: - UI Helpers

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('users'.tr()),
      actions: [
        searchBar.getSearchAction(context)
      ]
    );
  }

  void _onScroll () {
    var state = _searchContactCubit.state;
    if (scrollController.isPaginated && !(state is SearchContactsLoading) && state.contacts.paginationData.hasNextPage) {
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