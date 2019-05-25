class StateUserLogin {
    static int id;
    static var userid;
    static var name;
    static var age;
    static var password;
    static var quote;

    static String whoCurrent(){
      return "current -> _id: ${id}, userid: ${userid}, name: ${name}, age: ${age}, password: ${password}, quote: ${quote}";
   }
}