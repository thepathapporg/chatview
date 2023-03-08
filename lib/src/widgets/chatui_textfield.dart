/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'dart:io' show File, Platform;

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../chatview.dart';
import '../utils/constants.dart';
import '../utils/package_strings.dart';

class ChatUITextField extends StatefulWidget {
  const ChatUITextField({
    Key? key,
    this.sendMessageConfig,
    required this.focusNode,
    required this.textEditingController,
    required this.onPressed,
    required this.onRecordingComplete,
    required this.onImageSelected,
    required this.onFileSelected,
  }) : super(key: key);

  /// Provides configuration of default text field in chat.
  final SendMessageConfiguration? sendMessageConfig;

  /// Provides focusNode for focusing text field.
  final FocusNode focusNode;

  /// Provides functions which handles text field.
  final TextEditingController textEditingController;

  /// Provides callback when user tap on text field.
  final VoidCallBack onPressed;

  /// Provides callback once voice is recorded.
  final Function(String?) onRecordingComplete;

  /// Provides callback when user select images from camera/gallery.
  final StringsCallBack onImageSelected;

  /// Provides callback when user select images from camera/gallery.
  final StringsCallBack onFileSelected;

  @override
  State<ChatUITextField> createState() => _ChatUITextFieldState();
}

class _ChatUITextFieldState extends State<ChatUITextField> {
  String _inputText = '';

  final ImagePicker _imagePicker = ImagePicker();

  RecorderController? controller;

  bool isRecording = false;

  SendMessageConfiguration? get sendMessageConfig => widget.sendMessageConfig;

  VoiceRecordingConfiguration? get voiceRecordingConfig =>
      widget.sendMessageConfig?.voiceRecordingConfiguration;

  ImagePickerConfiguration? get imagePickerConfig =>
      sendMessageConfig?.imagePickerConfig;

  TextFieldConfiguration? get textFieldConfig =>
      sendMessageConfig?.textFieldConfig;

