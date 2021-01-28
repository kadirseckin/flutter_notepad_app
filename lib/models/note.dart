class Note{
  int noteID;
  String noteTitle;
  String noteContent;
  String noteDate;
  int notePriority;

  Note(this.noteTitle, this.noteContent, this.noteDate, this.notePriority); //writing

  Note.withID(this.noteID, this.noteTitle, this.noteContent, this.noteDate,//reading
      this.notePriority);

  Map<String,dynamic> toMap(){  //note object => map
    Map map=Map<String,dynamic>();
   // map["noteID"]=noteID;
    map["noteTitle"]=noteTitle;
    map["noteContent"]=noteContent;
    map["noteDate"]=noteDate;
    map["notePriority"]=notePriority;

    return map;
  }

  Note.fromMap(Map<String,dynamic> map){  //map => note object

    noteID =map["noteID"];
    noteTitle=map["noteTitle"]  ;
    noteContent= map["noteContent"] ;
    noteDate= map["noteDate"];
    notePriority=map["notePriority"];
  }
}