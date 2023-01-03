import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading=true;
  File? _image;
  late List _output;
  ImagePicker picker=ImagePicker();
  detectImage(File image) async{
    var output= await Tflite.runModelOnImage(
        path: image.path,
        numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5
    );
    setState(() {
      if(output!=null){
        _output=output;
      }
      _loading=false;
    });
  }
  loadModel() async{
    await Tflite.loadModel(model: 'assets/model_unquant.tflite',labels: 'assets/labels.txt');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value){
      setState(() {

      });
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  pickImageCam() async{
    XFile? image=await picker.pickImage(source: ImageSource.camera);
    if(image==null)
      return null;
    setState(() {
      _image=File(image.path);
    });

    detectImage(_image!);
  }

  pickImageGal() async{
    XFile? image=await picker.pickImage(source: ImageSource.gallery);
    if(image==null)
      return null;
    setState(() {
      _image=File(image.path);
    });

    detectImage(_image!);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffA3C7D6),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Cat and Dogs Detector App",
                style: TextStyle(
                  color: Color(0xff3F3B6C),
                    fontSize: 30,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 70,),
            Center(
              child: _loading ? Container(
                width: 350,
                child: Column(
                  children: [
                    Image.asset('assets/icon.png'),
                    SizedBox(height: 20,)
                  ],
                ),
              ) :Container(
                child: Column(
                  children: [
                    Container(
                      height: 250,

                      child: Image.file(File(_image!.path)),
                      // child: _image!=null?Image.file(_image!):Icon(Icons.image,size: 100,),
                      // child: Image(image: xFileToImage(_image!) as ImageProvider),
                    ),
                    SizedBox(height: 20,),
                    // _output!=null ? Text(
                    //   '${_output[0]['label']}',
                    //   style: TextStyle(
                    //     color: Color(0xff624F82),
                    //     fontSize: 20,
                    //     fontWeight: FontWeight.bold,
                    //   ),)
                    _output!=null ? AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                              '${_output[0]['label']}'.toUpperCase(),
                            // textStyle: TextStyle(
                            //   color: Color(0xff624F82),
                            //   fontSize: 20,
                            //   fontWeight: FontWeight.bold,
                            //   letterSpacing: 4,
                            // ),
                              textStyle: GoogleFonts.kaushanScript(
                                  textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                  color: Color(0xff624F82)),
                            speed: Duration(milliseconds: 900)
                          ),
                        ],)
                        :Container(),
                    SizedBox(height: 30,)
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      pickImageCam();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width-230,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                      decoration: BoxDecoration(
                        color: Color(0xff624F82),
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.camera,
                            color:Color(0xffA3C7D6),
                          ),
                        SizedBox(width: 5,),
                        Text(
                          "Capture a Photo",
                          style: TextStyle(
                              color: Color(0xffA3C7D6),
                            fontSize: 13,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ]
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  GestureDetector(
                    onTap: (){
                      pickImageGal();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width-250,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 15,vertical: 18),
                      decoration: BoxDecoration(
                          color: Color(0xff624F82),
                          borderRadius: BorderRadius.circular(6)
                      ),
                      child: Row(
                          children: [
                            Icon(
                                Icons.add_to_photos,
                              color:Color(0xffA3C7D6),
                            ),
                            SizedBox(width: 5,),
                            Text(
                              "Select a Photo",
                              style: TextStyle(
                                  color: Color(0xffA3C7D6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
