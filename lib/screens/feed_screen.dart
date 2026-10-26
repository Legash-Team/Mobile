import 'package:flutter/material.dart';
import '../constants.dart';
import '../l10n/app_localizations.dart';
import '../models/post_model.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';

class FeedScreen extends StatefulWidget {
  final List<PostModel>? initialPosts;

  const FeedScreen({super.key, this.initialPosts});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<PostModel> _posts = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _error;
  int _page = 1;
  static const int _limit = 10;

  @override
  void initState() {
    super.initState();
    if (widget.initialPosts != null) {
      _posts.addAll(widget.initialPosts!);
      _isLoading = false;
      _hasMore = false;
    } else {
      _loadInitial();
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        !_isLoadingMore &&
        _hasMore) {
      _loadMore();
    }
  }

  Future<void> _loadInitial() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _page = 1;
    });

    try {
      final posts = await PostService.getFeed(page: 1, limit: _limit);
      if (!mounted) return;
      setState(() {
        _posts.clear();
        _posts.addAll(posts);
        _hasMore = posts.length >= _limit;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMore() async {
    setState(() => _isLoadingMore = true);
    final nextPage = _page + 1;

    try {
      final newPosts = await PostService.getFeed(page: nextPage, limit: _limit);
      if (!mounted) return;
      setState(() {
        _page = nextPage;
        _posts.addAll(newPosts);
        _hasMore = newPosts.length >= _limit;
        _isLoadingMore = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.paper,
      appBar: AppBar(
        title: Text(
          l10n?.communityFeed ?? 'COMMUNITY FEED',
          style: const TextStyle(
            color: AppColors.crimson,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.paper,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      body: RefreshIndicator(
        onRefresh: _loadInitial,
        color: AppColors.crimson,
        child: _buildBody(l10n),
      ),
    );
  }

  Widget _buildBody(AppLocalizations? l10n) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.crimson),
      );
    }

    if (_error != null && _posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          const SizedBox(height: 80),
          const Icon(Icons.cloud_off, size: 48, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n?.couldNotLoadFeed ?? 'Could not load feed posts.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
          const SizedBox(height: AppSpacing.md),
          Center(
            child: FilledButton(
              onPressed: _loadInitial,
              style: FilledButton.styleFrom(backgroundColor: AppColors.crimson),
              child: Text(l10n?.retry ?? 'Retry'),
            ),
          ),
        ],
      );
    }

    if (_posts.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 120),
          const Icon(Icons.dynamic_feed_outlined, size: 56, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.md),
          Text(
            l10n?.noFeedPostsYet ?? 'No feed posts yet.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n?.checkBackSoonUpdates ?? 'Check back soon for community updates.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
        ],
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      itemCount: _posts.length + (_hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _posts.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.crimson,
              ),
            ),
          );
        }

        final post = _posts[index];
        return PostCard(post: post);
      },
    );
  }
}
