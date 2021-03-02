import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageTextController = TextEditingController();
   
  String messageText;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          CircleAvatar(backgroundImage: AssetImage(
            'assets/images/default_user.jpg'
          ),),
          SizedBox(width: 8,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text('The Friends',style: AppFontStyles.headerMediumStyle,),
            Text('Alice, Michael + 4...',style: AppFontStyles.placeholderStyle,),
          ],)
        ],),
        actions: [
          Row(children: [
            IconButton(icon: Icon(Icons.video_call,color: AppColors.greyColor,),onPressed: (){

            },),
            IconButton(icon: Icon(Icons.call,color: AppColors.greyColor,),onPressed: (){

            },),
            IconButton(icon: Icon(Icons.search,color: AppColors.indicatorColor,),onPressed: (){

            },)
          ],)
        ],
      ),
      backgroundColor: AppColors.pinkBackgroundColor,
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
             Expanded(child: 
             Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/bg-home.png'),
                      fit: BoxFit.cover
                    )
                  ),
               child: ListView.builder(itemBuilder: (context, i){
                 return ListTile(title: Text('hm'),);
               },
               itemCount: 2,
               ),
             ),),
             Container(
              padding: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.pinkBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 4, blurRadius: 7,
                    offset: Offset(0, -4), // changes position of shadow
                    ),
                 ],
              ),
              child: SafeArea(
                  child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50)
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.emoji_emotions,color: Colors.grey,),
                          Expanded(
                            child: TextFormField(
                            controller: messageTextController,
                            onChanged: (value) {
                              messageText = value;
                            },
                            decoration: InputDecoration(
                               border: InputBorder.none,
                               contentPadding: EdgeInsets.symmetric(
                               horizontal: width / (360 / 16), vertical: height / (724 / 18)),
                               hintText: 'Сообщение',
                               labelStyle: AppFontStyles.blueSmallStyle)),
                          ),
                          Icon(Icons.attach_file,color: Colors.grey,),
                        ],
                      ),
                        )
                    ),
                    SizedBox(width: 5,),
                    ClipOval(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: AppGradinets.mainButtonGradient,
                        ),
                        child: IconButton(icon: Icon(Icons.voice_chat_rounded,color: Colors.white),onPressed: (){
                        },splashRadius: 5,splashColor: Colors.white,)
                    ),)
                  ],
                ),
              ),
                ),
        ],),
    );
  }
}