#include "loginmanager.h"
#include "cryptopp/sha.h"
#include "cryptopp/hex.h"
#include "cryptopp/osrng.h"
#include <string>
#include <QDebug>
#include <QJsonObject>
#include <QJsonArray>
#include <QJsonDocument>
//#include <QByteArray>

#define SALT_SIZE 32

LoginManager::LoginManager()
{

}

bool LoginManager::registerUser(QString username, QString password)
{
    using namespace CryptoPP;

    byte saltArray[SALT_SIZE];
    AutoSeededRandomPool pool;
    for (unsigned int i = 0; i < sizeof(saltArray); i++)
    {
        saltArray[i] = pool.GenerateByte();
    }
    HexEncoder saltEncoder;
    std::string salt;
    saltEncoder.Attach(new StringSink(salt));
    saltEncoder.Put(saltArray, sizeof(saltArray));
    saltEncoder.MessageEnd();
    auto pw = password.toLocal8Bit() + salt.c_str();

    byte digest[SHA256::DIGESTSIZE];
    SHA256().CalculateDigest(digest,
          reinterpret_cast<byte*>(pw.data()), static_cast<size_t>(pw.size()));
    std::string output;
    HexEncoder encoder;
    encoder.Attach(new StringSink(output));
    encoder.Put(digest, sizeof(digest));
    encoder.MessageEnd();

    QJsonObject data;
    data["user"] = username;
    data["salt"] = salt.c_str();
    data["hash"] = output.c_str();

    QJsonObject json;
    json["request"] = "signup";
    json["data"] = data;
    network.send(QJsonDocument(json).toJson());
//    qDebug() << salt.c_str() << '\n' << output.c_str();
    return true;
}
