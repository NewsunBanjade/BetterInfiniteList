library better_infinite_list;

import 'package:flutter/material.dart';

///BetterInfiniteList

class BetterInfiniteList extends StatefulWidget {
  const BetterInfiniteList({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.sepratorBuilder,
    this.scrollControllerCb,
    this.direction = Axis.vertical,
    this.fetchMore,
    this.hasReachedMax = false,
    this.sepratorSpacing,
    this.status = BetterInfiniteStatus.idle,
    this.emptyWidget,
    this.errorWidget,
    this.loadingWidget,
    this.padding,
    this.shrinkWrap = false,
    this.errorListWidget,
    this.loadingListWidget,
    this.scrollPhysics,
    this.onRefresh,
  });

  final NullableIndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final NullableIndexedWidgetBuilder? sepratorBuilder;

  ///Returns [ScrollController] on ScrollListener Event Triggers
  final void Function(ScrollController)? scrollControllerCb;
  final WidgetBuilder? loadingWidget;
  final WidgetBuilder? errorWidget;
  final WidgetBuilder? emptyWidget;
  final WidgetBuilder? errorListWidget;
  final WidgetBuilder? loadingListWidget;
  final Axis direction;
  final VoidCallback? fetchMore;
  final bool hasReachedMax;
  final BetterInfiniteStatus status;
  final double? sepratorSpacing;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? scrollPhysics;

  final RefreshCallback? onRefresh;
  @override
  State<BetterInfiniteList> createState() => _BetterInfiniteListState();
}

class _BetterInfiniteListState extends State<BetterInfiniteList> {
  late final ScrollController scrollController;

  BetterInfiniteStatus get status => widget.status;
  bool get hasData => widget.itemCount > 0;

  @override
  void initState() {
    scrollController = ScrollController();
    scrollController.addListener(
      () {
        widget.scrollControllerCb?.call(scrollController);
        if (widget.hasReachedMax) return;
        if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent) {
          widget.fetchMore?.call();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.onRefresh != null
        ? RefreshIndicator(
            onRefresh: widget.onRefresh!,
            child: getChild(),
          )
        : getChild();
  }

  Widget getChild() {
    if (!hasData && status == BetterInfiniteStatus.loading) {
      return widget.loadingWidget?.call(context) ??
          const Center(
            child: CircularProgressIndicator(),
          );
    }

    return ListView.separated(
      physics: widget.scrollPhysics,
      scrollDirection: widget.direction,
      padding: widget.padding,
      controller: scrollController,
      shrinkWrap: widget.shrinkWrap,
      itemBuilder: (context, index) {
        if (!hasData) {
          return status.getWidget(
            context,
            emptyWidget: widget.emptyWidget,
            errorWidget: widget.errorWidget,
          );
        }

        if (index == widget.itemCount) {
          if (status == BetterInfiniteStatus.error) {
            return widget.errorListWidget?.call(context) ??
                widget.errorWidget?.call(context) ??
                const SizedBox.shrink();
          } else if (status == BetterInfiniteStatus.loading) {
            return widget.loadingListWidget?.call(context) ??
                widget.loadingWidget?.call(context) ??
                const Center(
                  child: CircularProgressIndicator(),
                );
          }
        }

        return widget.itemBuilder(context, index);
      },
      separatorBuilder: (context, index) =>
          widget.sepratorBuilder?.call(context, index) ??
          ((widget.sepratorSpacing != null)
              ? SizedBox(
                  height: widget.direction == Axis.vertical
                      ? widget.sepratorSpacing
                      : null,
                  width: widget.direction == Axis.horizontal
                      ? widget.sepratorSpacing
                      : null,
                )
              : const SizedBox.shrink()),
      itemCount: getItemCount(status),
    );
  }

  int getItemCount(BetterInfiniteStatus status) {
    if (!hasData &&
        [
          BetterInfiniteStatus.error,
          BetterInfiniteStatus.idle,
          BetterInfiniteStatus.loading,
        ].contains(status)) {
      return 1;
    }

    return switch (status) {
      BetterInfiniteStatus.error ||
      BetterInfiniteStatus.loading =>
        widget.itemCount + 1,
      BetterInfiniteStatus.idle => widget.itemCount,
    };
  }
}

enum BetterInfiniteStatus { idle, loading, error }

extension BetterInfiniteStatusX on BetterInfiniteStatus {
  Widget getWidget(
    BuildContext context, {
    Widget Function(BuildContext)? emptyWidget,
    Widget Function(BuildContext)? errorWidget,
  }) {
    return switch (this) {
      BetterInfiniteStatus.idle =>
        emptyWidget?.call(context) ?? const SizedBox.shrink(),
      BetterInfiniteStatus.error =>
        errorWidget?.call(context) ?? const SizedBox.shrink(),
      _ => const SizedBox.shrink(),
    };
  }
}
