import 'package:easy_localization/easy_localization.dart';
import 'package:firefly/custom_widget/custom_dropdown_button.dart';
import 'package:firefly/custom_widget/user_work_infomation.dart';
import 'package:firefly/data/enum_type/contract_status.dart';
import 'package:firefly/data/enum_type/contract_type.dart';
import 'package:firefly/data/enum_type/ticket_status.dart';
import 'package:firefly/data/model/contract_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'package:firefly/configs/resources/barrel_const.dart';
import 'package:firefly/custom_widget/appbar_default_custom.dart';
import 'package:firefly/custom_widget/custom_text_form_field.dart';
import 'package:firefly/custom_widget/default_padding.dart';
import 'package:firefly/custom_widget/loading_show_able.dart';
import 'package:firefly/custom_widget/popup_notification_custom.dart';
import 'package:firefly/custom_widget/primary_button.dart';
import 'package:firefly/custom_widget/title_field.dart';
import 'package:firefly/custom_widget/toast_show_able/barrel_toast.dart';

import 'package:firefly/data/enum_type/user_type.dart';

import 'package:firefly/utils/pattern.dart';
import 'package:firefly/utils/singleton.dart';
import 'package:firefly/utils/size_config.dart';
import 'package:firefly/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../../custom_widget/search_user_field.dart';
import '../../../data/arguments/edit_contract_argument.dart';
import 'bloc/edit_contract_bloc.dart';
import 'components/bottom_sheet_select_date.dart';
import 'components/textfield_select_date.dart';

class EditContractScreen extends StatelessWidget {
  const EditContractScreen({super.key, this.arg});
  final EditContractArgument? arg;

