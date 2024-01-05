import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/data/enum_type/gender.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/user_model.dart';
import 'package:firefly/data/model/user_work_model.dart';
import 'package:firefly/screens/ticket_group_screen/edit_ticket_screen/bloc/edit_ticket_bloc.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:rxdart/rxdart.dart';
import 'package:textfield_tags/textfield_tags.dart';

class SearchUserTagField extends StatefulWidget {
  const SearchUserTagField({
    super.key,
    required this.searchUserWork,
    required this.users,
    required this.textController,
    required this.onTagDelete,
    required this.selectedUser,
    required this.tagController,
  });
  final Function(String) searchUserWork;
  final List<UserWorkModel> users;
  final TextEditingController textController;
  final TextfieldTagsController tagController;
  final Function onTagDelete;
  final Function(UserWorkModel) selectedUser;

  @override
  State<SearchUserTagField> createState() => _SearchUserTagFieldState();
}

class _SearchUserTagFieldState extends State<SearchUserTagField> {
  final borderContainer = BoxDecoration(
    color: Colors.grey.shade100,
    // border: Border.all(color: COLOR_CONST.cloudBurst),
    borderRadius: BorderRadius.circular(8),
  );
  late TextfieldTagsController tagController;

  List<UserWorkModel> users = [];

  final textSearchChange = BehaviorSubject<String>();

  @override
  void dispose() {
    tagController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    tagController = widget.tagController;
    users = widget.users;
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
      widget.searchUserWork(textSearch);
    });
  }

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    print('rebuild 2');
    users = widget.users;
    // print('go heeee');
    // print(users);
    return Container(
      constraints: BoxConstraints(maxWidth: SizeConfig.screenWidthMax),
      child: Container(
        decoration: borderContainer,
        child: RawAutocomplete<UserWorkModel>(
          focusNode: _focusNode,
          optionsViewBuilder: (context, onSelected, _) {
            print('123');
            return _suggetUserListView(
                onSelected: onSelected, users: widget.users);
          },
          textEditingController: widget.textController,
          displayStringForOption: (option) => option.user?.fullname ?? '',
          optionsBuilder: (textEditingValue) {
            if (widget.textController.text == '') {
              return [];
            }
            print(users.length);
            return users;
          },
          onSelected: (UserWorkModel selection) {
            if (!(tagController.getTags ?? [])
                .contains(selection.user!.email)) {
              tagController.clearTags();

              tagController.onSubmitted(selection.user!.email);
              widget.textController.text = '';
              FocusScope.of(context).unfocus();
              widget.selectedUser(selection);
            } else {
              widget.textController.text = '';
              FocusScope.of(context).unfocus();
            }
          },
          fieldViewBuilder:
              (context, textEditingController, focusNode, onFieldSubmitted) {
            return _inputSearchView(
                tagsController: tagController,
                textEditingController: textEditingController,
                focusNode: focusNode);
          },
        ),
      ),
    );
  }

  Widget _inputSearchView(
      {required TextEditingController textEditingController,
      required TextfieldTagsController tagsController,
      required FocusNode focusNode}) {
    return TextFieldTags(
      textEditingController: textEditingController,
      textfieldTagsController: tagController,
      // textSeparators: const [' '],
      letterCase: LetterCase.normal,
      initialTags: [],
      validator: (tag) {},
      inputfieldBuilder: (context, textEditingTagController, focusNodeTags,
          error, onChanged, onSubmitted) {
        return (context, scrollController, tags, onTagDelete) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: const Icon(
                  Icons.search,
                  color: COLOR_CONST.cloudBurst,
                  size: 22,
                ),
              ),
              if (tags.isNotEmpty)
                Container(
                  padding: const EdgeInsets.only(right: 5),
                  alignment: Alignment.topLeft,
                  child: Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      children: tags.map((String tag) {
                        return tagItem(tag, onTagDelete);
                      }).toList()),
                ),
              Expanded(
                child: CustomTextFormField(
                  focusNode: focusNode,
                  controller: textEditingController,
                  contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  hintText: tagsController.hasTags ? '' : 'name'.tr(),
                  keyboardType: TextInputType.text,
                  onFieldSubmitted: (p0) {},
                  onEditingComplete: () {},
                  borderContainer: true,
                ),
              ),
            ],
          );
        };
      },
    );
  }

  Widget _suggetUserListView(
      {required Function(UserWorkModel) onSelected,
      required List<UserWorkModel> users}) {
    return Container(
      margin: const EdgeInsets.only(top: 2),
      child: Align(
        alignment: Alignment.topLeft,
        child: Material(
          elevation: 3,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          shadowColor: COLOR_CONST.black,
          color: COLOR_CONST.white,
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: 200,
                maxWidth: SizeConfig.screenWidth > SizeConfig.screenWidthMax
                    ? SizeConfig.screenWidthMax
                    : SizeConfig.screenWidth - 40),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (BuildContext context, int index) {
                log('${index}');
                final fullname = users[index].user?.fullname;

                final email = users[index].user?.email;
                return GestureDetector(
                  onTap: () {
                    onSelected(users[index]);
                  },
                  child: Container(
                    color: Colors.transparent,
                    height: 50,
                    padding: const EdgeInsets.only(right: 15, left: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: fullname),
                                TextSpan(text: '  '),
                                TextSpan(text: '( '),
                                TextSpan(text: email),
                                TextSpan(text: ' )'),
                              ],
                            ),
                            style: FONT_CONST.regular(
                                color: COLOR_CONST.cloudBurst, fontSize: 16),
                          ),
                        ),
                        if ((tagController.getTags ?? [])
                            .contains(users[index].user?.email))
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
              widget.onTagDelete();
            },
          )
        ],
      ),
    );
  }
}
