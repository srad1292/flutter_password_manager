import 'package:encrypt/encrypt.dart';
import 'package:password_manager/utils/secrets/secret.dart';
import 'package:password_manager/utils/secrets/secret_loader.dart';

class EncryptorService {


  EncryptorService();

  Future<Encrypter> getEncryptor() async {
    Secret secret = await SecretLoader(secretPath: "secrets.json").load();
    print("====GOT SECRET====");
    print(secret.secureKey);
    final key = Key.fromUtf8(secret.secureKey);

    return Encrypter(AES(key));
  }
}