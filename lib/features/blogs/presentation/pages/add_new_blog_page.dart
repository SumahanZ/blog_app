import 'dart:io';

import 'package:blog_app/core/common/cubits/logged_status_cubit.dart';
import 'package:blog_app/core/common/widgets/loader.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/pallete.dart';
import 'package:blog_app/core/utils/pick_image.dart';
import 'package:blog_app/core/utils/show_snackbar.dart';
import 'package:blog_app/features/blogs/presentation/bloc/blog_bloc.dart';
import 'package:blog_app/features/blogs/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blog_editor.dart';
import 'package:blog_app/injection_part.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const AddNewBlogPage(),
      );
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final TextEditingController _blogTitleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<String> selectedTopics = [];
  File? image;

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void uploadBlog() {
    if (_formKey.currentState!.validate() &&
        selectedTopics.length > 1 &&
        image != null) {
      final userId = (DependencyInjector.getIt<LoggedStatusCubit>().state
              as LoggedStatusStateInitialLoggedIn)
          .user
          .id;
      DependencyInjector.getIt<BlogBloc>().add(BlogUploadEvent(
          authorId: userId,
          title: _blogTitleController.text.trim(),
          content: _contentController.text.trim(),
          image: image!,
          topics: selectedTopics));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _blogTitleController.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          onPressed: uploadBlog,
          icon: const Icon(Icons.done_rounded),
        )
      ]),
      body: BlocConsumer<BlogBloc, BlogState>(
        bloc: DependencyInjector.getIt<BlogBloc>(),
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
                context, BlogPage.route(), (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      image != null
                          ? GestureDetector(
                              onTap: selectImage,
                              child: SizedBox(
                                  height: 200,
                                  width: double.infinity,
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.file(image!,
                                          fit: BoxFit.cover))),
                            )
                          : GestureDetector(
                              onTap: selectImage,
                              child: DottedBorder(
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                color: AppPallete.borderColor,
                                strokeCap: StrokeCap.round,
                                dashPattern: const [10, 4],
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.folder_open, size: 40),
                                        SizedBox(height: 15),
                                        Text("Select your image",
                                            style: TextStyle(fontSize: 15))
                                      ]),
                                ),
                              ),
                            ),
                      const SizedBox(height: 20),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: Constants.topics
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopics.contains(e)) {
                                        selectedTopics.remove(e);
                                      } else {
                                        selectedTopics.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      color: selectedTopics.contains(e)
                                          ? const MaterialStatePropertyAll(
                                              AppPallete.gradient1)
                                          : null,
                                      label: Text(e),
                                      side: selectedTopics.contains(e)
                                          ? null
                                          : const BorderSide(
                                              color: AppPallete.borderColor),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlogEditor(
                          controller: _blogTitleController,
                          hintText: "Blog title"),
                      const SizedBox(height: 10),
                      BlogEditor(
                          controller: _contentController,
                          hintText: "Blog content"),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}
