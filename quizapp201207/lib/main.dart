import 'package:flutter/material.dart'; //GEREKLi KUTUPHANEYi DAHiL ETTiK.
QuizBrain quizBrain=new QuizBrain(); //QUIZ iÇiN KULLANDIĞIMIZ CLASSIN BiR KOPYASINI
double point=0;                      //ÇEKTiK
void main() {
  runApp(Quizs()); //UYGULAMIMIZI QUIZS WIDGETIMIZDAN BAŞLATTIK.
}
class Quizs extends StatelessWidget { //STATIK BIR SAYFA OLDUĞUNDAN "StatelessWidget" KULLANDIK.
  @override
  Widget build(BuildContext context) {
    return MaterialApp( //KLASIK ADIMLAR...
      home: Scaffold(
        backgroundColor: Colors.grey.shade900, //ARKA PLAN RENGINI BELIRTTIK.
        body: SafeArea( //SAYFADAKI APPBAR VE UST KISIMLAR ICIN SAFEAREA KULLANDIK
          child: Padding( //SAYFAYA PADDING VERDIK
            padding: EdgeInsets.symmetric(horizontal: 10.0), //SAYFADAN RESPONSEVE TASARIMI ICIN YAPILDI
            child: QuizPage(), //ÇOCUĞU QUIZPAGE
          ),
        ),
      ),
    );
  }
}
class QuizPage extends StatefulWidget { //FARKLI SORULAR OLACAĞINDAN "StateFulWidget" KULLANDIK
  @override
  _QuizPage createState() => _QuizPage();
}
class _QuizPage extends State<QuizPage>{
  List<Icon> scoreKeeper=[]; //SAYFANIN ALTINDA SORULARIN DOGRU OLUP OLMADIGINI ANLAMAK ICIN ICON LISTESI OLUSTURDUK
  Widget options(){ //SORULARIN SEÇENEKLERI ICIN BIRDEN FAZLA BUTTON OLDUGU WIDGET YAZDIK
    var ques=quizBrain.getQuestion(); //MEVCUT SORUYU ALDIK.
    List<Widget> s=new List<Widget>(); //LISTE OLUŞTURDUK.
    for(int i=0;i<ques.answer.length;i++){ //SEÇENEKLERIN IÇINDE GEZIYORUZ
      //BURDA ISE SEÇENEKLER ICIN BUTON OLUŞTURDUK
      s.add(Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: FlatButton(
                textColor: Colors.white10,
                color: Colors.green,
                //CEVABIN IÇERIĞINI ALDIK VE BUTONUN TEXTINE YAZDIRDIK.
                child: Text(ques.answer[i],style: TextStyle(color: Colors.white,fontSize:20.0),
                ),
                //BUTONA TIKLADIĞINDA CEVABI KONTROL ETTIRDIK
                onPressed: (){chechAnswer(ques.answer[i].toString());
                },
              ),
            ),
          ),
        ],
      ),
      );
    }
    return Column( //BUTONLARI GERI DÖNDÜRDÜK.
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: s,
    );
  }
  void chechAnswer(String userPickedAnswer){ //SORULARIN KONTROL IŞLEMINI YAPTIK.
    String correctAnswer=quizBrain.getQuestion().correctAnswer; //DOĞRU CEVABI ALDIK.
    setState(() {
      if(quizBrain.isFinished()==true){ //SORULAR Bittiyse
        quizBrain.reset(); //SORULARI BAŞA ALDIK.
        //SORULAR Bittiğinde "ResultPage" SAYFASINI AÇTIK.
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultPage()));
        scoreKeeper=[]; //ALTTA GÖSTERILEN ICONLAR SIFIRLANDI.
      }
      else if(userPickedAnswer==correctAnswer){ //CEVAP DOĞRUYSA
        point+=5; //PUAN 5 ARTTI.
        scoreKeeper.add(Icon( //Tik işareti gösterildi.
          Icons.check,
          color: Colors.green, //rengini yeşil yaptık.
        ));
      }
      else{ //CEVAP YANLIŞSA
        point-=2; //PUANINDAN 2 PUAN AZALTTIK.
        scoreKeeper.add(Icon( //YANLIŞ iconu GÖSTERDIK(ÇARPI)
          Icons.close,
          color:Colors.red, //rengini kırmızı yaptık.
        ));
      }
      quizBrain.nextQuestion(); //BIR SONRAKI SORUYA GEÇTIK.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, //SAYFANIN RESPONSEVEINI AYARLADIK.
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: Padding( //SAYFAYA PADDING VERDIK.
            padding: EdgeInsets.all(10),
            child: Center(
              child: Text(
                quizBrain.getQuestion().questionText, //SORUYU SAYFANIN ORTASINA YAZDIK.
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 25,color:Colors.white), //BEYAZ RENK VERDIK
              ),
            ),
          ),
        ),
        options(), //SEÇENEKLERI SORUNUN ALTINDA EKLEDIK.
        Row( //SAYFANIN ALT KISMINA DOĞRU YANLIŞ OLDUGUNU ANLAMAK ICIN IKONLARI EKLEDIK.
          children: scoreKeeper,
        ),
      ],
    );
  }

}

