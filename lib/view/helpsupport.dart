import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpSupport extends StatefulWidget{
  const HelpSupport({super.key});
  @override
  State<HelpSupport> createState() => _HelpSupportState();
}
class _HelpSupportState extends State<HelpSupport>{
  List names=[
    Icons.call,
    Icons.message,
    Icons.email
  ];
  List subtitle = [
    "Find answers to common questions",
    "Talk to our support team",
    "Tell us about an issue",
  ];
  List colorr=[
    Colors.green.shade50,
    Colors.blue.shade50,
    Colors.white
  ];
  List c=[
    "Call us",
    "Message",
    "Email us"
  ];
  List icons = [
    CupertinoIcons.question_circle,
    CupertinoIcons.headphones,
    CupertinoIcons.exclamationmark_triangle,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.deepPurple,
          ),
        ),
        title: Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(
                        CupertinoIcons.headphones,
                        size: 35,
                        color: Colors.deepPurple,
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "How can we help?",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "We're here to help you with any questions or issues.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25),
              Text(
                "Support Options",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.deepPurple.shade50,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.white,
                            child: Icon(
                              names[index],
                              color: Colors.deepPurple,
                              size: 25,
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  c[index],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  subtitle[index],
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          GestureDetector(onTap: ()async{
                            if(index==0){
                              final url= Uri(
                                  scheme: "tel",
                                  path: "8590061995"
                              );
                              if(await canLaunchUrl(url)){
                                launchUrl(url);
                              }
                            }
                            else if(index==1){
                              final url= Uri(
                                  scheme: "sms",
                                  path: "8590061995"
                              );
                              if(await canLaunchUrl(url)){
                                launchUrl(url);
                              }
                            }
                            else if(index==2)
                            {
                              final url = Uri(
                                  scheme: "mailto",
                                  path: "insta342311@gmail.com",
                                  queryParameters: {
                                    "subject":"Complaint",
                                    "body":"Respetfull sirr",
                                  }
                              );
                              if(await canLaunchUrl(url)){
                                launchUrl(url);
                              }
                            }


                          },
                            child: Container(
                              height: 30,
                              width: 70,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: colorr[index],
                              ),
                              child: Icon(size: 15,names[index]),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),

            ]
        ),
      ),
    );
  }
}