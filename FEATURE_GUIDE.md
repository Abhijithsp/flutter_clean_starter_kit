# How to Implement a New Feature (Step-by-Step)

This guide walks you through adding a complete new feature (e.g., **Posts**) to the starter kit using Clean Architecture and **Flutter Bloc/Cubit** for state management.

Follow this pattern for every feature — it keeps the codebase consistent, modular, and scalable.

---

## Directory Structure

Every feature lives in its own directory under `lib/features/`:

```text
lib/features/<feature_name>/
  ├── domain/
  │   ├── entities/        ← Freezed models (State & entities)
  │   └── repositories/    ← Abstract contracts/interfaces
  ├── data/
  │   ├── sources/         ← Remote (Dio) & local (Cache) data sources
  │   └── repositories/    ← Concrete repository implementations (pure Dart)
  └── presentation/
      ├── cubits/          ← Cubits and Freezed State classes
      └── screens/          ← UI Screens & Widgets using BlocBuilder/BlocListener
```

---

## Step 1 — Create the Domain Entity

Every feature starts with its **domain model** — an immutable data model defined using `freezed`.

**File:** `lib/features/posts/domain/entities/post.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
abstract class Post with _$Post {
  const factory Post({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
```

---

## Step 2 — Define the Repository Contract

The domain layer **never** knows about network libraries, storage, or state management. It only declares **what** can be done in the form of an interface contract.

**File:** `lib/features/posts/domain/repositories/post_repository.dart`

```dart
import '../entities/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
  Future<Post> createPost(Post post);
  Future<void> deletePost(int id);
}
```

---

## Step 3 — Implement the Data Source

Implement remote (API Calls via Dio) or local (DB/Cache) data sources.

**File:** `lib/features/posts/data/sources/post_remote_data_source.dart`

```dart
import 'package:dio/dio.dart';
import '../../domain/entities/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts();
  Future<Post> getPostById(int id);
  Future<Post> createPost(Post post);
  Future<void> deletePost(int id);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final Dio dio;

  PostRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Post>> getPosts() async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts');
    return (response.data as List)
        .map((json) => Post.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Post> getPostById(int id) async {
    final response = await dio.get('https://jsonplaceholder.typicode.com/posts/$id');
    return Post.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<Post> createPost(Post post) async {
    final response = await dio.post(
      'https://jsonplaceholder.typicode.com/posts',
      data: post.toJson(),
    );
    return Post.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deletePost(int id) async {
    await dio.delete('https://jsonplaceholder.typicode.com/posts/$id');
  }
}
```

---

## Step 4 — Implement the Repository (Pure Dart)

The repository coordinates interactions between data sources. It is a pure Dart class requiring no framework annotations.

**File:** `lib/features/posts/data/repositories/post_repository_impl.dart`

```dart
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../sources/post_remote_data_source.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;

  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Post>> getPosts() => remoteDataSource.getPosts();

  @override
  Future<Post> getPostById(int id) => remoteDataSource.getPostById(id);

  @override
  Future<Post> createPost(Post post) => remoteDataSource.createPost(post);

  @override
  Future<void> deletePost(int id) => remoteDataSource.deletePost(id);
}
```

---

## Step 5 — Create the Cubit & State

### 5A — Define States using Freezed

**File:** `lib/features/posts/presentation/cubits/posts_state.dart`

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/post.dart';

part 'posts_state.freezed.dart';