  OutlineInputBorder get _outLineBorder => OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
      );

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
      controller = RecorderController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          textFieldConfig?.padding ?? const EdgeInsets.symmetric(horizontal: 6),
      margin: textFieldConfig?.margin,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color(0xffE8E8E8),
        ),
        borderRadius: textFieldConfig?.borderRadius ??
            BorderRadius.circular(textFieldBorderRadius),
        color: sendMessageConfig?.textFieldBackgroundColor ?? Colors.white,
      ),
      child: Row(
        mainAxisSize: isRecording && controller != null
            ? MainAxisSize.max
            : MainAxisSize.min,
        children: [
          if (isRecording && controller != null) ...[
            ClipRRect(
              borderRadius: textFieldConfig?.borderRadius ??
                  BorderRadius.circular(textFieldBorderRadius),
              child: AudioWaveforms(
                size: Size(MediaQuery.of(context).size.width * 0.7, 50),
                recorderController: controller!,
                margin: voiceRecordingConfig?.margin,
                padding: voiceRecordingConfig?.padding ??
                    const EdgeInsets.symmetric(horizontal: 8),
                decoration: voiceRecordingConfig?.decoration ??
                    BoxDecoration(
                      color: voiceRecordingConfig?.backgroundColor,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                waveStyle: voiceRecordingConfig?.waveStyle ??
                    WaveStyle(
                      extendWaveform: true,
                      showMiddleLine: false,
                      waveColor: voiceRecordingConfig?.waveStyle?.waveColor ??
                          Colors.black,
                    ),
              ),
            ),
            const Spacer(),
          ] else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isRecording) ...[
                  IconButton(
                    onPressed: () => !Platform.isIOS
                        ? cupertinoImageSelector()
                        : androidImageSelector(),
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xffF7F7F7),
                      child: imagePickerConfig?.galleryImagePickerIcon ??
                          Icon(
                            Icons.image,
                            color: imagePickerConfig?.galleryIconColor,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _onFilePickerPressed(),
                    icon: CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xffF7F7F7),
                      child: imagePickerConfig?.cameraImagePickerIcon ??
                          Icon(
                            Icons.file_open,
                            color: imagePickerConfig?.cameraIconColor,
                          ),
                    ),
                  ),
                ],
              ],
            ),
          if (!isRecording)
            Expanded(
              child: TextField(
                focusNode: widget.focusNode,
                controller: widget.textEditingController,
                style: textFieldConfig?.textStyle ??
                    const TextStyle(
                      color: Colors.white,
                    ),
                maxLines: textFieldConfig?.maxLines ?? 5,
                minLines: textFieldConfig?.minLines ?? 1,
                keyboardType: textFieldConfig?.textInputType,
                inputFormatters: textFieldConfig?.inputFormatters,
                onChanged: _onChanged,
                textCapitalization: textFieldConfig?.textCapitalization ??
                    TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: textFieldConfig?.hintText ?? PackageStrings.message,
                  fillColor: sendMessageConfig?.textFieldBackgroundColor ??
                      Colors.white,
                  filled: true,
                  hintStyle: textFieldConfig?.hintStyle ??
                      TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.25,
                      ),
                  contentPadding: textFieldConfig?.contentPadding ??
                      const EdgeInsets.symmetric(horizontal: 6),
                  border: _outLineBorder,
                  focusedBorder: _outLineBorder,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: textFieldConfig?.borderRadius ??
                        BorderRadius.circular(textFieldBorderRadius),
                  ),
                ),
              ),
            ),
          if (_inputText.isNotEmpty)
            IconButton(
              color: sendMessageConfig?.defaultSendButtonColor ?? Colors.green,
              onPressed: () {
                widget.onPressed();
                setState(() => _inputText = '');
              },
              icon: sendMessageConfig?.sendButtonIcon ?? const Icon(Icons.send),
            ),
          if (_inputText.isEmpty)
            if (widget.sendMessageConfig?.allowRecordingVoice ??
                true && Platform.isIOS && Platform.isAndroid) ...[
              IconButton(
                constraints: const BoxConstraints(maxWidth: 35),
                onPressed: _recordOrStop,
                icon: (isRecording
                        ? voiceRecordingConfig?.micIcon
                        : voiceRecordingConfig?.stopIcon) ??
                    Icon(isRecording ? Icons.stop : Icons.mic),
                color: voiceRecordingConfig?.recorderIconColor,
              ),
              const SizedBox(
                width: 10,
              ),
            ]
        ],
      ),
    );
  }

  void androidImageSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () => _onIconPressed(ImageSource.camera).then(
                      (_) => Navigator.pop(context),
                    ),
                    child: Text(
                      'Camera',
                      style: imagePickerConfig?.textStyle,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _onIconPressed(ImageSource.gallery).then(
                      (_) => Navigator.pop(context),
                    ),
                    child: Text(
                      'Gallery',
                      style: imagePickerConfig?.textStyle,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style:
                      imagePickerConfig?.textStyle?.copyWith(color: Colors.red),
                ),
              ),
            ],
          ),
        ],
        titleTextStyle: imagePickerConfig?.textStyle,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('Select the image source '),
          ],
        ),
      ),
    );
  }

  void cupertinoImageSelector() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          'Select image source',
          style: imagePickerConfig?.textStyle,
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => _onIconPressed(ImageSource.camera).then(
              (_) => Navigator.pop(context),
            ),
            child: Text(
              'Camera',
              style: imagePickerConfig?.textStyle,
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () => _onIconPressed(ImageSource.gallery).then(
              (_) => Navigator.pop(context),
            ),
            child: Text(
              'Gallery',
              style: imagePickerConfig?.textStyle,
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: imagePickerConfig?.textStyle?.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  void _onFilePickerPressed() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        widget.onFileSelected(file.path, '');
      }
    } catch (e) {
      widget.onFileSelected('', e.toString());
    }
  }

  Future<void> _recordOrStop() async {
    assert(
      defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android,
      "Voice messages are only supported with android and ios platform",
    );
    if (!isRecording) {
      await controller?.record();
      isRecording = true;
    } else {
      final path = await controller?.stop();
      isRecording = false;
      widget.onRecordingComplete(path);
    }
    setState(() {});
  }

  Future<void> _onIconPressed(ImageSource imageSource) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: imageSource);
      widget.onImageSelected(image?.path ?? '', '');
    } catch (e) {
      widget.onImageSelected('', e.toString());
    }
  }

  void _onChanged(String inputText) => setState(() => _inputText = inputText);
}
