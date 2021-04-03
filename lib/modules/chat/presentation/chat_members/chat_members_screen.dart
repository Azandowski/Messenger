import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../locator.dart';
import '../../../creation_module/presentation/bloc/contact_bloc/contact_bloc.dart';
import '../../../creation_module/presentation/bloc/open_chat_cubit/open_chat_cubit.dart';
import '../../../creation_module/presentation/bloc/open_chat_cubit/open_chat_listener.dart';
import '../../../creation_module/presentation/widgets/contcats_list.dart';
import '../../../groupChat/domain/usecases/create_chat_group.dart';
import '../../domain/usecases/get_chat_details.dart';
import '../../domain/usecases/get_chat_members.dart';

class ChatMembersScreen extends StatelessWidget {
  
  static Route route(int id, GetChatDetails getChatDetails) {
    return MaterialPageRoute<void>(builder: (_) => ChatMembersScreen(id: id, getChatDetails: getChatDetails));
  }

  final int id;
  final GetChatDetails getChatDetails;
  final OpenChatListener _openChatListener = OpenChatListener();

  ChatMembersScreen({
    @required this.id,
    @required this.getChatDetails
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('members'.tr()),
      ),
      body: BlocProvider(
        create: (context) => ContactBloc(
          mode: GetChatMembersMode(id),
          getChatMembers: GetChatMembers(
            repository: getChatDetails.repository
          )
        )..add(ContactFetched()),
        child: BlocProvider(
          create: (context) => OpenChatCubit(
            createChatGruopUseCase: sl<CreateChatGruopUseCase>()
          ),
          child: BlocConsumer<OpenChatCubit, OpenChatState>(
            listener: (context, state) {
              _openChatListener.handleStateUpdate(context, state);
            },
            builder: (context, state) {
              return ContactsList(
                mode: ContactsMode.showPeople,
                didSelectContactToChat: (person) {
                  context.read<OpenChatCubit>().createChatWithUser(person.id);
                },
              );
            },
          ),
        )
      ),
    );
  }
}