class Question{ //SORULAR ICIN CLASS OLUSTURDUK.
  String questionText; //SORUNUN ICERIGI
  List<String> answer; //SORUNUN SECENEKLERI
  String correctAnswer; //DOĞRU CEVAP
  Question(String q ,List<String> a,String c){
    questionText=q;
    answer=a;
    correctAnswer=c;
  }
}

class QuizBrain{ //SORULARI OLUŞTURDUK.
  int _questionNumber=0;
  List<Question> questionBank=[
    Question('Geliştirdiğiniz mobil uygulamanın gereksinimlere cevap verebilmesi için aşağıdaki ölçütlerden hangisine uygun olmasına gerek yoktur?', ["Karışık arayüzler","Performans","Güvenlik","Anlaşılabilirlik"],"Karışık arayüzler"),
    Question('Aşağıdakilerden hangisi mobil uygulama geliştirme platformlarından biri değildir?',  [" Yerel (Native)","Cross (Çapraz)","Melez (Hybrid)","Uyumlu (Responsive)","Değişken (Variable)"],"Değişken (Variable)"),
    Question('iOS için geliştirilen uygulamalarda kullanılan programlama dili aşağıdakilerden hangisidir?',  ["Java","HTML/CSS","C#","Objective C"],"Objective C"),
    Question('Aşağıdakilerden hangisi mobil işletim sistemlerden biri değildir?',  ["Android","Symbian","Windows 7"],"Windows 7"),
    Question('Mobil Uygulamalarda Projede kullanılan görsel dosyalar Mainfest klasöründe tutulur',  ["Doğru","Yanlış"],"Yanlış")];
  bool nextQuestion() { //EĞER SORULAR BITMEDIYSE BIR SONRAKI SORUYA GEÇTIK.
    if (_questionNumber < questionBank.length - 1) {
      _questionNumber++;
      return true;
    }
    else{ //DEĞILSE DEĞER FALSE DÖNDÜ.
      return false;
    }
  }
  void reset(){ //SORULAR BITTIGINDE BAŞA DÖNMEK ICIN.
    _questionNumber=0;
  }
  Question getQuestion(){ //MEVCUT SOURUYU GETIRDIK.
    return questionBank[_questionNumber];
  }
  bool isFinished(){ //SORULARIN BITIP BITMEDIĞINI KONTROL ETTIRDIK.
    if(_questionNumber>= questionBank.length-1){
      return true; //EĞER DOGRUYSA DEĞER TRUE DÖNDÜ.
    }
  }
}
class ResultPage extends StatelessWidget { // SORULAR BITTIGINDE SONUÇ SAYFAASI OLUŞTURDUK.
  String result(){ //SONUCUN HESAPLAMASINI YAPTIK.
    String res="";
    if(point>10 && point<=15){ //EĞER 10 ILE 15 ARASINDA ISE
      res="Çok iyi sonuç :)";
    }
    else if(point>15){ //15 TEN BÜYÜKSE
      res="Mükemmel sonuç !!! :)";
    }
    else if(point<=10){ //10 DAN KÜÇÜK VE EŞITSE
      res="Lütfen tekrar deneyin :(";
    }
    return res;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(child:Text(result().toString())), //HESAPLAMA SONUCU NASIL BIR SONUÇ ALDIĞINI YAZDIK.
            Center(child:Text("Puanın : "+point.toString())), //PUANINI YAZDIRDIK.
            //Yeniden Başlat butonuna bastığında quiz sayfasını açıyor.
            Center(child:  FlatButton(onPressed:(){ point=0;Navigator.push(context, MaterialPageRoute(builder: (context)=>Quizs()));
            },   textColor: Colors.white,
              color: Colors.green,
              child: Text("Yeniden Başlat",
              ),)),
          ],
        ),
      ),
    );
  }
}