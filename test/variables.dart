import 'package:messenger_mobile/core/services/network/config.dart';
import 'package:messenger_mobile/core/services/network/paginatedResult.dart';
import 'package:messenger_mobile/core/usecases/usecase.dart';
import 'package:messenger_mobile/core/utils/pagination.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_entity_model.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_permission_model.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_entity.dart';
import 'package:messenger_mobile/modules/category/domain/entities/chat_permissions.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_detailed_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/chat_message_response.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_model.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_user_model.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_actions.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/message.dart';
import 'package:messenger_mobile/modules/chats/data/model/category_model.dart';
import 'package:messenger_mobile/modules/chats/domain/entities/category.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/domain/entities/contact.dart';
import 'package:messenger_mobile/modules/profile/data/models/user_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import 'package:messenger_mobile/modules/social_media/domain/entities/social_media.dart';

final date1 = DateTime.parse('2021-01-01 00:00:01.860545');
final date2 = DateTime.parse('2021-03-15 17:08:04.860545');

// no json
final tCategoryEntity = CategoryEntity(
  id: 1,
  name: 'name',
  avatar: 'avatar',
  totalChats: 1,
  noReadCount: 1,
);

// +
final tMessageUser = MessageUser(
  id: 1,
  avatarURL: ConfigExtension.buildURLHead() + 'avatarURL',
  name: 'name',
  phone: '+77777777777',
  surname: 'surname',
);

// +
final tMessageUser2 = MessageUser(
  id: 2,
  avatarURL: ConfigExtension.buildURLHead() + 'avatarURL2',
  name: 'name2',
  phone: '+77777777777',
  surname: 'surname2',
);

// +
final tMessageUserModel = MessageUserModel(
  id: 1,
  avatarURL: ConfigExtension.buildURLHead() + 'avatarURL',
  name: 'name',
  phone: '+77777777777',
  surname: 'surname',
);

// +
final tMessageUserModel2 = MessageUserModel(
  id: 2,
  avatarURL: ConfigExtension.buildURLHead() + 'avatarURL2',
  name: 'name2',
  phone: '+77777777777',
  surname: 'surname2',
);

// +
final tMessageChat = MessageChat(id: 1, name: 'name');

// +
final tMessageChatModel = MessageChatModel(id: 1, name: 'name');

// +
final tMessageModel = MessageModel(
  id: 1,
  colorId: 1,
  user: tMessageUserModel,
  toUser: tMessageUserModel2,
  text: 'text',
  isRead: false,
  dateTime: date1,
  chatActions: ChatActions.addUser,
  willBeDeletedAt: date2,
  deletionSeconds: 777,
  timeDeleted: 777,
  chat: tMessageChatModel,
  transfer: [],
  // following two parameters not listed on model's fromjson factory
  messageHandleType: MessageHandleType.newMessage,
  messageStatus: MessageStatus.sent,
);

// +
final tChatPermissions = ChatPermissions(
  isSoundOn: true,
  adminMessageSend: true,
  isForwardOn: true,
  isMediaSendOn: true,
  isSecret: false,
);

// +
final tChatPermissionModel = ChatPermissionModel(
  isSoundOn: true,
  adminMessageSend: true,
  isForwardOn: true,
  isMediaSendOn: true,
  isSecret: false,
);

// +
final tCategoryModel = CategoryModel(
  id: 1,
  name: 'name',
  avatar: 'avatar',
  totalChats: 1,
  noReadCount: 1,
);

// +
final tChatEntityModel = ChatEntityModel(
  chatId: 1,
  title: 'name',
  imageUrl: 'avatar',
  chatCategory: tCategoryModel,
  date: date1,
  permissions: tChatPermissionModel,
  lastMessage: tMessageModel,
  unreadCount: 1,
  description: 'description',
  isPrivate: false,
  isRead: true,
);

// no json methods
final tMediaStats = MediaStats(
  mediaCount: 1,
  documentCount: 1,
  audioCount: 1,
);

// +
final tMediaStatsModel = MediaStatsModel(
  mediaCount: 1,
  documentCount: 1,
  audioCount: 1,
);

// no json methods
final tContactEntity = ContactEntity(
  id: 1,
  avatar: 'avatar',
  name: 'name',
  surname: 'surname',
  patronym: 'patronym',
  lastVisit: date1,
);

// no json methods
final tContactEntity2 = ContactEntity(
  id: 2,
  avatar: 'avatar2',
  name: 'name2',
  surname: 'surname2',
  patronym: 'patronym2',
  lastVisit: date2,
);

// no json (entity)
final tUser = User(
  id: 1,
  name: 'name',
  surname: 'surname',
  patronym: 'patronym',
  phoneNumber: 'phoneNumber',
  isBlocked: false,
  profileImage: 'profileImage',
);

// no json (entity)
final tChatDetailed = ChatDetailed(
  chat: tChatEntityModel,
  media: tMediaStats,
  members: [tContactEntity, tContactEntity2],
  membersCount: 2,
  chatMemberRole: ChatMember.member,
  user: tUser,
);

final tMessageWithNoText = Message(
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
  text: '',
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
  text: 'text',
);

final tPagination = Pagination();

final tPaginationData = PaginationData(
  nextPageUrl: Uri.parse('nextPageUrl'),
  isFirstPage: false,
  total: 3,
);

final tPaginatedResultChatEntity = PaginatedResult<ChatEntity>(
  data: [tChatEntityModel],
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

// +
final mediaStatsModel = MediaStatsModel(
  mediaCount: 1,
  documentCount: 1,
  audioCount: 1,
);

// +
final tContactModel = ContactModel(
  id: 1,
  name: 'name',
  patronym: 'patronym',
  surname: 'surname',
  lastVisit: date1,
  avatar: 'avatar',
);

// +
final tContactModel2 = ContactModel(
  id: 2,
  name: 'name2',
  patronym: 'patronym2',
  surname: 'surname2',
  lastVisit: date1,
  avatar: 'avatar2',
);

// +
final tUserModel = UserModel(
  id: 1,
  name: 'Name',
  surname: 'Surname',
  patronym: 'Patronym',
  phoneNumber: '+77777777777',
  profileImage: ConfigExtension.buildURLHead() + 'avatar',
  isBlocked: false,
);

// +
final tChatDetailedModel = ChatDetailedModel(
  chat: tChatEntityModel,
  media: tMediaStatsModel,
  membersCount: 2,
  members: [tContactModel, tContactModel2],
  settings: tChatPermissionModel,
  chatMemberRole: ChatMember.member,
  user: tUserModel,
  groups: [tChatEntityModel],
  // socialMedia: tSocialMedia,
);

// +
final tTransfer = Transfer(
  id: 1,
  fromId: 1,
  toId: 1,
  text: 'text',
  action: ChatActions.addUser,
  chatId: 1,
  isRead: true,
  dateTime: date1,
  updatedAt: "2021-03-15 17:08:04.860545", // type should be DateTime
  user: tMessageUserModel,
);
