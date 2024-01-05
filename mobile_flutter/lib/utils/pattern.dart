// TODO: Regex pattern to validate
mixin RegexPattern {
  static final RegExp emailRegExp = RegExp(
    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
  );

  static final RegExp phoneRegExp = RegExp(
    r'(^(?:[+0]9)?[0-9]{9,11}$)',
  );

  static final RegExp zipCodeRegExp = RegExp(
    r'(^(?:[+0]9)?[0-9]{5}$)',
  );
  static final RegExp dateRegExp = RegExp(
      r'(^(3[01]|[12][0-9]|0[1-9]|[1-9])?[/](1[0-2]|0[1-9]|[1-9])?[/]([0-9]{4})');
  static final RegExp amountRegExp = RegExp(
    r'[0-9,]',
  );
}

class DateTimePattern {
  static const dateFormatDefault = 'dd-MM-yyyy HH:mm:ss';
  static const dateFormatDefault1 = 'HH:mm:ss dd/MM/yyyy';
  static const dateFormatPromotion = 'dd-MM-yyyy HH:mm';
  static const dateFormatPromotion1 = 'yyyy/MM/dd HH:mm';
  static const dateFormatPromotion2 = 'yyyy-MM-ddTHH:mm:ss';
  static const dateFormatPromotion3 = 'yyyy-MM-dd HH:mm:ss';
  static const dayType0 = 'dd-MM-yyyy';
  static const dayType1 = 'dd/MM/yyyy';
  static const dayType2 = 'yyyy-MM-dd';
  static const dateFormatWithDay = 'EE, dd/MM/yyyy';
  static const dateFormatWithDay1 = 'EE, dd/MM';
  static const dateFormatWithDay2 = 'EE, dd MMM yyyy';
  static const dateFormatWithDay3 = 'EEEE, dd/MM/yyyy';
  static const timeType = 'HH:mm';
  static const month = 'MMMM';
  static const monthYear = 'MMMM, yyyy';
  static const day = 'EEEE';
}

class NumberFormatPattern {
  static const vnCurrency = '#,###.###';
}
