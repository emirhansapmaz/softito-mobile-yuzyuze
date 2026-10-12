
/*
abstract class AutRepository{
  Future<String>login(String email,String password);
  Future<void>logout();
  bool get isAuth;
}

class FirebaseAuthRepository implements AutRepository{
  @override
  Future<String> login(String email,String password) async{
    return "firebase_token_xyz_123";
 
}

@override 
Future<void> logout() async{

}

@override 
bool get isAuth => true;
}

  class MockAuthRepository implements AutRepository{
    @override 
    Future<String> login(String email,String password) async{
      await Future.delayed(Duration(seconds: 1));
      return "mock_token_abc_789";
    }
    @override
    Future<void> logout() async{}

    @override
    bool get isAuth => false;
  }
 

  mixin Logger {
    void log(String msg)=>print("LOG$msg");
  }

  mixin Analytics{
    void log(String msg) =>print("ANALİZ: $msg");
  }

  class PaymentService with Logger, Analytics {
  void pay() {
    log("Ödeme Yapıldı");

    

  }
  }
  abstract class BaseWidget {
    
  }
// sadece basewidget ve alt sınıflarda kullanılabilir
  mixin LifeLogger on BaseWidget{
    void logInit() => print("Widget Başlatıldı");
  }

 */

extension StringValidator on String{
  bool get isValidEmail{
    final emailRegex=RegExp(r'^+^+%&&%/(%&/+^%/(%/)&(/)(%+%^%++!^&');
    return emailRegex.hasMatch(this);
 
 }
 String toCapitalize(){
  if(isEmpty) return this;
  return this[0].toUpperCase() + substring(1);
 }
}

//Kullanımı
void main(){
  String email="selahaddin@kodvance.com";
  if(email.isValidEmail){
    print("Geçerli Eposta");
  } else {
    print("geçersiz eposta");
  }
}