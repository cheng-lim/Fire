import 'package:code_text_field/code_text_field.dart';
import 'package:fire_dev/ide/constants/color.dart';
import 'package:fire_dev/ide/drawers/database_config_drawer.dart';
import 'package:fire_dev/ide/utils/string_utility.dart';
import 'package:fire_dev/ide/widgets/tooltip_elevated_button.dart';
import 'package:fire_dev/ide/widgets/tooltip_icon_button.dart';
import 'package:fire_dev/interpreter/interpreter.dart';
import 'package:fire_dev/interpreter/model/response.dart';
import 'package:flutter/material.dart';
// Import the language & theme
import 'package:flutter_highlight/themes/monokai-sublime.dart';
import 'package:highlight/languages/dart.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  // Create a GlobalKey for the CodeEditor Widget
  final GlobalKey<_CodeEditorState> editorKey = GlobalKey<_CodeEditorState>();
  // Create a controller for Output Console
  final TextEditingController _outputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called

    // Get the screen height
    double screenHeight = MediaQuery.of(context).size.height;
    // Calculate maxLines based on screen height
    int maxLines = (screenHeight / 29).floor();

    return Scaffold(
      endDrawer: const DatabaseConfigDrawer(),
      body: Row(
        children: [
          // AppBar and Editor
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                // AppBar
                AppBar(
                  backgroundColor: sideColor,
                  // title
                  title: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.local_fire_department_sharp,
                          size: 25,
                        ),
                        onPressed: () {},
                        color: Colors.white,
                      ),
                      const Text(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        'Fire Thrower',
                      ),
                    ],
                  ),
                  actions: [
                    // Database Configuration
                    const TooltipIconButton(
                      message: 'Database Configuration',
                      iconData: Icons.settings_outlined,
                      destination: Destination.endDrawer,
                    ),
                    // Documentation
                    const TooltipIconButton(
                      message: 'Documentation',
                      iconData: Icons.help_outline_rounded,
                      destination: Destination.tab,
                      url:
                          'https://clin.notion.site/94edc14db3114978bdb0ab7894941abc?v=52f0a6deccb940da8870717983f3d5a3',
                    ),

                    // Run Button
                    TooltipElevatedButton(
                      message: 'Run the script',
                      function: () async {
                        // Access the text using the GlobalKey
                        final text = editorKey.currentState?.getText() ?? "";
                        // Get all lines
                        final textLines = text.split('\n');

                        // Check if all lines contain semicolon at the end
                        bool hasEndSemicolonInEveryLines = true;
                        for (final line in textLines) {
                          // Remove spaces at the end of the line
                          String rightTrimmedLine =
                              line.replaceAll("·", " ").trimRight();

                          // line without semicolon.
                          if (rightTrimmedLine != "") {
                            String lastCharacter =
                                rightTrimmedLine[rightTrimmedLine.length - 1];
                            if (lastCharacter != ";") {
                              hasEndSemicolonInEveryLines = false;
                            }
                          }
                        }

                        // Call interpreter
                        if (hasEndSemicolonInEveryLines) {
                          // Call the Parser for all lines (all commands)
                          MainParser parser = MainParser();
                          _outputController.text = "";
                          for (final line in textLines) {
                            // Remove spaces at the end of the line
                            String rightTrimmedLine =
                                line.replaceAll("·", " ").trimRight();

                            // Ignore lines only with spaces.
                            if (rightTrimmedLine != "") {
                              Response res =
                                  await parser.parse(rightTrimmedLine);

                              // Output the result to the console.
                              String output = StringUtility.restyleOutput(res);
                              _outputController.text =
                                  "${_outputController.text}$output\n";
                            }
                          }
                        } else {
                          _showNoSemicolonMessage(
                              context); // Call the function to show the message box
                        }
                      },
                      text: 'Run',
                    ),
                  ],
                ),
                // Editor
                Expanded(child: CodeEditor(key: editorKey)),
              ],
            ),
          ),
          // Output Console
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: containerColor,
                border: Border(
                  left: BorderSide(
                    color: sideColor,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: TextField(
                      controller: _outputController,
                      decoration: const InputDecoration.collapsed(
                          hintText: "(Output area)",
                          hintStyle: TextStyle(color: Colors.grey)),
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18.0),
                      readOnly: true,
                      maxLines: maxLines,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNoSemicolonMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hint'),
          content: const Text(
              'A single line needs to be a single command (which contains a semicolon as the last character).'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class CodeEditor extends StatefulWidget {
  const CodeEditor({super.key});

  @override
  State<CodeEditor> createState() => _CodeEditorState();
}

class _CodeEditorState extends State<CodeEditor> {
  CodeController? _codeController;

  @override
  void initState() {
    super.initState();
    const source = "cities.get();\ncities.where(population >= 2000000).get();";
    // Instantiate the CodeController
    _codeController = CodeController(
      text: source,
      language: dart,
      theme: monokaiSublimeTheme,
    );
  }

  @override
  void dispose() {
    _codeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CodeField(
      controller: _codeController!,
      textStyle: const TextStyle(fontFamily: 'SourceCode'),
      background: containerColor,
    );
  }

  String getText() {
    return _codeController!.text;
  }
}
