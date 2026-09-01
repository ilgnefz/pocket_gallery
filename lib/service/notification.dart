import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static CancelFunc show(String message) {
    return BotToast.showCustomNotification(
      toastBuilder: (_) => NotificationView(message: message),
      // align: Alignment.bottomRight,
      duration: null,
      onlyOne: true,
      // wrapToastAnimation: (controller, cancelFunc, child) =>
      //     NotificationAnimation(
      //       reverse: true,
      //       controller: controller,
      //       child: child,
      //     ),
    );
  }
}

class NotificationView extends StatelessWidget {
  const NotificationView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        child: Container(
          height: 36,
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * .85,
          ),
          padding: const .symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: const CircularProgressIndicator(),
              ),
              SizedBox(width: 12),
              Text(
                '正在获取文件夹 ',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Microsoft YaHei',
                ),
              ),
              Flexible(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: .bold,
                    fontFamily: 'Microsoft YaHei',
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
              Text(
                ' 中的图片',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Microsoft YaHei',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// class NotificationAnimation extends StatefulWidget {
//   final Widget child;
//   final bool reverse;
//   final AnimationController controller;
//
//   const NotificationAnimation({
//     super.key,
//     required this.child,
//     this.reverse = false,
//     required this.controller,
//   });
//
//   @override
//   NotificationAnimationState createState() => NotificationAnimationState();
// }
//
// class NotificationAnimationState extends State<NotificationAnimation>
//     with SingleTickerProviderStateMixin {
//   static final Tween<Offset> reverseTweenOffset = Tween<Offset>(
//     begin: const Offset(0, 40),
//     end: const Offset(0, 0),
//   );
//   static final Tween<Offset> tweenOffset = Tween<Offset>(
//     begin: const Offset(0, -40),
//     end: const Offset(0, 0),
//   );
//   static final Tween<double> tweenOpacity = Tween<double>(begin: 0, end: 1);
//   late final Animation<double> animation;
//
//   late final Animation<Offset> animationOffset;
//   late final Animation<double> animationOpacity;
//
//   @override
//   void initState() {
//     animation = CurvedAnimation(
//       parent: widget.controller,
//       curve: Curves.decelerate,
//     );
//
//     animationOffset = (widget.reverse ? reverseTweenOffset : tweenOffset)
//         .animate(animation);
//     animationOpacity = tweenOpacity.animate(animation);
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: widget.controller,
//       builder: (_, child) => Transform.translate(
//         offset: animationOffset.value,
//         child: Opacity(opacity: animationOpacity.value, child: child),
//       ),
//       child: widget.child,
//     );
//   }
// }
