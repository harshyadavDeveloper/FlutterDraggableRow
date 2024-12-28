import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                width: 48,
                height: 48,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: _getIconColor(e),
                ),
                child: Center(
                  child: Icon(
                    e,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

Color _getIconColor(IconData icon) {
  if (icon == Icons.person) return const Color(0xFFFF5C5C);
  if (icon == Icons.message) return const Color(0xFF2FBDBD);
  if (icon == Icons.call) return const Color(0xFF7B68EE);
  if (icon == Icons.camera) return const Color(0xFF90EE90);
  if (icon == Icons.photo) return Colors.teal;
  return Colors.blue;
}

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  final List<T> items;
  final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 48,
        child: ReorderableListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          buildDefaultDragHandles: false, // Removed default drag handles
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final item = _items.removeAt(oldIndex);
              _items.insert(newIndex, item);
            });
          },
          proxyDecorator: (child, index, animation) {
            return AnimatedBuilder(
              animation: animation,
              builder: (BuildContext context, Widget? child) {
                return Material(
                  color: Colors.transparent,
                  child: Opacity(
                    opacity: animation.value,
                    child: child,
                  ),
                );
              },
              child: child,
            );
          },
          children: [
            for (int index = 0; index < _items.length; index++)
              ReorderableDragStartListener(
                key: ValueKey(_items[index]),
                index: index,
                child: widget.builder(_items[index]),
              ),
          ],
        ),
      ),
    );
  }
}
