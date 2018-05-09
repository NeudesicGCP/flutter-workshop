import 'dart:collection';

// Helper class to create a queue to hold the bill amount
class CalcNumber{
  Queue queue = new Queue();

  CalcNumber(){
    queue.add(0);
    queue.add(0);
    queue.add(0);
  }

  addNumber(int number){
    if(queue.first == 0){
      queue.removeFirst();
      queue = new Queue.from(queue.where((x) => x!= null));
    }
    queue.addLast(number);
  }

  removeNumber(){
    queue.removeLast();
    if(queue.length < 3)
      queue.addFirst(0);
  }

  clearQueue(){
    queue.clear();
    queue.addFirst(0);
    queue.addFirst(0);
    queue.addFirst(0);
  }

  // Extension to return the queue as a string for comparison purposes
  String queueToString(){
    String temp = "";
    for (var item in queue){
      temp += "$item";
    }
    return temp;
  }
}