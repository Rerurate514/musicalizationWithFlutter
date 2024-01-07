enum PersonColumn{
  ID,
  NAME,
  CATEGORY,
  AGE,
  GENDER,
  ICON
}

extension PersonColumnExtension on PersonColumn {
  Set set(Person person){
    switch(this){
      case PersonColumn.ID: return { person.id };
      case PersonColumn.NAME: return { person.name };
      case PersonColumn.CATEGORY: return { person.category };
      case PersonColumn.AGE: return { person.age };
      case PersonColumn.GENDER: return { person.gender };
      case PersonColumn.ICON: return { person.icon };
    }
  }

  Type get type{
    switch(this){
      case PersonColumn.ID: return int;
      case PersonColumn.NAME: return String;
      case PersonColumn.CATEGORY: return String;
      case PersonColumn.AGE: return int;
      case PersonColumn.GENDER: return String;
      case PersonColumn.ICON: return String;
    }
  }
}

class PersonRecordEditor{
  final dataBaseManager = DataBaseManager();

  void edit({required int id, required PersonColumn column, required dynamic updateValue}) {
    final Person person = dataBaseManager.searchById<Person>(id: id);
    final Type columnType = column.type;

    dataBaseManager.edit<columnType>(edit: column.set(person), editValue: updateValue);
  }
}