// * * Use Cases for Dialogs

// * * Недостаточно мест:

// DialogsView( 
//   title: 'Недостаточно мест',
//   customDescription: RichText(
//     textAlign: TextAlign.center,
//     text: TextSpan(
//       text: 'В конференции могут учавствовать до ',
//       style: TextStyle(
//         fontSize: 14,
//         color: Colors.grey
//       ),
//       children: [
//         TextSpan(
//           text: '16 ',
//           style: AppFontStyles.mainStyle,
//           children: [
//             TextSpan(
//               text: 'человек. Сейчас вы можете добавить только 4 участника',
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey
//               )
//             )
//           ]
//         )
//       ]
//     )
//   ),
//   actionButton: [
//     DialogActionButton(
//       title: 'Закрыть', 
//       buttonStyle: DialogActionButtonStyle.submit,
//       onPress: () {
//         print("First button tapped");
//       }
//     ),
//   ],
// );


// * * Вы хотите выйти из видеоконференции?

// DialogsView( 
//   title: 'Вы хотите выйти из видеоконференции?',
//   actionButton: [
//     DialogActionButton(
//       title: 'Отмена', 
//       buttonStyle: DialogActionButtonStyle.cancel,
//       onPress: () {
//         print("First button tapped");
//       }
//     ),
//     DialogActionButton(
//       title: 'Закрыть', 
//       buttonStyle: DialogActionButtonStyle.dangerous,
//       onPress: () {
//         print("First button tapped");
//       }
//     ),
//   ],
// );


// * * Убрать чат из категории?

// DialogsView( 
//   title: 'Убрать чат из категории?',
//   description: 'Сам чат не будет удален.',
//   actionButton: [
//     DialogActionButton(
//       title: 'Отмена', 
//       buttonStyle: DialogActionButtonStyle.cancel,
//       onPress: () {
//         print("First button tapped");
//       }
//     ),
//     DialogActionButton(
//       title: 'Убрать', 
//       buttonStyle: DialogActionButtonStyle.dangerous,
//       onPress: () {
//         print("First button tapped");
//       }
//     ),
//   ],
// );

// * * Actions: [Без фото, Добавить в категорию, Удалить]

// DialogsView( 
//   dialogViewType: DialogViewType.actionSheet,
//   actionButton: [
//     DialogActionButton(
//       title: 'Без фото', 
//       iconData: Icons.broken_image_outlined,
//       buttonStyle: DialogActionButtonStyle.black,
//       onPress: () {}
//     ),
//     DialogActionButton(
//       title: 'Добавить в категорию', 
//       iconData: Icons.folder_outlined,
//       buttonStyle: DialogActionButtonStyle.black,
//       onPress: () {}
//     ),
//     DialogActionButton(
//       title: 'Удалить', 
//       iconData: Icons.delete_outlined,
//       buttonStyle: DialogActionButtonStyle.dangerous,
//       onPress: () {}
//     ),
//   ],
// );


// * * Начать прямой эфир


// DialogsView( 
//   imageProvider: AssetImage('assets/images/logo.png'),
//   title: 'Начать прямой эфир?',
//   description: 'Все с кем вы переписываетесь, смогут увидеть и присоединиться к эфиру.',
//   buttonsLayout: DialogViewButtonsLayout.vertical,
//   actionButton: [
//     DialogActionButton(
//       buttonStyle: DialogActionButtonStyle.custom,
//       customButton: ActionButton(
//         text: 'Начать прямой эфир',
//         onTap: () {}
//       ) 
//     ),
//     DialogActionButton(
//       title: 'Отмена', 
//       buttonStyle: DialogActionButtonStyle.cancel,
//       onPress: () {}
//     ),
//   ],
// );


