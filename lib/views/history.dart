import 'package:final_project_course/control/classes.dart';
import 'package:final_project_course/views/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../control/constants.dart';
import '../control/layout.dart';


class HistoryScreen extends StatefulWidget {
   const HistoryScreen(this.pollDataList,{Key? key}) : super(key: key);
  final List<PollData> pollDataList ;

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return  defualtPageDesign(
      title: 'History',
      child: DefaultTabController(
        length: 2,
        child: Column(
          children:  [
            TabBar(
              indicatorColor: blue,
              labelColor: blue,
              tabs: const [
                Tab(
                  icon: Icon(Icons.create_new_folder),
                  text: "Created",
                ),
                Tab(
                  icon: Icon(Icons.how_to_vote_rounded),
                  text: "Voted",
                ),
              ],
            ),
             Expanded(
              child: TabBarView(
                children: [
                  widget.pollDataList.isEmpty ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/chart.json',width: 250),
                      const SizedBox(height: 20,),
                      Text('No data in the current time',style: TextStyle(fontSize: 20,color: blue),)
                    ],
                  ):ListView.builder(
                      itemBuilder: (BuildContext ctx, int index){
                    return  Padding(
                      padding: const EdgeInsets.all(15),
                      child: pollDesign(widget.pollDataList[index],true),
                    );
                  },
                  itemCount: widget.pollDataList.length
                  ),
                  widget.pollDataList.isEmpty ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/lottie/chart.json',width: 250),
                      const SizedBox(height: 20,),
                      Text('No data in the current time',style: TextStyle(fontSize: 20,color: blue),)
                    ],
                  ):ListView.builder(
                      itemBuilder: (BuildContext ctx, int index){
                        return  Padding(
                          padding: const EdgeInsets.all(15),
                          child: pollDesign(widget.pollDataList[index],false),
                        );
                      },
                      itemCount: widget.pollDataList.length),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class pollDesign extends StatefulWidget {
   pollDesign(this.pollData,this.tap,{Key? key}) : super(key: key);
  final PollData pollData;
  final bool tap;

  @override
  _pollDesignState createState() => _pollDesignState();
}

class _pollDesignState extends State<pollDesign> {

  late List<_ChartData> data;
  late TooltipBehavior _tooltip;
  late List<int> listNum ;

  @override
  void initState() {
    super.initState();
    data = List.generate(widget.pollData.voting!.length, (index) => _ChartData((index +1 ).toString(), int.parse(widget.pollData.voting![index]) ));
    _tooltip = TooltipBehavior(enable: true);
    listNum = List.generate(widget.pollData.voting!.length, (index) => int.parse( widget.pollData.voting![index] ));
    listNum.sort();
  }

  @override
  Widget build(BuildContext context) {
    int c = 0;
    if(widget.tap){
      if(widget.pollData.owner != userData.uid){
        return Container();
      }
    }
    else{
      if(!widget.pollData.voters!.contains(userData.uid) ){
        return Container();
      }
    }
    return Card(
      color: white,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.pollData.question,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
            widget.pollData.answerType == 'yesOrNo' ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('1 - No'),
                Text('2 - Yes'),
              ],
            ):Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.pollData.answers!.map((e)
                  {
                    c++;
                    return Text(c.toString()+' - '+e);
                  }
              ).toList(),
            ),
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                enableAxisAnimation: true,
                palette: cardColors,
                primaryYAxis: NumericAxis(
                    minimum: 0,
                    maximum: listNum.last.toDouble(),
                    interval: listNum.last.toDouble()==0? 1:( listNum.last.toDouble() /8 ).ceil().toDouble() ),
                tooltipBehavior: _tooltip,
                series: <ChartSeries<_ChartData, String>>[
                  ColumnSeries<_ChartData, String>(
                      dataSource: data,
                      xValueMapper: (_ChartData data, _) => data.x,
                      yValueMapper: (_ChartData data, _) => data.y,
                      name: 'Answers',
                      color: orange
                  )
                ]),
            Text('By '+ (widget.tap? 'me' : widget.pollData.ownerName) ,style: const TextStyle(fontSize: 12),),
          ],
        )
      ),
      );
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
