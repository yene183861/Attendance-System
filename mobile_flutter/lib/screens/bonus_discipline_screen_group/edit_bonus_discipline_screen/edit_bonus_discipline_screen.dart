import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_dropdown_date_picker.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/search_user_tag.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';

import 'package:firefly/data/arguments/edit_bonus_param.dart';
import 'package:firefly/data/enum_type/user_type.dart';
import 'package:firefly/data/model/reward_discipline_model.dart';
import 'package:firefly/data/model/user_work_model.dart';

import 'package:firefly/screens/bonus_discipline_screen_group/edit_bonus_discipline_screen/bloc/edit_bonus_discipline_bloc.dart';
import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:textfield_tags/textfield_tags.dart';

class EditBonusDiscriplineScreen extends StatelessWidget {
  const EditBonusDiscriplineScreen({super.key, required this.arg});
  final EditBonusArgument arg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => EditBonusDisciplineBloc(arg: arg),
          child: const _ScreenForm()),
    );
  }
}

class _ScreenForm extends StatefulWidget {
  const _ScreenForm({Key? key}) : super(key: key);

  @override
  State<_ScreenForm> createState() => _ScreenFormState();
}

class _ScreenFormState extends State<_ScreenForm> {
  late TextEditingController searchController,
      titleController,
      desControler,
      amountController,
      monthController;
  late TextfieldTagsController tagController;

  final _formKey = GlobalKey<FormState>();
  late DateRangePickerController calendarController;

  @override
  void initState() {
    super.initState();
    final state = context.editBonusDisciplineBloc.state;
    tagController = TextfieldTagsController();
    calendarController = DateRangePickerController();
    searchController = TextEditingController();
    titleController =
        TextEditingController(text: state.rewardOrDisModel?.title);
    desControler = TextEditingController(text: state.rewardOrDisModel?.content);
    amountController = TextEditingController(
        text: state.rewardOrDisModel != null
            ? NumberFormat.decimalPattern('vi')
                .format(state.rewardOrDisModel?.amount)
            : '');
    // amountController.text.

    monthController = TextEditingController(
        text: state.rewardOrDisModel != null
            ? Utils.formatDateTimeToString(
                time: state.rewardOrDisModel!.month,
                dateFormat: DateFormat(DateTimePattern.monthYear))
            : '');
  }

