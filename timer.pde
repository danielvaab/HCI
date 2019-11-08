class Timer{
 float Time;
 
 Timer(float set) // contructor cuando se crea un nuevo tiempo
 {
 Time=set;
 }
 float getTime() //retorna el actual tiempo para trabjar
 {
  return(Time);
 }
 void setTime(float set) //manda el tiempo a donde sea que ponga la variable temp ie 10, 60 segundos
 {
 Time = set;
 }
 void countUp() //update el tiempo contando arriba. esto se nesecita ser llamado sin un vpid draw 
 {
  Time += 1/frameRate;
 }
 void countDown()
 { //update el tiempo contando joaba. esto se nesecita ser llamado sin un vpid draw 
  Time -= 1/frameRate;
 }
 
}
