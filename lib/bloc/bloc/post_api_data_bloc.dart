import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:form_view/bloc/bloc/post_api_data_event.dart';
import 'package:form_view/bloc/bloc/post_api_data_state.dart';
import 'package:form_view/bloc/model/data_model.dart';
import 'package:form_view/bloc/repo/post_repo.dart';
import 'package:http/http.dart' as http;

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostsInitialFetchEvent>(postsInitialFetchEvent);
    on<PostAddEvent>(postAddEvent);
  }

  FutureOr<void> postsInitialFetchEvent(
      PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
    emit(PostsFetchingLoadingState());

    List<PostDataUiModel> posts = await PostsRepo.fetchPosts();

    emit(PostFetchingSuccessfulState(posts: posts));
  }

  FutureOr<void> postAddEvent(
      PostAddEvent event, Emitter<PostsState> emit) async {
    bool success = await PostsRepo.addPost();

    if (success) {
      emit(PostsAdditionSuccessState());
    } else {
      emit(PostsAdditionErrorState());
    }
  }
}
