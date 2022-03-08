import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'dart:io';

const _defaultExpStyle = TextStyle(
  color: Colors.black,
  fontSize: 14.0,
  fontWeight: FontWeight.bold,
);

/// Explanation Navigation Bottom Bar
/// items. [ExpNavigationItem].
class ExpNavigationItem {
  /// this [item] of navigation bar child [Row].
  /// [exp] is Explanation of item.
  /// [badge] display badge item. like notification.
  /// [badgeCount] count of badge.
  const ExpNavigationItem({
    Key? key,
    required this.item,
    required this.exp,
    bool? badge,
    int? badgeCount,
    Color? backgroundColor,
    TextStyle? expStyle,
  })  : badge = badge ?? false,
        badgeCount = badgeCount ?? 0,
        backgroundColor = backgroundColor ?? Colors.transparent,
        expStyle = expStyle ?? _defaultExpStyle;

  /// Explanation navigation item [Widget].
  final Widget item;

  /// Explanation navigation item [String]
  /// text for explanation.
  final String exp;

  /// Style of explanation [TextStyle]
  final TextStyle expStyle;

  /// Display item badge. [bool]
  /// default false
  final bool badge;

  /// Badge count.[int]
  final int badgeCount;

  /// Color of item background
  /// default [Colors.transparent].
  final Color backgroundColor;
}

/// Explanation Navigation Bottom Bar
/// items. [ExplainableWidget].
class ExplainableWidget extends AnimatedWidget {
  /// Constructor [ExplainableWidget]
  /// [expNavItem] child of [ExpNavigationBar]
  const ExplainableWidget({
    Key? key,
    required this.expNavItem,
    required this.animation,
    this.anim = false,
  }) : super(key: key, listenable: animation);

  /// Animation [listable].
  final Animation animation;

  /// Item of [ExpNavigationBar]
  final ExpNavigationItem expNavItem;

  /// Build anim or default item
  /// display default [false].
  final bool anim;

  double get animValue => animation.value;

  bool get badge => expNavItem.badge;

  int get badgeCount => expNavItem.badgeCount;

  Widget get item => expNavItem.item;

  String get exp => expNavItem.exp;
  TextStyle get expStyle => expNavItem.expStyle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildItem,
          _buildExp,
        ],
      ),
    );
  }

  Widget get _buildItem {
    Widget? child;
    if (badge) {
      child = Badge(
        toAnimate: true,
        badgeColor: Colors.red,
        shape: BadgeShape.circle,
        animationType: BadgeAnimationType.scale,
        animationDuration: const Duration(milliseconds: 300),
        position: BadgePosition.topEnd(end: -10, top: -12),
        badgeContent: Text(
          '$badgeCount',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        showBadge: badgeCount != 0,
        child: item,
      );
    } else {
      child = item;
    }
    if (!anim) return child;
    return Opacity(
      opacity: (1 - animValue).clamp(0.0, 1.0),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, -20 * animValue)
          ..rotateX(animValue),
        child: child,
      ),
    );
  }

  Widget get _buildExp {
    Widget child = Text(exp, style: expStyle);
    if (!anim) return const SizedBox();
    return Opacity(
      opacity: animValue.clamp(0.0, 1.0),
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(0.0, 20 * (1 - animValue))
          ..rotateX(1 - animValue),
        child: child,
      ),
    );
  }
}

/// Explanation Bottom Navigation Bar
class ExpNavigationBar extends StatefulWidget {
  ExpNavigationBar({
    Key? key,
    required this.items,
    required this.onPress,
    Color? backgroundColor,
  })  : backgroundColor = backgroundColor ?? Colors.white,
        assert(items.isNotEmpty, 'Items can not be empty'),
        super(key: key);

  /// Naviation bar items
  /// [ExpNavigationItem].
  final List<ExpNavigationItem> items;

  /// Color of navigation background [Color].
  final Color backgroundColor;

  /// Onpress [Function] items.
  /// index [int].
  final Function(int index) onPress;

  @override
  State<ExpNavigationBar> createState() => _Exp();
}

class _Exp extends State<ExpNavigationBar> with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> anim;
  int hAnim = 0;

  @override
  void initState() {
    for (var i = 0; i < 4; i++) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      )
        ..addStatusListener(_addStatusListener)
        ..addListener(_addListener);
      anim = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.linear),
      );
    }
    super.initState();
  }

  void _addListener() {}

  void _addStatusListener(AnimationStatus status) {}

  @override
  void didUpdateWidget(covariant ExpNavigationBar oldWidget) {
    /// TODO: Listen widget update
    super.didUpdateWidget(oldWidget);
  }

  bool get _isIOS => Platform.isIOS;

  bool get _isAndoid => Platform.isAndroid;

  Color get _backgroundColor => widget.backgroundColor;

  void _onPressItem(int index) async {
    if (index == hAnim) return;
    if (hAnim != -1) {
      await controller.reverse();
    }
    hAnim = index;
    setState(() {});
    await controller.forward();
    widget.onPress.call(hAnim);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kBottomNavigationBarHeight + (_isIOS ? 20 : 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: _decoration,
      padding: _padding,
      child: Row(
        children: List.generate(
          4,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => _onPressItem(index),
              child: ExplainableWidget(
                expNavItem: widget.items[index],
                animation: anim,
                anim: index == hAnim,
              ),
            ),
          ),
        ),
      ),
    );
  }

  EdgeInsetsGeometry get _padding {
    double bottom = 0.0;
    if (_isIOS) {
      bottom = 20.0;
    }
    if (_isAndoid) {
      bottom = 10.0;
    }
    return EdgeInsets.only(bottom: bottom);
  }

  BoxDecoration get _decoration {
    return BoxDecoration(
      color: _backgroundColor,
    );
  }
}
