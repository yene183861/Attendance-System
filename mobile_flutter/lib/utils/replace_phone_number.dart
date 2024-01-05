class ReplacePhoneNumber {
  static String removeFirstBy0Number(String numberPhone){
    if(numberPhone.length > 0){
      if(numberPhone[0].contains("0")){
        numberPhone = numberPhone.substring(1, numberPhone.length);
      }
    }
    return numberPhone;
  }
}