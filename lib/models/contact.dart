class Contact{

  int? id;
  String? name,number;

  Contact({this.id,this.name,this.number});
  String tblContact='Contact';
  Contact.fromMap(Map<dynamic,dynamic> map){
    id=map['id'];
    name=map['name'];
    number=map['number'];
  }

  Map<String,dynamic> toMap(){
    var map={'id':id,'name':name,'number':number};
    return map;
  }
}