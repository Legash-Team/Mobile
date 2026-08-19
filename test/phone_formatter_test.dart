import 'package:flutter_test/flutter_test.dart';
import 'package:egash_mobile/utils/phone_formatter.dart';

void main() {
  test('PhoneFormatter converts 0XXXXXXXXX to +251XXXXXXXXX', () {
    expect(PhoneFormatter.format('0962395284'), '+251962395284');
  });

  test('PhoneFormatter handles bare 9-digit number', () {
    expect(PhoneFormatter.format('962395284'), '+251962395284');
  });

  test('PhoneFormatter preserves already formatted number', () {
    expect(PhoneFormatter.format('+251962395284'), '+251962395284');
  });

  test('PhoneFormatter handles number with spaces', () {
    expect(PhoneFormatter.format('096 239 5284'), '+251962395284');
  });

  test('PhoneFormatter does not double prefix', () {
    expect(PhoneFormatter.format('+251962395284'), '+251962395284');
    expect(PhoneFormatter.format('+251962395284'), isNot('+251+251962395284'));
  });

  test('PhoneFormatter strips leading zero from 10-digit', () {
    final result = PhoneFormatter.format('0962395284');
    expect(result.startsWith('+251'), isTrue);
    expect(result, '+251962395284');
    expect(result.contains('+2510'), isFalse);
  });
}
