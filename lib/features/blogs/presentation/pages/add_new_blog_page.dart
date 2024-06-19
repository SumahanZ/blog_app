import 'package:blog_app/core/theme/pallete.dart';
import 'package:blog_app/features/blogs/presentation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

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
  List<String> selectedTopics = [];

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
          onPressed: () {},
          icon: const Icon(Icons.done_rounded),
        )
      ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            DottedBorder(
              radius: const Radius.circular(10),
              borderType: BorderType.RRect,
              color: AppPallete.borderColor,
              strokeCap: StrokeCap.round,
              dashPattern: const [10, 4],
              child: const SizedBox(
                height: 150,
                width: double.infinity,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 40),
                      SizedBox(height: 15),
                      Text("Select your image", style: TextStyle(fontSize: 15))
                    ]),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  "Technology",
                  "Business",
                  "Programming",
                  "Entertainment",
                ]
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
                controller: _blogTitleController, hintText: "Blog title"),
            const SizedBox(height: 10),
            BlogEditor(
                controller: _contentController, hintText: "Blog content"),
          ]),
        ),
      ),
    );
  }
}