  @override
  Widget build(BuildContext context) {
    print('\n');
    print(arg?.selectedUser);
    return Scaffold(
      backgroundColor: COLOR_CONST.backgroundColor,
      body: BlocProvider(
          create: (context) => EditContractBloc(arg: arg),
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
      basicSalaryController,
      nameController,
      contractCodeController,
      salaryCoefficientController;

  final _formKey = GlobalKey<FormState>();
  late DateRangePickerController startDateController, endDateController;

  final textSearchChange = BehaviorSubject<String>();

  @override
  void initState() {
    super.initState();
    final state = context.editContractBloc.state;
    startDateController = DateRangePickerController();
    endDateController = DateRangePickerController();
    searchController = TextEditingController();
    searchController.addListener(() {
      textSearchChange.value = searchController.text;
    });
    textSearchChange
        .debounceTime(const Duration(milliseconds: 100))
        .distinct()
        .listen((searchText) {
      final textSearch = searchText.trim();

      context.editContractBloc.add(SearchUserEvent(text: textSearch));
    });

    basicSalaryController = TextEditingController(
        text: state.contractModel?.basicSalary.toString());
    nameController = TextEditingController(text: state.contractModel?.name);
    contractCodeController =
        TextEditingController(text: state.contractModel?.contractCode);
    salaryCoefficientController = TextEditingController(
        text: state.contractModel?.salaryCoefficient.toString());
  }

  @override
  void dispose() {
    super.dispose();
    searchController.removeListener(() {});
    searchController.dispose();
    basicSalaryController.dispose();
    nameController.dispose();
    contractCodeController.dispose();
    salaryCoefficientController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditContractBloc, EditContractState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        if (state.status.isSubmissionInProgress) {
          LoadingShowAble.showLoading();
        } else if (state.status.isSubmissionSuccess) {
          LoadingShowAble.forceHide();
          if (state.message != null && state.message!.isNotEmpty) {
            ToastShowAble.show(
                toastType: ToastMessageType.SUCCESS,
                message: state.message ?? '');
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
              title: context.editContractBloc.state.contractModel == null
                  ? 'Thêm mới hợp đồng'
                  : 'Cập nhật thông tin hợp đồng',
              isCallBack: true,
            ),
            Padding(
              padding: defaultPadding(horizontal: 20, vertical: 5),
              child: BlocBuilder<EditContractBloc, EditContractState>(
                  buildWhen: (p, c) =>
                      p.users != c.users || p.selectedUser != c.selectedUser,
                  builder: (context, state) {
                    return SearchUserField(
                      onSelectedUser: (userWorkModel) {
                        context.editContractBloc
                            .add(SelectUserEvent(user: userWorkModel));
                      },
                      textController: searchController,
                      users: state.users ?? [],
                      userWorkModel: state.selectedUser,
                      textSearchChange: (value) {
                        searchController.notifyListeners();
                      },
                    );
                  }),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: defaultPadding(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<EditContractBloc, EditContractState>(
                        buildWhen: (p, c) => p.selectedUser != c.selectedUser,
                        builder: (context, state) => state.selectedUser !=
                                    null &&
                                state.selectedUser?.id != null
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hợp đồng này sẽ được ký kết nhân viên: ',
                                    style: FONT_CONST.regular(
                                        fontSize: 16,
                                        color: COLOR_CONST.cloudBurst),
                                  ),
                                  const VerticalSpacing(of: 10),
                                  UserInfomationWork(
                                      userWorkModel: state.selectedUser!),
                                ],
                              )
                            : Text(
                                'Bạn chưa chọn nhân viên',
                                style: FONT_CONST.medium(
                                    color: COLOR_CONST.portlandOrange),
                              )),
                    const VerticalSpacing(),
                    TitleField(
                      title: 'Tên hợp đồng'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'Hợp đồng lao động'.tr(),
                      enabled: Singleton.instance.userType!.type <
                              UserType.STAFF.type
                          ? true
                          : false,
                      controller: nameController,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'name_not_bank'.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpacing(of: 6),
                    TitleField(
                      title: 'Mã hợp đồng'.tr(),
                      isRequired: true,
                    ),
                    const VerticalSpacing(of: 6),
                    CustomTextFormField(
                      maxLength: 255,
                      hintText: 'HD 001'.tr(),
                      enabled: Singleton.instance.userType!.type <
                              UserType.STAFF.type
                          ? true
                          : false,
                      controller: contractCodeController,
                      validator: (p0) {
                        final value = p0?.trim();
                        if (value == null || value.isEmpty) {
                          return 'contract_code_not_blank'.tr();
                        }
                        return null;
                      },
                    ),
                    const VerticalSpacing(of: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(50),
                          child: TitleField(
                            title: 'Lương cơ bản'.tr(),
                            isRequired: true,
                          ),
                        ),
                        const HorizontalSpacing(of: 10),
                        Expanded(
                          child: CustomTextFormField(
                            hintText: '',
                            counter: const Text(''),
                            maxLength: 15,
                            enabled: Singleton.instance.userType!.type <
                                    UserType.STAFF.type
                                ? true
                                : false,
                            controller: basicSalaryController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegexPattern.amountRegExp)
                            ],
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
                          ),
                        ),
                      ],
                    ),
                    const VerticalSpacing(of: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: getProportionateScreenHeight(50),
                          child: TitleField(
                            title: 'Hệ số tính lương'.tr(),
                            isRequired: true,
                          ),
                        ),
                        const HorizontalSpacing(of: 10),
                        Expanded(
                          child: CustomTextFormField(
                            hintText: '',
                            counter: const Text(''),
                            maxLength: 2,
                            enabled: Singleton.instance.userType!.type <
                                    UserType.STAFF.type
                                ? true
                                : false,
                            controller: salaryCoefficientController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegexPattern.amountRegExp)
                            ],
                            keyboardType: TextInputType.number,
                            validator: (p0) {
                              final value = p0?.trim();
                              if (value == null || value.isEmpty) {
                                return 'hệ số tính lương ko được để trống'.tr();
                              }
                              if (double.parse(value) < 0.85) {
                                return 'Hệ số phải lớn hơn phải lớn hơn 85% nếu là hợp đồng lao động thời vụ';
                              }
                              if (double.parse(value) >= 10) {
                                return 'Hệ số quá lớn';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<EditContractBloc, EditContractState>(
                      buildWhen: (p, c) => p.contractType != c.contractType,
                      builder: (context, state) => CustomDropdownButton(
                        marginTop: 0,
                        colorBorderFocused: COLOR_CONST.cloudBurst,
                        title: 'Kiểu hợp đồng'.tr(),
                        isRequired: true,
                        datas: (Singleton.instance.userType!.type <=
                                    UserType.CEO.type
                                ? ContractType.values
                                : [
                                    context.editContractBloc.state
                                                .contractModel !=
                                            null
                                        ? context.editContractBloc.state
                                            .contractModel!.contractType
                                        : ContractType.SEASONAL_CONTRACT
                                  ])
                            .map((e) => DropdownMenuItem<ContractType>(
                                  value: e,
                                  child: Text(
                                    e.value,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: FONT_CONST.regular(),
                                  ),
                                ))
                            .toList(),
                        selectedDefault:
                            context.editContractBloc.state.contractModel != null
                                ? context.editContractBloc.state.contractModel!
                                    .contractType
                                : ContractType.SEASONAL_CONTRACT,
                        onSelectionChanged: (p0) {
                          if (Singleton.instance.userType!.type <=
                              UserType.CEO.type) {
                            if (p0 is ContractType) {
                              context.editContractBloc.add(
                                  ChangeContractTypeEvent(contractType: p0));
                            }
                          }
                        },
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<EditContractBloc, EditContractState>(
                            buildWhen: (p, c) => p.startDate != c.startDate,
                            builder: (context, state) => SelectDateWidget(
                              title: 'Ngày bắt đầu',
                              isRequired: true,
                              date: Utils.formatDateTimeToString(
                                  time: state.startDate,
                                  dateFormat:
                                      DateFormat(DateTimePattern.dayType1)),
                              onTap: () {
                                showModalBottomSheet(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            topRight: Radius.circular(12))),
                                    backgroundColor: Colors.white,
                                    context: context,
                                    builder: (_) {
                                      return BlocProvider.value(
                                        value: context.editContractBloc,
                                        child: BottomSheetSelectDate(
                                            description: 'msg_start_date'.tr(),
                                            dateController: startDateController,
                                            startDate: true),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: BlocBuilder<EditContractBloc,
                                  EditContractState>(
                              buildWhen: (p, c) =>
                                  p.endDate != c.endDate ||
                                  p.contractType != c.contractType,
                              builder: (context, state) => context
                                          .editContractBloc
                                          .state
                                          .contractType !=
                                      ContractType
                                          .INDEFINITE_TERM_LABOR_CONTRACT
                                  ? Row(
                                      children: [
                                        const HorizontalSpacing(),
                                        Expanded(
                                          child: SelectDateWidget(
                                            title: 'Ngày kết thúc',
                                            isRequired: true,
                                            onTap: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  shape: const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(12),
                                                              topRight: Radius
                                                                  .circular(
                                                                      12))),
                                                  backgroundColor: Colors.white,
                                                  context: context,
                                                  builder: (_) {
                                                    return BlocProvider.value(
                                                      value: context
                                                          .editContractBloc,
                                                      child: BottomSheetSelectDate(
                                                          description:
                                                              'msg_end_date contract'
                                                                  .tr(),
                                                          dateController:
                                                              endDateController,
                                                          startDate: false),
                                                    );
                                                  });
                                            },
                                            date: Utils.formatDateTimeToString(
                                                time: state.endDate ??
                                                    DateTime.now(),
                                                dateFormat: DateFormat(
                                                    DateTimePattern.dayType1)),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()),
                        ),
                      ],
                    ),
                    const VerticalSpacing(of: 30),
                    Singleton.instance.userType!.type <= UserType.LEADER.type
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (context
                                      .editContractBloc.state.contractModel !=
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
                                          // context.editContractBloc.add(
                                          //     Delet(
                                          //         id: context
                                          //             .editBonusDisciplineBloc
                                          //             .state
                                          //             .rewardOrDisModel!
                                          //             .id!));
                                        },
                                      );
                                    },
                                  ),
                                ),
                              PrimaryButton(
                                width: 150,
                                title: context.editContractBloc.state
                                            .contractModel ==
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
                                        context.editContractBloc.state;
                                    if (state.selectedUser == null ||
                                        state.selectedUser?.id == null) {
                                      ToastShowAble.show(
                                          toastType: ToastMessageType.ERROR,
                                          message:
                                              'Bạn chưa chọn đối tượng ký kết hợp đồng');
                                      return;
                                    }
                                    final userType =
                                        Singleton.instance.userType;

                                    var model = ContractModel(
                                      user: state.selectedUser!.user!,
                                      organizationId:
                                          state.selectedUser!.organization!.id,
                                      name: nameController.text.trim(),
                                      basicSalary: double.parse(
                                          basicSalaryController.text.trim()),
                                      contractCode:
                                          contractCodeController.text.trim(),
                                      contractType: state.contractType,
                                      salaryCoefficient: double.parse(
                                          salaryCoefficientController.text
                                              .trim()),
                                      state: userType!.type <= UserType.CEO.type
                                          ? ContractStatus.VALID_CONTRACT
                                          : ContractStatus.INVALID_CONTRACT,
                                      status: userType.type <= UserType.CEO.type
                                          ? TicketStatus.APPROVED
                                          : TicketStatus.PENDING,
                                      startDate: state.startDate,
                                      endDate: state.contractType ==
                                              ContractType
                                                  .INDEFINITE_TERM_LABOR_CONTRACT
                                          ? null
                                          : state.endDate,
                                      signDate: state.signDate,
                                    );
                                    if (state.contractModel == null) {
                                      context.editContractBloc
                                          .add(AddContractEvent(model: model));
                                    } else {
                                      context.editContractBloc.add(
                                          UpdateContractEvent(model: model));
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
    // );
    //   ),
    // );
  }
}
