import 'package:encrypt/encrypt.dart';
import 'package:password_manager/utils/secrets/secret.dart';
import 'package:password_manager/utils/secrets/secret_loader.dart';

class EncryptorService {

  late Encrypter encryptor;

  EncryptorService();

  Future<Encrypter> createEncryptor() async {
    Secret secret = await SecretLoader(secretPath: "secrets.json").load();
    final key = Key.fromUtf8(secret.secureKey);

    this.encryptor = Encrypter(AES(key));
    return this.encryptor;
  }

  String encryptString(String str) {
    IV iv = IV.fromLength(16);
    return encryptor.encrypt(str, iv: iv).base64;
  }

  String decryptString(String str) {
    IV iv = IV.fromLength(16);
    return encryptor.decrypt(Encrypted.fromBase64(str), iv: iv);
  }
}