import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[100],
      appBar: AppBar(
        backgroundColor: Colors.teal[700],
        title: Text('Aplikace', style: TextStyle(color: Colors.white, fontSize: 28),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.teal[700],
                  ),
                  child: Icon(Icons.medical_services_rounded,size: 40,color: Colors.white,),
                ),
                ElevatedButton(
                  onPressed: () {

                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.teal[700],
                  ),
                  child: Icon(Icons.question_mark_rounded,size: 40,color: Colors.white,),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: (){},
                customBorder: const CircleBorder(),
                child: Container(
                  width: 200,
                  height: 200,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.teal[700]!,
                      width: 5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Image.asset(
                      'assets/swallowicon.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: Colors.teal[700],
            padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.lightbulb_outline_rounded
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.bar_chart
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.email_outlined
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: (){},
                  icon: Icon(
                      Icons.settings
                  ),
                  iconSize: 70,
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    shape: CircleBorder(
                      side: BorderSide(color: Colors.white,width: 3),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

