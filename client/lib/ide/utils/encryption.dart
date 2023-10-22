import 'package:encrypt/encrypt.dart' as crypto;
import 'package:fire_dev/ide/constants/env.dart';

class Encryption {
  static final _iv = crypto.IV.fromBase64(ENCRYPTION_IV);
  static final _encrypter = crypto.Encrypter(
    crypto.AES(
      crypto.Key.fromBase64(
        ENCRYPTION_KEY,
      ),
    ),
  );

  static String decrypt(String encryptedText) {
    final encrypted = crypto.Encrypted.fromBase64(encryptedText);
    final plaintext = _encrypter.decrypt(encrypted, iv: _iv);
    return plaintext;
  }

  static String encrypt(String plaintext) {
    final encrypedText = _encrypter.encrypt(plaintext, iv: _iv).base64;
    return encrypedText;
  }
}
