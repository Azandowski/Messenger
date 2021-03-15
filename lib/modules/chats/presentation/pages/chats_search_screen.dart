import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:messenger_mobile/core/utils/paginated_scroll_controller.dart';
import 'package:messenger_mobile/core/utils/search_engine.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chats/domain/repositories/chats_repository.dart';
import 'package:messenger_mobile/modules/chats/presentation/bloc/search_chats/search_chats_cubit.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/chat_item/chat_preview_item.dart';
import 'package:messenger_mobile/modules/chats/presentation/widgets/chat_item/chat_search_result_item.dart';

import '../../../../locator.dart';

class ChatsSearchScreen extends StatefulWidget  {
  
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ChatsSearchScreen());
  }

  @override
  _ChatsSearchScreenState createState() => _ChatsSearchScreenState();
}


// MARK: - State

class _ChatsSearchScreenState extends State<ChatsSearchScreen> implements SearchEngingeDelegate {

  SearchBar searchBar;
  SearchEngine searchEngine;
  PaginatedScrollController scrollController = PaginatedScrollController();
  SearchChatsCubit _searchChatsCubit;

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
        _searchChatsCubit.showLoading(isPagination: false);
        searchEngine.onTextChanged(text);
      },
      buildDefaultAppBar: buildAppBar,
    );

    searchBar.isSearching.value = true;

    scrollController.addListener(() {
      _onScroll(); 
    });

    _searchChatsCubit = SearchChatsCubit(
      chatsRepository: sl<ChatsRepository>()
    );
    super.initState();
  }

  @override
  void dispose() {
    _searchChatsCubit.close();
    super.dispose();
  }


  // MARK: - UI

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchChatsCubit>(
      create: (context) => _searchChatsCubit,
      child: Scaffold(
        appBar: searchBar.build(context),
        body: BlocConsumer<SearchChatsCubit, SearchChatsState>(
          listener: (context, state) {
            if (state is SearchChatsError) {
              ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.message),)
              );
            } else {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          },
          builder: (context, state) {
            return ListView.separated(
              controller: scrollController,
              itemBuilder: (context, int index) {
                if (
                  state is SearchChatsLoading && 
                  (!state.isPagination || 
                    index >= state.data.chats.length + state.data.messages.data.length + 1
                  )) {
                    return CellShimmerItem();
                } else if (index + 1 <= state.data.chats.length) {
                  return ChatPreviewItem(
                    ChatViewModel(
                      state.data.chats[index]
                    )
                  );
                } else if (index == state.data.chats.length) {
                  return CellHeaderView(
                    title: 'Сообщения'
                  );
                } else {
                  // Show Messages
                  int newIndex = index - state.data.chats.length - 1;
                  var currentItem = state.data.messages.data[newIndex];
  
                  return ChatSearchResultItem(
                    time: _getDate(currentItem),
                    title: currentItem.chat?.name ?? '',
                    contentText: currentItem.text,
                    searchText: searchBar.controller.text.trim()
                  );
                }
              }, 
              separatorBuilder: (context, int index) => Divider(), 
              itemCount: state is SearchChatsLoading ? state.data.chats.length + state.data.messages.data.length + 11 : 
                state.data.chats.length + state.data.messages.data.length + 1
            );
          },
        )
      ),
    );
  }


  // MARK: - UI Helpers

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Chats'),
      actions: [
        searchBar.getSearchAction(context)
      ]
    );
  }


  String _getDate (Message entity) {
    return new DateFormat("Hm").format(entity.dateTime); 
  }

  void _onScroll () {
    var state = _searchChatsCubit.state;
    if (scrollController.isPaginated && !(state is SearchChatsLoading) && !state.data.messages.hasReachMax) {
      _searchChatsCubit.search(
        queryText: searchBar.controller.text.trim(),
        lastItemID: state.data.messages.data.last?.id
      );
    }
  }

  @override
  void startSearching({
    String text
  }) {
    _searchChatsCubit.search(
      queryText: text.trim(),
      lastItemID: null
    );
  }
}

