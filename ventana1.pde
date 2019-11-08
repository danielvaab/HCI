/*ventana que tiene el fondo2*/
public class Ventana{
void transporte2(){
    image(fondo2, 0, 0);
    Ruta1="";Ruta2="";Ruta3="";Ruta4="";Ruta5="";H=""; mensajeInformacion="";//dejar estos campos vacios
    
    /*cuadro de informacion*/
    stroke(#718180);//color linea del cuadrado
    strokeWeight(10);//grosor de la linea
    rect(740, 370, 120, 120, 7);//cuadrado de informacion
    
    /*cuadros de validacion*/
  stroke(#718180);//color linea del cuadrado
  strokeWeight(10);//grosor de la linea
  rect(150, 700, 285, 285, 7);//cuadrado de validacion
  rect(650, 700, 285, 285, 7);//cuadrado de validacion
}

}
