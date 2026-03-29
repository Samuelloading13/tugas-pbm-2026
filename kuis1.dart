import 'dart:io';

void main () {
  stdout.write("masukkan angka : ");

  int n = int.parse(stdin.readLineSync()!);

  bool isPrime = true;

  if (n <= 1) {
    isPrime = false;
  }
  else {
    for (int i = 2; i < n; i++){
      if (n % i == 0) {
        isPrime = false;
        break;
      }
    }
  }

  int factorial = 1;

  for (int i = 1; i <= n; i++) {
    factorial *= i;
  }

  print("\n === Hasil ===");
  print(isPrime ? "$n adalah bilangan prima" : "$n bukan bilangan prima");
  print("faktorial dari $n adalah $factorial");
}