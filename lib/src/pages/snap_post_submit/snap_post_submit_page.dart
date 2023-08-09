import 'package:cheese_client/src/common/option.dart';
import 'package:cheese_client/src/components/ui/common/header.dart';
import 'package:cheese_client/src/components/ui/common/aspect_ratio_image.dart';
import 'package:cheese_client/src/constants/lat_lng.dart';
import 'package:cheese_client/src/entities/snap_post/tag_options.dart';
import 'package:cheese_client/src/hooks/domain/address/use_search_address.dart';
import 'package:cheese_client/src/hooks/domain/snap_post/use_create_snap_post.dart';
import 'package:cheese_client/src/hooks/helper/use_form_key.dart';
import 'package:cheese_client/src/hooks/helper/use_mutation.dart';
import 'package:cheese_client/src/hooks/io/file_result.dart';
import 'package:cheese_client/src/hooks/io/use_upload_file.dart';
import 'package:cheese_client/src/pages/snap_post_submit/category_select_dialog.dart';
import 'package:cheese_client/src/pages/snap_post_submit/map_modal.dart';
import 'package:cheese_client/src/repositories/address/params/search_address_params.dart';
import 'package:cheese_client/src/repositories/snap_post/params/snap_post_params.dart';
import 'package:cheese_client/src/router/page_routes.dart';
import 'package:cheese_client/src/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_use_geolocation/flutter_use_geolocation.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';

class SnapPostSubmitPage extends HookConsumerWidget {
  const SnapPostSubmitPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutation = useCreateSnapPost(ref);
    final titleController = useTextEditingController();
    final commentController = useTextEditingController();
    final formKey = useFormKey();
    final fileMutation = useUploadFile(ref);
    final uploadedFiles = useState<List<FileResult>>([]);
    final pickedLatLng = useState<LatLng?>(null);
    final geolocation = useGeolocation();
    final selectedTagOption = useState<List<Option>>([]);
    final searchMutation = useSearchAddress(ref);
    final searchedAddress = useState<String>('');

    Future<void> onSubmit() async {
      if (!formKey.currentState!.validate()) return;
      if (uploadedFiles.value.isEmpty) {
        // TODO: 写真が0枚との時ダイアログを出す
        return;
      }
      if (pickedLatLng.value == null) {
        // TODO: 場所が選択されていない時ダイアログを出す
        return;
      }
      final params = CreateSnapPostParams(
        title: titleController.text,
        comment: commentController.text,
        longitude: pickedLatLng.value!.longitude,
        latitude: pickedLatLng.value!.latitude,
        postImages: uploadedFiles.value
            .map((file) => PostImage(imagePath: file.url))
            .toList(),
        tags: selectedTagOption.value.map((e) => e.value).toList(),
        address: searchedAddress.value,
      );

      await mutation.mutate(
          params: params,
          option: MutationOption(onSuccess: (_) {
            context.go(PageRoutes.home);
          }, onError: (e) {
            print(e);
          }));
    }

    Future<void> onBack() async {
      context.pop();
    }

    void addFile(FileResult file) {
      uploadedFiles.value = [...uploadedFiles.value, file];
    }

    Future<void> onUpload() async {
      await fileMutation.mutate(
          params: 'snapShots',
          option: MutationOption(
            onSuccess: (file) {
              if (file == null) return;
              addFile(file);
            },
            onError: (e) {
              print(e);
            },
          ));
    }

    void onPickedLatLng(LatLng latLng) {
      searchMutation.mutate(
          params: SearchAddressParams(
              latitude: latLng.latitude, longitude: latLng.longitude),
          option: MutationOption(onSuccess: (address) {
            pickedLatLng.value = latLng;
            searchedAddress.value = address;
            context.pop();
          }, onError: (e) {
            print(e);
            searchedAddress.value = '住所不明';
            // TODO: 住所が取得できないかったことを伝える
            context.pop();
          }));
    }

    void onTapPlace() async {
      showModalBottomSheet(
          context: context,
          // NOTE: trueにしないと、Containerのheightが反映されない
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          builder: (BuildContext context) {
            return MapModal(
                onPickedLatLng: onPickedLatLng,
                onPressedClose: () => context.pop(),
                initialLatLng: pickedLatLng.value ??
                    LatLng(
                        geolocation.position?.latitude ?? tokyoLatLng.latitude,
                        geolocation.position?.longitude ??
                            tokyoLatLng.longitude));
          });
    }

    void onTapCategory() {
      showDialog<void>(
          context: context,
          builder: (_) {
            return CategorySelectDialog(
              options: tagOptions.options,
              selectedOptions: selectedTagOption.value,
              onClose: () => context.pop(),
              onSubmit: (value) {
                selectedTagOption.value = value;
                context.pop();
              },
            );
          });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: Header(
          title: '投稿',
          actions: [
            TextButton(
              onPressed: onSubmit,
              child: const Text('保存',
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            children: [
              _titleInputField(titleController),
              _placeForm(onTap: onTapPlace, address: searchedAddress.value),
              _categoryForm(
                onTap: onTapCategory,
                categories:
                    selectedTagOption.value.map((e) => e.label).toList(),
              ),
              _commentInputField(commentController),
              const SizedBox(height: 16),
              _imageList(
                  imageUrls: uploadedFiles.value.map((e) => e.url).toList()),
              const SizedBox(height: 16),
              _uploadButton(onPressed: onUpload),
            ],
          ),
        )));
  }

  Widget _titleInputField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      validator: (value) => FormValidator.validateRequired(value, 'タイトル'),
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'タイトル',
        contentPadding: EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _commentInputField(TextEditingController controller) {
    return TextFormField(
        controller: controller,
        decoration: const InputDecoration(
          border: UnderlineInputBorder(),
          labelText: 'コメント',
          contentPadding: EdgeInsets.all(16.0),
        ),
        maxLines: 4);
  }

  Widget _eventForm({required VoidCallback onTap, required String text}) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        height: 68,
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 320,
                child: Text(text,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const Icon(
                Icons.keyboard_arrow_right_outlined,
                color: Colors.black,
              )
            ],
          ),
        ));
  }

  Widget _placeForm({required VoidCallback onTap, required String address}) {
    final filedText = address.isEmpty ? '場所' : address;
    return _eventForm(onTap: onTap, text: filedText);
  }

  Widget _categoryForm(
      {required VoidCallback onTap, required List<String> categories}) {
    final String filedText =
        categories.isEmpty ? 'カテゴリー' : categories.join(', ');
    return _eventForm(onTap: onTap, text: filedText);
  }

  Widget _imageList({required List<String> imageUrls}) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: AspectRatioImage(image: imageUrls[index]));
        },
      ),
    );
  }

  Widget _uploadButton({required VoidCallback onPressed}) {
    return OutlinedButton(
        // まるくする
        style: OutlinedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 8.0, left: 32.0, right: 32.0),
          side: const BorderSide(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        onPressed: onPressed,
        child: const Text('写真を追加',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )));
  }
}
