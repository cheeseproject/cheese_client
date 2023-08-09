import 'package:cheese_client/src/hooks/helper/use_form_key.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/hooks/io/use_upload_file.dart';
import 'package:cheese_client/src/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const minSearchRadiusInM = 0;
const maxSearchRadiusInM = 50000;

class ProfileSettingModal extends HookConsumerWidget {
  final VoidCallback onPressedClose;
  final VoidCallback onPressedSignOut;

  final void Function({
    required String name,
    required String imageUrl,
    required double searchedRadiusInM,
  }) onSubmit;
  final String imageUrl;
  final String userName;
  final int searchedRadiusInM;
  const ProfileSettingModal({
    Key? key,
    required this.onPressedClose,
    required this.onPressedSignOut,
    required this.onSubmit,
    required this.imageUrl,
    required this.userName,
    required this.searchedRadiusInM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedRadiusInMState = useState<int>(searchedRadiusInM);
    final imageUrlState = useState<String>(imageUrl);
    final nameTextController = useTextEditingController(text: userName);
    final formKey = useFormKey();
    // HACK: 子コンポーネントで定義するのはよくない。テストが書きづらいため
    final fileMutation = useUploadFile(ref);

    String searchRadiusText = useMemoized(() {
      if (searchedRadiusInMState.value < 1000) {
        return '${searchedRadiusInMState.value}m';
      }
      return '${(searchedRadiusInMState.value / 1000).toStringAsFixed(1)}km';
    }, [searchedRadiusInMState.value]);

    void onSubmitProfile() {
      if (!formKey.currentState!.validate()) return;
      onSubmit(
        name: nameTextController.text,
        imageUrl: imageUrlState.value,
        searchedRadiusInM: searchedRadiusInMState.value.toDouble(),
      );
    }

    Future<void> onUpload() async {
      await fileMutation.mutate(
          params: 'users',
          option: MutationOption(
            onSuccess: (file) {
              if (file == null) return;
              imageUrlState.value = file.url;
            },
            onError: (e) {
              print(e);
            },
          ));
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.55,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
      child: Column(children: [
        _header(onPressedClose: onPressedClose, onSubmit: onSubmitProfile),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(height: 8.0),
        _editIcon(onTap: onUpload, imageUrl: imageUrlState.value),
        const SizedBox(height: 8.0),
        Form(
          key: formKey,
          child: _nameInputField(controller: nameTextController),
        ),
        const SizedBox(height: 24.0),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('現在地から',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(searchRadiusText,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Slider(
          value: searchedRadiusInMState.value.toDouble(),
          min: minSearchRadiusInM.toDouble(),
          max: maxSearchRadiusInM.toDouble(),
          divisions: 100,
          label: searchRadiusText,
          onChanged: (double value) {
            searchedRadiusInMState.value = value.toInt();
          },
        ),
        const Spacer(),
        _signOutButton(
          onPressed: onPressedSignOut,
        )
      ]),
    );
  }

  Widget _header(
      {required VoidCallback onPressedClose, required VoidCallback onSubmit}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Container(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: onPressedClose,
            icon: const Icon(Icons.close),
          ),
        )),
        const Expanded(
          child: Text(
            "設定",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
            child: Container(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: onSubmit,
            child: const Text('保存',
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        )),
      ],
    );
  }

  Widget _editIcon({required VoidCallback onTap, required String imageUrl}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // アバター（仮のウィジェット、実際のアバター画像を使用してください）
          CircleAvatar(
            radius: 42,
            backgroundImage: NetworkImage(imageUrl),
          ),
          // カメラアイコン
          Positioned(
            right: 0,
            bottom: 0,
            child: Icon(
              Icons.camera_alt,
              color: Colors.black.withOpacity(0.5),
              size: 24,
            ),
          ),
          // 編集テキスト
        ],
      ),
    );
  }

  Widget _nameInputField({required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      validator: (value) => FormValidator.validateRequired(value, 'ニックネーム'),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'ニックネーム',
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _signOutButton({required VoidCallback onPressed}) {
    return TextButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text('ログアウト',
            style: TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)));
  }
}
