import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/user_work_infomation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:rxdart/rxdart.dart';

class SearchUserField extends StatefulWidget {
  const SearchUserField({
    super.key,
    required this.textController,
    required this.onSelectedUser,
    required this.textSearchChange,
    this.users,
    this.userWorkModel,
  });
  final TextEditingController textController;

  final Function(UserWorkModel) onSelectedUser;
  final Function(String) textSearchChange;
  final List<UserWorkModel>? users;
  final UserWorkModel? userWorkModel;

  @override
  State<SearchUserField> createState() => _SearchUserFieldState();
}

class _SearchUserFieldState extends State<SearchUserField> {
  final borderContainer = BoxDecoration(
    color: Colors.grey.shade100,
    borderRadius: BorderRadius.circular(8),
  );
  final errorBorderContainer = BoxDecoration(
    border: Border.all(color: COLOR_CONST.carnation),
    borderRadius: BorderRadius.circular(8),
  );

  final textSearchChange = BehaviorSubject<String>();
  List<UserWorkModel> users = [];
  UserWorkModel? selectedUser;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    users = widget.users ?? [];
    selectedUser = widget.userWorkModel;
    widget.textController.addListener(() async {
      {
        textSearchChange.value = widget.textController.text;
      }
    });

    textSearchChange
        .debounceTime(const Duration(milliseconds: 100))
        .distinct()
        .listen((searchText) {
      final textSearch = searchText.trim();
      widget.textSearchChange(textSearch);
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    users = widget.users ?? [];
    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidthMax),
      child: Container(
        decoration: borderContainer,
        child: RawAutocomplete<UserWorkModel>(
          focusNode: _focusNode,
          optionsViewBuilder: (context, onSelected, _) {
            return _suggetUserListView(
                onSelected: onSelected, selectedUser: widget.userWorkModel);
          },
          textEditingController: widget.textController,
          displayStringForOption: (option) => option.user?.fullname ?? '',
          optionsBuilder: (textEditingValue) {
            if (textEditingValue.text.trim().isEmpty) {
              return [];
            }
            return users;
          },
          onSelected: (UserWorkModel selection) {
            widget.onSelectedUser(selection);
            widget.textController.text = '';
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return _inputSearchView(
                textEditingController: textEditingController,
                focusNode: focusNode);
          },
        ),
      ),
    );
  }

  Widget _inputSearchView(
      {required TextEditingController textEditingController,
      required FocusNode focusNode}) {
    return CustomTextFormField(
      focusNode: focusNode,
      controller: textEditingController,
      contentPadding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 15,
      ),
      hintText: 'name'.tr(),
      keyboardType: TextInputType.text,
      textStyle: FONT_CONST.regular(),
      validator: (value) {},
      onFieldSubmitted: (p0) {},
      onEditingComplete: () {},
      borderContainer: true,
      suffixIcon: Container(
        padding: const EdgeInsets.all(8),
        child: const Icon(
          Icons.search,
          color: COLOR_CONST.cloudBurst,
          size: 22,
        ),
      ),
    );
  }

  Widget _suggetUserListView(
      {required Function(UserWorkModel) onSelected,
      UserWorkModel? selectedUser}) {
    if (users.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 2),
        child: Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 3,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            shadowColor: COLOR_CONST.black,
            color: COLOR_CONST.backgroundColor,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: 200,
                  maxWidth: SizeConfig.screenWidth > SizeConfig.screenWidthMax
                      ? SizeConfig.screenWidthMax
                      : SizeConfig.screenWidth - 40),
              child: ListView.separated(
                padding: EdgeInsets.zero,
                separatorBuilder: (context, index) => const Divider(height: 1),
                shrinkWrap: true,
                itemCount: users.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      onSelected(users[index]);
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: defaultPadding(horizontal: 15, vertical: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: UserInfomationWork(
                              userWorkModel: users[index],
                            ),
                          ),
                          if (users[index].id == selectedUser?.id)
                            SvgPicture.asset(
                              ICON_CONST.icCheckAccept.path,
                              color: COLOR_CONST.cloudBurst,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Container tagItem(String tag, void Function(String tag) onTagDelete) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
          color: COLOR_CONST.cloudBurst),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: FONT_CONST.regular(
                color: COLOR_CONST.backgroundColor, fontSize: 14),
          ),
          const HorizontalSpacing(of: 4),
          InkWell(
            child: const Icon(
              Icons.cancel,
              size: 14,
              color: Color.fromARGB(255, 233, 233, 233),
            ),
            onTap: () {
              onTagDelete(tag);
            },
          )
        ],
      ),
    );
  }
}