@freezed
class PostsState with _$PostsState {
  const factory PostsState.initial() = _Initial;
  const factory PostsState.loading() = _Loading;
  const factory PostsState.success(List<Post> posts) = _Success;
  const factory PostsState.error(String message) = _Error;
}
```

### 5B — Implement the Cubit

**File:** `lib/features/posts/presentation/cubits/posts_cubit.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/post_repository.dart';
import 'posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final PostRepository postRepository;

  PostsCubit({required this.postRepository}) : super(const PostsState.initial());

  Future<void> loadPosts() async {
    emit(const PostsState.loading());
    try {
      final posts = await postRepository.getPosts();
      emit(PostsState.success(posts));
    } catch (e) {
      emit(PostsState.error(e.toString()));
    }
  }

  Future<void> deletePost(int id) async {
    try {
      await postRepository.deletePost(id);
      loadPosts(); // Reload list after deletion
    } catch (e) {
      emit(PostsState.error(e.toString()));
    }
  }
}
```

---

## Step 6 — Register Providers in `main.dart`

Instantiate dependencies and wrap the application using `RepositoryProvider` and `BlocProvider` in the app's root.

**File:** `lib/main.dart`

```dart
// Inside main()
final dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 10)));
final postRemoteDataSource = PostRemoteDataSourceImpl(dio);
final postRepository = PostRepositoryImpl(postRemoteDataSource);

runApp(
  MultiRepositoryProvider(
    providers: [
      RepositoryProvider<AuthRepository>.value(value: authRepository),
      RepositoryProvider<PostRepository>.value(value: postRepository), // <-- 1. Register Repository
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepository: authRepository)..checkSession(),
        ),
        BlocProvider<PostsCubit>(
          create: (context) => PostsCubit(
            postRepository: RepositoryProvider.of<PostRepository>(context), // <-- 2. Inject Repository to Cubit
          )..loadPosts(), // <-- 3. Trigger initial action
        ),
      ],
      child: const MyApp(),
    ),
  ),
);
```

---

## Step 7 — Build the UI Screen

Use `BlocBuilder`, `BlocListener`, or `BlocConsumer` from `flutter_bloc` to consume your state and render UI components.

**File:** `lib/features/posts/presentation/screens/posts_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/widgets/app_widgets.dart';
import '../cubits/posts_cubit.dart';
import '../cubits/posts_state.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<PostsCubit>().loadPosts(),
          ),
        ],
      ),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const AppLoadingIndicator(message: 'Fetching posts...'),
            error: (message) => AppEmptyState(
              icon: Icons.error_outline,
              title: 'Something went wrong',
              subtitle: message,
              actionLabel: 'Retry',
              onAction: () => context.read<PostsCubit>().loadPosts(),
            ),
            success: (posts) => posts.isEmpty
                ? const AppEmptyState(
                    icon: Icons.article_outlined,
                    title: 'No Posts Found',
                    subtitle: 'There are no posts to display.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return AppCard(
                        variant: AppCardVariant.outlined,
                        child: ListTile(
                          leading: const Icon(Icons.article_outlined),
                          title: Text(post.title),
                          subtitle: Text(post.body),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () => context.read<PostsCubit>().deletePost(post.id),
                          ),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
```

---

## Step 8 — Run Code Generation

Run build_runner to generate the `.freezed.dart` and `.g.dart` code:

```bash
dart run build_runner build
```

---

## Step 9 — Register Route

Add the GoRoute to your `appRouter` list.

**File:** `lib/core/router/app_router.dart`

```dart
import '../../features/posts/presentation/screens/posts_screen.dart';

// Inside the GoRouter routes list:
GoRoute(
  path: '/posts',
  builder: (context, state) => const PostsScreen(),
),
```

Navigate to it from any screen using:
```dart
context.push('/posts');
```

---

## Summary Checklist for New Features

- [ ] **1. Entities:** Define `@freezed` models in `domain/entities/`
- [ ] **2. Repository Interface:** Create abstract class in `domain/repositories/`
- [ ] **3. Data Source:** Implement remote/local data source in `data/sources/`
- [ ] **4. Repository Implementation:** Implement domain repository contract in `data/repositories/`
- [ ] **5. Cubit & State:** Create Cubit and Freezed State files in `presentation/cubits/`
- [ ] **6. DI Registration:** Register RepositoryProvider and BlocProvider in `main.dart`
- [ ] **7. Generate Code:** Run `dart run build_runner build`
- [ ] **8. UI Implementation:** Design pages/screens in `presentation/screens/`
- [ ] **9. Router Navigation:** Define GoRoute inside `app_router.dart` and navigate!
