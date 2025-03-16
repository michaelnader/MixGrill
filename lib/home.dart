import 'package:flutter/material.dart';
import 'package:game/teamsregisteration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "اهلا بيكم فى ميكس جريل اللعبة سهلة بس محتاجة تركيز! أول خطوة نقسم نفسنا فرق تكون نفس العدد تقريبا",
      "image": "assets/team.jpg"
    },
    {
      "text": " بعدين كل واحد بالترتيب هيدخل 4 حاجات : اسم شخصية عامة , فيلم , اغنية , مكان فى مصر بعدين بيطلع حد يشرحه للفريق بطريقة معينة هنشوفها دلوقتى",
      "image": "assets/tsgel.jpg"
    },
    {
      "text": " هنلعب 3 جولات لكل فريق اول واحدة ببساطة حد بيطلع بيمثل الحاجة اللى هتطلعله للفريق فى 60 ثانية و بيقول نوعها الاول قبل ما بيمثل يعنى لو طلعله اغنية 'انت الحظ' هيقول اغنية بعدين يبدأ يمثل",
      "image": "assets/tamsil.jpg"
    },
    {
      "text": " الجولة التانية شخص هيطلع يشرح الحاجة اللى طلعت فى كلمة واحدة بس بشرط ماتكونش موجودة فى الحاجة اللى طلعتلك و ممكن كل 15 ثانية يقول كلمة جديدة الفريق معاة 60 ثانية و برضو بيقول نوعها الاول",
      "image": "assets/password.jpg"
    },
    {
      "text": "اخر جولة و اللى بيطلع بيقول للفريق كلمة من الحاجة اللى طلعتله مثلا لو جاله اغنية 'انت الحظ' ممكن ييقول 'الحظ'  , مش بنقول النوع يعنى مش هيقول 'اغنية', طب لو الحاجة اصلا كلمة واحدة بيلعبها زى الجولة اللى فاتت ",
      "image": "assets/last.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/b4.jpg"), // Background image added
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  onPageChanged: (value) {
                    setState(() {
                      currentPage = value;
                    });
                  },
                  itemCount: splashData.length,
                  itemBuilder: (context, index) => SplashContent(
                    image: splashData[index]["image"],
                    text: splashData[index]['text'],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      const Spacer(),
                      _buildPageIndicators(),
                      const Spacer(flex: 2),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Teams(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          backgroundColor: Colors.lightBlueAccent,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: const Text("Start Game", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        splashData.length,
            (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(right: 8),
          height: 8,
          width: currentPage == index ? 24 : 8,
          decoration: BoxDecoration(
            color: currentPage == index ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  final String? text, image;

  const SplashContent({super.key, this.text, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Colors.lightBlueAccent], // White to Blue Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds),
          child: const Text(
            "Mix Grill",
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
              color: Colors.white, // Must be white for ShaderMask to work
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              text!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ClipRRect(
          borderRadius: BorderRadius.circular(30), // Softer rounded corners
          child: Image.asset(
            image!,
            fit: BoxFit.cover,
            height: 250,
            width: 350,
          ),
        ),
      ],
    );
  }
}
