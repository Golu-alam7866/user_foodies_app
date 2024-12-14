import 'dart:async';

void main(){
  palindromeNumber();
  palindromeBaBadToBaB();
  findCommonValue();
  findPrimeValue();
  findPrimeValue1To100();
  combineTwoList();
  findMaxValue();
  average();
  every10Second();
  after10Second();

}

void palindromeNumber(){
  int number = 121;
  int originalNumber = number;
  int reversedNumber = 0;
  while(number > 0){
    int remainder = number % 10;
    reversedNumber = (reversedNumber * 10) + remainder;
    number ~/= 10;
  }
  if(originalNumber == reversedNumber){
    print("$originalNumber is Palindrome Number");
  }else{
    print("$originalNumber is Not Palindrome Number");
  }
}

void palindromeBaBadToBaB(){
  String babad = "babad";
  String longestPalindrome = "";
  for(int i = 0; i < babad.length; i++){
    int left = i;
    int right = i;
    while(left >= 0 && right < babad.length && babad[left] == babad[right]){
      String currentPalindrome = babad.substring(left,right + 1);
      if(currentPalindrome.length > longestPalindrome.length){
        longestPalindrome = currentPalindrome;
      }
      left--;
      right++;
    }

    left = i;
    right = i + 1;
    while(left >= 0 && right < babad.length && babad[left] == babad[right]){
      String currentPalindrome = babad.substring(left,right + 1);
      if(currentPalindrome.length > longestPalindrome.length){
        longestPalindrome = currentPalindrome;
      }
      left--;
      right++;
    }
  }
  print("$longestPalindrome is Palindrome Value");
}

void findCommonValue(){
  List<String> values = ["flower","flow","flight"];
  String commonValue = "";
  String value = values[0];
  for(int i = 1; i < values.length; i++){
    while(values[i].indexOf(value) != 0){
      value = value.substring(0,value.length -1);
    }
  }
  commonValue = value;
  print("$commonValue This is Common value");
}

void findPrimeValue(){
  int num = 7;
  int countPime = 0;
  for(int i = 0; i <= 7; i++){
    if(i % num == 0){
      countPime++;
    }
  }
  if(countPime >= 2){
    print("$num is pime numbe");
  }else{
    print("$num is not pime");
  }

}

void findPrimeValue1To100(){
  for(int i = 1; i <= 100; i++){
    int countPrime = 0;
    for(int j = 1; j <= i; j++){
      if(i % j == 0){
        countPrime++;
      }
    }
    if(countPrime <= 2){
      print("$i is prime number");
    }else{
      print("$i is not prime number");
    }
  }
}

void combineTwoList(){
  List<int> firstList = [1,3,5,7,9];
  List<int> secondList = [2,4,6,8,10];

  List<int> combineBothList = [...firstList,...secondList];
   combineBothList.sort();

  print(combineBothList);
}

void findMaxValue(){
  List<int> values = [1,2,3,4,5,6,7,8,9,19];
  int maxvalue = values[0];
  int minvalue = values[0];

  for(int i = 0; i < values.length; i++){
    if(values[i] > maxvalue){
      maxvalue = values[i];
    }else{
      minvalue = values[i];
    }
  }
  print(maxvalue);
  print(minvalue);
}

void average(){
  List<int> values = [1,2,3,4,5,6,7,8,9,10,10,1000];
  int sum = 0;
  for(int i = 0; i < values.length; i++){
    sum += values[i];
  }
  var result = sum ~/ values.length;
  print(result);
}

void after10Second()async{
  await Future.delayed(Duration(seconds: 10));
  print(10);
}

void every10Second(){
  Timer.periodic(Duration(seconds: 10), (timer) {
    print(20);
  },);
}