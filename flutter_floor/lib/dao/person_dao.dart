
import 'package:floor/floor.dart';
import 'package:flutterfloor/entity/person.dart';



@dao
abstract class PersonDao {
//
//  @Query('SELECT * FROM task WHERE id = :id')
//  Future<Task> findTaskById(int id);
//
//  @Query('SELECT * FROM task')
//  Future<List<Task>> findAllTasks();
//
//  @Query('SELECT * FROM task')
//  Stream<List<Task>> findAllTasksAsStream();
//
//  @insert
//  Future<void> insertTask(Task task);
//
//  @insert
//  Future<void> insertTasks(List<Task> tasks);
//
//  @update
//  Future<void> updateTask(Task task);
//
//  @update
//  Future<void> updateTasks(List<Task> task);
//
//  @delete
//  Future<void> deleteTask(Task task);
//
//  @delete
//  Future<void> deleteTasks(List<Task> tasks);
  @Query('SELECT * FROM Person')
  Stream<List<Person>> findAllPersons();

  @Query('SELECT * FROM Person WHERE id = :id')
  Stream<Person> findPersonById(int id);


  @delete
  Future<void> deleteTask(Person task);


  @insert
  Future<void> insertPerson(Person person);
}