  @override
  void dispose() {
    // searchController.dispose();
    tagController.dispose();
    titleController.dispose();
    desControler.dispose();
    amountController.dispose();
    monthController.dispose();
    calendarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditBonusDisciplineBloc, EditBonusDisciplineState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          if (state.message != null && state.message!.isNotEmpty) {
            ToastShowAble.show(
              toastType: ToastMessageType.SUCCESS,
              message: state.message ?? '',
            );
            Navigator.of(context).pop(true);
          }
        } else if (state.status.isSubmissionFailure) {
          LoadingShowAble.forceHide();
          PopupNotificationCustom.showMessgae(
            title: "title_error".tr(),
            message: state.message ?? "",
            hiddenButtonLeft: true,
          );
        } else {
          LoadingShowAble.forceHide();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarDefaultCustom(
              title:
                  context.editBonusDisciplineBloc.state.rewardOrDisModel != null
                      ? context.editBonusDisciplineBloc.state.rewardOrDisModel!
                              .isReward
                          ? 'Thông tin khen thưởng'
                          : 'Thông tin kỷ luật'
                      : 'Thêm mới ',
              isCallBack: true,
            ),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  // InkWell(
                  //   onTap: () {
                  //     showDialog(
                  //         context: context,
                  //         builder: (mContext) => BlocProvider.value(
                  //               value: context.editBonusDisciplineBloc,
                  //               child: Dialog(),
                  //             ));
                  //   },
                  //   child: Ink(
                  //     padding: const EdgeInsets.all(12),
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey.shade100,
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Image.asset(
                  //       ICON_CONST.icFilter1.path,
                  //       width: 22,
                  //       height: 22,
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // const HorizontalSpacing(of: 8),
                  if (context.editBonusDisciplineBloc.state.rewardOrDisModel ==
                      null)
                    Expanded(
                      child: BlocConsumer<EditBonusDisciplineBloc,
                              EditBonusDisciplineState>(
                          listenWhen: (p, c) => p.users != c.users,
                          listener: (context, state) {
                            context.editBonusDisciplineBloc
                                .add(ChangeUserList(users: state.users ?? []));
                            searchController.notifyListeners();
                          },
                          buildWhen: (p, c) => p.users != c.users,
                          builder: (context, state) {
                            return SearchUserTagField(
                              textController: searchController,
                              tagController: tagController,
                              users: state.users ?? [],
                              searchUserWork: (p0) {
                                context.editBonusDisciplineBloc
                                    .add(SearchUserEvent(text: p0));
                              },
                              onTagDelete: () {
                                context.editBonusDisciplineBloc.add(
                                    SelectUserEvent(
                                        user: const UserWorkModel()));
                                context.editBonusDisciplineBloc
                                    .add(ChangeUserList(users: []));
                              },
                              selectedUser: (p0) {
                                context.editBonusDisciplineBloc
                                    .add(SelectUserEvent(user: p0));
                              },
                            );
                          }),
                    ),
                ],
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: defaultPadding(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<EditBonusDisciplineBloc,
                            EditBonusDisciplineState>(
                        buildWhen: (p, c) => p.selectedUser != c.selectedUser,
                        builder: (context, state) => state.rewardOrDisModel !=
                                    null ||
                                state.selectedUser != null &&
                                    state.selectedUser?.id != null
                            ? Row(
                                children: [
                                  Text(
                                    'Áp dụng đối với: ',
                                    style: FONT_CONST.regular(
                                        fontSize: 16,
                                        color: COLOR_CONST.cloudBurst),
                                  ),
                                  const HorizontalSpacing(of: 10),
                                  SizedBox(
                                    height: getProportionateScreenHeight(40),
                                    width: getProportionateScreenHeight(40),
                                    child: CachedNetworkImage(
                                      imageUrl: (state.selectedUser == null ||
                                              state.selectedUser?.id == null)
                                          ? state.rewardOrDisModel!.user
                                                  .avatarThumb ??
                                              ''
                                          : state.selectedUser?.user
                                                  ?.avatarThumb ??
                                              '',
                                      placeholder: (context, url) =>
                                          CircleAvatar(
                                        backgroundImage: AssetImage(
                                          IMAGE_CONST.imgDefaultAvatar.path,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          CircleAvatar(
                                        backgroundImage: AssetImage(
                                          IMAGE_CONST.imgDefaultAvatar.path,
                                        ),
                                      ),
                                      imageBuilder: (context, imageProvider) =>
                                          CircleAvatar(
                                        backgroundImage: imageProvider,
                                      ),
                                    ),
                                  ),
                                  const HorizontalSpacing(of: 5),
                                  Expanded(
                                    child: Text(
                                      (state.selectedUser == null ||
                                              state.selectedUser?.id == null)
                                          ? state
                                              .rewardOrDisModel!.user.fullname
                                          : state.selectedUser?.user
                                                  ?.fullname ??
                                              '',
                                      style: FONT_CONST.medium(),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )
                                ],
                              )
                            : Text(
                                'Bạn chưa chọn đối tượng',
                                style: FONT_CONST.medium(
                                    color: COLOR_CONST.portlandOrange),
                              )),
                    const VerticalSpacing(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Áp dụng cho tháng: ',
                          style: FONT_CONST.regular(
                              fontSize: 16, color: COLOR_CONST.cloudBurst),
                        ),
                        const HorizontalSpacing(),
                        Expanded(
                          child: BlocBuilder<EditBonusDisciplineBloc,
                              EditBonusDisciplineState>(
                            buildWhen: (p, c) => p.month != c.month,
                            builder: (context, state) =>
                                CustomDropdownDatePicker(
                              items: null,
                              textTime: Utils.formatDateTimeToString(
                                  time: state.month ?? DateTime.now(),
                                  dateFormat:
                                      DateFormat(DateTimePattern.monthYear)),
                              isFullwidthDropBox: true,
                              view: DateRangePickerView.year,
                              isExpanded: true,
                              monthFormat: DateTimePattern.monthYear,
                              calendarController: calendarController,
                              dateInit:
                                  context.editBonusDisciplineBloc.state.month ??
                                      DateTime.now(),
                              onSelectionChanged: (value) async {
                                FocusScope.of(context).unfocus();
                                context.editBonusDisciplineBloc
                                    .add(ChangeMonthEvent(month: value));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpacing(),
                    TitleField(
                      title: 'Tiêu đề'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'Thưởng dự án...'.tr(),
                      enabled: Singleton.instance.userType!.type <
                              UserType.STAFF.type
                          ? true
                          : false,
                      controller: titleController,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'title_not_blank'.tr();
                        }
                        return null;
                      },
                    ),
                    TitleField(
                      title: 'Mô tả'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'Khen thưởng/phạt vì...'.tr(),
                      enabled: Singleton.instance.userType!.type <
                              UserType.STAFF.type
                          ? true
                          : false,
                      controller: desControler,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'description_not_blank'.tr();
                        }
                        return null;
                      },
                    ),
                    TitleField(
                      title: 'Số tiền'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      hintText: '',
                      enabled: Singleton.instance.userType!.type <
                              UserType.STAFF.type
                          ? true
                          : false,
                      controller: amountController,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'amount_not_blank'.tr();
                        }
                        if (double.parse(value) == 0) {
                          return 'Số tiền phải lớn hơn 0';
                        }
                        if (double.parse(value) > 1000000000) {
                          return 'Số tiền quá lớn';
                        }
                        return null;
                      },
                      // onEditingComplete: () {
                      //   var value = amountController.text.trim();
                      //   if (value.isNotEmpty) {
                      //     print('qqqqqqqqqqqqqqq');
                      //     var t = double.parse(value);
                      //     print(t);
                      //     // value = value.replaceAll('.', '');
                      //     amountController.text =
                      //         NumberFormat.decimalPattern('vi').format(t);
                      //   }
                      // },
                    ),
                    const VerticalSpacing(of: 30),
                    Singleton.instance.userType!.type <= UserType.LEADER.type
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (context.editBonusDisciplineBloc.state
                                      .rewardOrDisModel !=
                                  null)
                                Container(
                                  margin: EdgeInsets.only(
                                      right: getProportionateScreenWidth(20)),
                                  child: PrimaryBorderButton(
                                    title: 'delete'.tr(),
                                    width: 150,
                                    height: SizeConfig.buttonHeightDefault,
                                    onPressed: () {
                                      PopupNotificationCustom.showMessgae(
                                        title: 'msg_confirm_delete'.tr(),
                                        message:
                                            'msg_confirm_delete_reward'.tr(),
                                        hiddenButtonRight: false,
                                        pressButtonRight: () {
                                          context.editBonusDisciplineBloc.add(
                                              DeleteBonusEvent(
                                                  id: context
                                                      .editBonusDisciplineBloc
                                                      .state
                                                      .rewardOrDisModel!
                                                      .id!));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              PrimaryButton(
                                width: 150,
                                title: context.editBonusDisciplineBloc.state
                                            .rewardOrDisModel ==
                                        null
                                    ? 'add'.tr().toUpperCase()
                                    : 'update'.tr().toUpperCase(),
                                boxDecoration: const BoxDecoration(
                                  color: COLOR_CONST.cloudBurst,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                height: SizeConfig.buttonHeightDefault,
                                textStyle: FONT_CONST.semoBold(
                                  color: COLOR_CONST.white,
                                  fontSize: 16,
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    final state =
                                        context.editBonusDisciplineBloc.state;
                                    if (state.selectedUser == null ||
                                        state.selectedUser?.id == null) {
                                      if (state.rewardOrDisModel == null) {
                                        ToastShowAble.show(
                                            toastType: ToastMessageType.ERROR,
                                            message:
                                                'Bạn chưa chọn đối tượng khen thưởng hoặc kỷ luật');
                                        return;
                                      }
                                    }

                                    var model = RewardOrDisciplineModel(
                                      user: (state.selectedUser == null ||
                                              state.selectedUser?.id == null)
                                          ? state.rewardOrDisModel!.user
                                          : state.selectedUser!.user!,
                                      title: titleController.text.trim(),
                                      content: desControler.text.trim(),
                                      month: state.month ?? DateTime.now(),
                                      amount: double.parse(
                                          amountController.text.trim()),
                                      isReward: state.isReward,
                                    );
                                    if (state.rewardOrDisModel == null) {
                                      if (state.isReward) {
                                        context.editBonusDisciplineBloc
                                            .add(AddBonusEvent(model: model));
                                      } else {
                                        context.editBonusDisciplineBloc
                                            .add(AddBonusEvent(model: model));
                                      }
                                    } else {
                                      if (state.selectedUser?.id != null &&
                                          state.selectedUser?.user?.id !=
                                              state.rewardOrDisModel!.user.id) {
                                        PopupNotificationCustom.showMessgae(
                                          title: "title_error".tr(),
                                          message:
                                              "Bạn có chắc chắn muốn thay đổi đối tượng áp dụng?",
                                          hiddenButtonLeft: false,
                                          pressButtonRight: () {
                                            context.editBonusDisciplineBloc.add(
                                                UpdateBonusEvent(model: model));
                                          },
                                          pressButtonLeft: () {
                                            model = model.copyWith(
                                                user: state
                                                    .rewardOrDisModel!.user);
                                            context.editBonusDisciplineBloc.add(
                                                UpdateBonusEvent(model: model));
                                          },
                                        );
                                      } else {
                                        context.editBonusDisciplineBloc.add(
                                            UpdateBonusEvent(model: model));
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectMonthWidget extends StatelessWidget {
  const SelectMonthWidget(
      {super.key,
      required this.title,
      required this.onTap,
      required this.date,
      this.width});
  final String title;
  final Function() onTap;
  final DateTime date;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style:
              FONT_CONST.regular(fontSize: 16, color: COLOR_CONST.cloudBurst),
        ),
        const HorizontalSpacing(),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50,
              width: width ?? 180,
              margin: const EdgeInsets.only(top: 0),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: COLOR_CONST.cloudBurst),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      Utils.formatDateTimeToString(
                          time: date,
                          dateFormat: DateFormat(DateTimePattern.monthYear)),
                      style: FONT_CONST.regular(
                        color: COLOR_CONST.cloudBurst,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Icon(
                    Icons.calendar_month,
                    size: 20,
                    color: COLOR_CONST.cloudBurst,
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
