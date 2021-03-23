import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:messenger_mobile/core/blocs/audioplayer/bloc/audio_player_bloc.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/file_media.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:swipeable/swipeable.dart';
import 'package:vibrate/vibrate.dart';

import '../../../../../app/appTheme.dart';
import '../../../data/models/message_view_model.dart';
import '../../../domain/entities/message.dart';
import '../helpers/messageCellAction.dart';
import 'components/forward_container.dart';
import 'name_time_read_container.dart';

class MessageCell extends StatefulWidget {
  
  final MessageViewModel messageViewModel;
  final int nextMessageUserID;
  final int prevMessageUserID;
  final Function(MessageViewModel) onReply;
  final Function(MessageCellActions) onAction;
  final Function onTap; 
  final bool isSwipeEnabled;

  const MessageCell({
    @required this.messageViewModel,
    @required this.onAction,
    @required this.onReply,
    this.isSwipeEnabled = true,
    this.onTap,
    this.nextMessageUserID,
    this.prevMessageUserID,
    Key key, 
  }) : super(key: key);

  @override
  _MessageCellState createState() => _MessageCellState();
}

class _MessageCellState extends State<MessageCell> {
  bool leftSelected;
  AudioPlayerBloc _audioPlayerBloc;
  bool rightSelected;
  void initState() {
    leftSelected = false;
    rightSelected = false;
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);
    super.initState();
  }

  Future<void> vibrate() async {
    bool canVibrate = await Vibrate.canVibrate;
    if(canVibrate){
      Vibrate.feedback(FeedbackType.medium);
    }
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
      color: widget.messageViewModel.isSelected ? AppColors.paleIndicatorColor : Colors.transparent,
      child: Swipeable(
        background: Container(
          child: ListTile(
            leading: !widget.messageViewModel.isMine ? Icon(Icons.reply) : SizedBox(),
            trailing: widget.messageViewModel.isMine ? Icon(Icons.reply) : SizedBox(),
          ),
        ),
        threshold: 64.0,
        onSwipeLeft: () {
          if (widget.isSwipeEnabled) {
            vibrate();
            widget.onReply(widget.messageViewModel);
          }
        },
        onSwipeRight: () {
          if (widget.isSwipeEnabled) {
            vibrate();
            widget.onReply(widget.messageViewModel);
          }
        },
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: widget.messageViewModel.isMine ?
            MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            LimitedBox(
              maxWidth: w * 0.8,
              child: FocusedMenuHolder(
                blurSize: 5.0,
                animateMenuItems: true,
                blurBackgroundColor: Colors.black54,
                menuOffset: 10.0, 
                menuBoxDecoration: BoxDecoration(color: Colors.grey,borderRadius: BorderRadius.all(Radius.circular(15.0))),
                menuItems: widget.messageViewModel.getActionsList(
                  isReplyEnabled: widget.isSwipeEnabled
                ).map((e) => FocusedMenuItem(
                    title: Text(
                      e.title
                    ),
                    trailingIcon: e.icon, 
                    onPressed: () {
                      widget.onAction(e);
                    })
                  ).toList(),
                onPressed: () {
                  widget.onTap();
                  vibrate();
                },
                child: MessageContainer(widget: widget,audioPlayerBloc: _audioPlayerBloc,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageContainer extends StatelessWidget {
  const MessageContainer({
    Key key,
    @required this.widget,
    @required this.audioPlayerBloc,
  }) : super(key: key);

  final MessageCell widget;
  final AudioPlayerBloc audioPlayerBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
    padding: EdgeInsets.all(8),
    decoration: widget.messageViewModel.getCellDecoration(
      previousMessageUserID: widget.prevMessageUserID, 
      nextMessageUserID: widget.nextMessageUserID
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: widget.messageViewModel.isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        NameTimeBloc(messageViewModel: widget.messageViewModel),
        if(widget.messageViewModel.message.transfer.isNotEmpty)
        ...returnForwardColumn(widget.messageViewModel.message.transfer),
        if (widget.messageViewModel.messageText != null) 
        Text(
          widget.messageViewModel.messageText, 
          style: !widget.messageViewModel.isMine ? 
          AppFontStyles.black14w400 : AppFontStyles.white14w400,
          textAlign: TextAlign.left,
        ),
        if(widget.messageViewModel.hasMedia) 
        ...returnAuidoWidgets(widget.messageViewModel.message.files,audioPlayerBloc, widget.messageViewModel.isMine),
      ],
    ),
          );
  }
}

List<Widget> returnForwardColumn(List<Message> transfers) {
  return transfers.map((e) => ForwardContainer(
    messageViewModel: MessageViewModel(e)
  )).toList();
}

List<Widget> returnAuidoWidgets(List<FileMedia> files, AudioPlayerBloc audioPlayerBloc, bool isMine) {
  return files.map((e) => AudioPlayerElement(
    file: e,
    isMine: isMine,
    audioPlayerBloc: audioPlayerBloc,
  )).toList();
}

class AudioPlayerElement extends StatelessWidget {

  const AudioPlayerElement({Key key, @required this.file, @required this.audioPlayerBloc, @required this.isMine,}) : super(key: key);
  final bool isMine;
  final FileMedia file;
  final AudioPlayerBloc audioPlayerBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerBloc, AudioPlayerState>(
      builder: (context, state) {
        return Container(
          child: Row(
            children: [
              StreamBuilder<PlaybackDisposition>(
              stream: BlocProvider.of<AudioPlayerBloc>(context).playerStream,
              initialData: PlaybackDisposition(duration: Duration(seconds: 1), position: Duration(seconds: 0)),
              builder: (context, snapshot) {
                var timeNow = '00:00';
                var value = 0.0;
                var maxDurationInDate = DateTime.fromMillisecondsSinceEpoch(
                    file.maxDuration.inMilliseconds,
                    isUtc: true);
                var maxDuration = DateFormat.ms().format(maxDurationInDate);
                if(state.id == file.url){
                  var maxDuration = snapshot.data.duration.inSeconds.toDouble();
                  var sliderCurrentPosition = min(snapshot.data.position.inSeconds.toDouble(), maxDuration);
                  if (sliderCurrentPosition < 0.0) {
                    sliderCurrentPosition = 0.0;
                  }
                  value = sliderCurrentPosition / maxDuration;
                  var date = DateTime.fromMillisecondsSinceEpoch(
                    snapshot.data.position.inMilliseconds,
                    isUtc: true);
                  timeNow = DateFormat.ms().format(date);
                }
                return Expanded(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: Material(
                            color: AppColors.successGreenColor,
                            child: InkWell(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  (state.status == VoicePlayerState.playing && state.id == file.url) ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ), 
                              onTap: (){
                                audioPlayerBloc.add(StartResumeStop(path: file.url));
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 4,),
                        Flexible(
                          fit: FlexFit.loose,
                          child: Container(
                            height: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(16)),
                              child: LinearProgressIndicator(
                                value: value,
                                backgroundColor: isMine ? Colors.white : Colors.black12,
                                valueColor: AlwaysStoppedAnimation<Color>(AppColors.successGreenColor),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text(timeNow + ' / ', style: TextStyle(
                          color: isMine ? AppColors.greyColor : Colors.black26,
                          fontSize: 10,
                        ),),
                        Text(maxDuration, style: TextStyle(
                          color: isMine ? Colors.white : Colors.black87,
                          fontSize: 10,
                        )),
                      ],
                    ),
                  ),
                );
              }
            ),
            ],
          ),
        );
      },
    );
  }
}