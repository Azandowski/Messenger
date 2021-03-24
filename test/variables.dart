import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';

final date1 = DateTime.parse('2021-01-01 00:00:01.860545');
final date2 = DateTime.parse('2021-03-15 17:08:04.860545');

final tCategoryEntity = CategoryEntity(
  id: 1,
  name: 'name',
  avatar: 'avatar',
  totalChats: 1,
  noReadCount: 1,
);

final tMessageUser = MessageUser(
  id: 1,
  avatarURL: 'avatarURL',
  name: 'name',
  phone: 'phone',
  surname: 'surname',
);

final tMessageUser2 = MessageUser(
  id: 2,
  avatarURL: 'avatarURL2',
  name: 'name2',
  phone: 'phone2',
  surname: 'surname2',
);

final tMessageChat = MessageChat(id: 1, name: 'name');

final tMessageModel = MessageModel(
  chat: tMessageChat,
  chatActions: ChatActions.addUser,
  colorId: 1,
  dateTime: date1,
  deletionSeconds: 777,
  id: 1,
  isRead: false,
  messageHandleType: MessageHandleType.newMessage,
  messageStatus: MessageStatus.sent,
  text: 'text',
  timeDeleted: 777,
  toUser: tMessageUser2,
  user: tMessageUser,
  willBeDeletedAt: date2,
  transfer: [],
);

final tChatPermissions = ChatPermissions(
  isSoundOn: true,
  adminMessageSend: true,
  isForwardOn: true,
  isMediaSendOn: true,
  isSecret: false,
);
final tChatPermissionModel = ChatPermissionModel(
  isSoundOn: true,
  adminMessageSend: true,
  isForwardOn: true,
  isMediaSendOn: true,
  isSecret: false,
);

final tChatEntity = ChatEntity(
  title: 'title',
  chatId: 1,
  date: date1,
  description: 'description',
  imageUrl: 'imageUrl',
  isPrivate: true,
  isRead: false,
  unreadCount: 1,
  chatCategory: tCategoryEntity,
  lastMessage: tMessageModel,
  permissions: tChatPermissions,
);

final tMediaStats = MediaStats(
  mediaCount: 1,
  documentCount: 1,
  audioCount: 1,
);

final tContactEntity = ContactEntity(
  id: 1,
  avatar: 'avatar',
  name: 'name',
  surname: 'surname',
  patronym: 'patronym',
  lastVisit: date1,
);

final tContactEntity2 = ContactEntity(
  id: 2,
  avatar: 'avatar2',
  name: 'name2',
  surname: 'surname2',
  patronym: 'patronym2',
  lastVisit: date2,
);

final tUser = User(
  id: 1,
  name: 'name',
  surname: 'surname',
  patronym: 'patronym',
  phoneNumber: 'phoneNumber',
  isBlocked: false,
  profileImage: 'profileImage',
);

final tChatDetailed = ChatDetailed(
  chat: tChatEntity,
  media: tMediaStats,
  members: [tContactEntity, tContactEntity2],
  membersCount: 2,
  chatMemberRole: ChatMember.member,
  user: tUser,
);

final tMessage = Message(
    chat: tMessageChat,
    chatActions: ChatActions.addUser,
    colorId: 1,
    dateTime: date1,
    deletionSeconds: 777,
    id: 1,
    identificator: 1,
    isRead: false,
    messageHandleType: MessageHandleType.newMessage,
    messageStatus: MessageStatus.sent,
    text: '');

final tPagination = Pagination();

final tPaginationData = PaginationData(
  nextPageUrl: Uri.parse('nextPageUrl'),
  isFirstPage: false,
  total: 3,
);

final tPaginatedResultChatEntity = PaginatedResult<ChatEntity>(
  data: [tChatEntity],
  paginationData: tPaginationData,
);

final tPaginatedResultContactEntity = PaginatedResult<ContactEntity>(
  data: [tContactEntity],
  paginationData: tPaginationData,
);

final tPaginatedResultViaLastItemMessage = PaginatedResultViaLastItem<Message>(
  data: [tMessage],
  hasReachMax: true,
);

final tChatMessageResponse = ChatMessageResponse(
  result: tPaginatedResultViaLastItemMessage,
  topMessage: tMessage,
);

final tNoParams = NoParams();

final tSocialMedia = SocialMedia(
  facebookLink: 'facebookLink',
  instagramLink: 'instagramLink',
  websiteLink: 'websiteLink',
  youtubeLink: 'youtubeLink',
  whatsappNumber: 'whatsappNumber',
);
