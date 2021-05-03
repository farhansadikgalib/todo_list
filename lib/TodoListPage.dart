import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Task.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

final TextEditingController _controller = TextEditingController();




class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Todo List"),
      ),

      body: _buildbody(context),


    );
  }
}






// body
Widget _buildbody(BuildContext context){

  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
                child: TextField(
              decoration: InputDecoration(hintText: "Enter Task Name"),
              controller: _controller,
            )),
            FlatButton(
                child: Text(
                  "Add Task",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                onPressed: () {
                  _addTask();


                }),
          ],

        ),


        // firestore data list

        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("todos").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return LinearProgressIndicator();
            return Expanded(
                child: _builList(snapshot.data)
            );
          },
        )

        // Expanded(
        //   child: ListView.builder(
        //     itemCount: 20,
        //     itemBuilder: (context, index){
        //      return ListTile(title: Text("Your Task here"),
        //
        //      );
        //    }
        //
        //   ),
        // )
      ],
    ),
  );
}




void _addTask(){

  FirebaseFirestore.instance.collection("todos").add({"title":_controller.text});

  _controller.text= "";

}

// handle data

Widget _builList(QuerySnapshot snapshot){
return ListView.builder(
    itemCount: snapshot.docs.length,
    itemBuilder: (context,index){
      final doc = snapshot.docs[index];
      final map = doc.data();
      final task = Task.fromSnapshot(doc);


      return _buildListItem(task);


      // return ListTile(
      //   title: Text(map["title"]),
      //
      // );
    },


);


}

Widget _buildListItem(Task task) {
  // return Expanded(child: ListTile(
  //
  //   title: Text(task.title),
  //
  // ));

  return Dismissible(
      key: Key(task.taskId),
      onDismissed: (direction){
        _deleteTask(task);
      },
      background: Container(color: Colors.red,),
      child: Expanded(child: ListTile(
        title: Text(task.title),
      )));



// return 
//   Dismissible(
//   key: Key(task.taskId),
//   onDismissed: (direction){
//     _deleteTask(task);
//   },
//
//   background: Container(
//     color: Colors.red,
//     child:
//     Expanded(child: ListTile(
//         title: Text(task.title)
//     ),),
//   ),
//
//
// );

}

void _deleteTask(Task task) async {
  FirebaseFirestore.instance.collection("todos").doc(task.taskId).delete();
}






