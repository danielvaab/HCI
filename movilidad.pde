import TUIO.*;// import the TUIO library
TuioProcessing tuioClient;// declare a TuioProcessing client
Ventana abrirVentana;
Timer startTimer; //llamar la clase timer

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;
PFont font;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks
boolean seleccionOp=false;//el de menu opciones

/*Variables usadas en interfaz*/
PShape fondo;//imagen fondo
PImage encabezado;//imagen encabezado
PImage fondo2;//imagen fondo 2
boolean showimage = true;//mostrar pantalla 2
PFont font100;  // texto que usaran
int coorXt=200, cooYt=450, coorXh=800, coorYh=350;//coordenada para todos los textos
int[] PC_Time = new int[3];  // Variable para registrar la hora
int[] DD_MM_YY = new int[3]; // Variable para registrar la fecha
String curr_time, curr_date, row_data, filename;  // Variables para obtención de tiempo, hora, texto informativo inferior y nombre log
String mensajeInformacion = "Para más información, acerque el fidusial a su destino";//mensaje de final
String H="Hora:";
String  textoInforD="";
String Ruta1="Boyacá", Ruta2="Héroes", Ruta3="Portal", Ruta4="Ezperanza", Ruta5="Suba";
String infoFidusial="",nombreRuta="";
float angulo;//saber el angulo

/*Variables fiducials*/
int numeroID;//ID del feauture
int posX, posY;//posicion del feauture
boolean validacion=false;//si esta dentro del cuadro o no

PShape chulo;//imagen de validacion
float Time,timeDentro=0.1;//tiempo de 5 segundos

void setup() {
  // GUI setup
  noCursor();
  size(displayWidth, displayHeight);
  noStroke();
  fill(0);
  // periodic updates
  if (!callback) {
    frameRate(60);
    loop();
  } else noLoop(); // or callback updates 

  font = createFont("Arial", 18);
  scale_factor = height/table_size;

  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);

  fondo = loadShape("fondo.svg");//imagen fondo
  encabezado = loadImage("titulo.png");//imagen encabezado
  font100 = loadFont("Arial-BoldMT-100.vlw");//tipo de letra a usar
  fondo2 = loadImage("fondo2.png");//fondo 2 cargado
  startTimer = new Timer(timeDentro);//dar un tiempo de 5 segundos
  chulo = loadShape("chulo.svg");//imagen chulo
  
  abrirVentana= new Ventana();
}
void draw() {

  background(255);
  
  /*informaciones*/
  fill(#EA1C1C);
  text("el esta o no esta "+infoFidusial, 1250, 200);//esta o no
  text("el nombre es "+nombreRuta, 1250, 600);//nombreRuta
  text("el angulo es "+angulo, 1250, 800);//angulo
  text(startTimer.getTime(), 1300, 100);//poner el tiempo de temporizador

  textFont(font, 18*scale_factor);
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 
  shape(fondo);//Imagen fondo
  image(encabezado, 0, 0);//imagen encabezado
  text(textoInforD, 1250, 500);// donde se pondra la información, cumplio o no se cumplio
  /*cuadro de validacion*/
  stroke(#718180);//color linea del cuadrado
  strokeWeight(10);//grosor de la linea
  fill(#E5FCFB);
  rect(750, 290, 185, 185, 7);//cuadrado de validacion
  //rect(750, (280*6), 185, 185, 7); //poner esta
  shape(chulo, 1220, 0, 50, 50);//Imagen chulito
  chulo.setVisible(seleccionOp);//le dice que si la operacion es verdadera muestre las opciones

/*aca llamamos la ventana1*/
  if (seleccionOp && infoFidusial=="esta" ) {
    abrirVentana.transporte2(); //clase donde se programa toda la ventana 2

  } else { 
    Ruta1="Boyacá"; Ruta2="Héroes"; Ruta3="Portal"; Ruta4="Ezperanza"; Ruta5="Suba"; H="Hora:"; mensajeInformacion = "Para más información, acerque el fidusial a su destino";
  }


  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size(); i++) {
    TuioObject tobj = tuioObjectList.get(i);
    stroke(0);
    fill(0, 0, 0);
    pushMatrix();
    translate(tobj.getScreenX(width), tobj.getScreenY(height));
    rotate(tobj.getAngle());
    rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
    popMatrix();
    fill(255);
    text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
  }

  ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
  for (int i=0; i<tuioCursorList.size(); i++) {
    TuioCursor tcur = tuioCursorList.get(i);
    ArrayList<TuioPoint> pointList = tcur.getPath();

    if (pointList.size()>0) {
      stroke(0, 0, 255);
      TuioPoint start_point = pointList.get(0);
      for (int j=0; j<pointList.size(); j++) {
        TuioPoint end_point = pointList.get(j);
        line(start_point.getScreenX(width), start_point.getScreenY(height), end_point.getScreenX(width), end_point.getScreenY(height));
        start_point = end_point;
      }

      stroke(192, 192, 192);
      fill(192, 192, 192);
      ellipse( tcur.getScreenX(width), tcur.getScreenY(height), cur_size, cur_size);
      fill(0);
      text(""+ tcur.getCursorID(), tcur.getScreenX(width)-5, tcur.getScreenY(height)+5);
    }
  }
  ArrayList<TuioBlob> tuioBlobList = tuioClient.getTuioBlobList();
  for (int i=0; i<tuioBlobList.size(); i++) {
    TuioBlob tblb = tuioBlobList.get(i);
    stroke(0);
    fill(0);
    pushMatrix();
    translate(tblb.getScreenX(width), tblb.getScreenY(height));
    rotate(tblb.getAngle());
    ellipse(-1*tblb.getScreenWidth(width)/2, -1*tblb.getScreenHeight(height)/2, tblb.getScreenWidth(width), tblb.getScreenWidth(width));
    popMatrix();
    fill(255);
    text(""+tblb.getBlobID(), tblb.getScreenX(width), tblb.getScreenX(width));
  }


  /*Obtención de la fecha y hora del PC*/
  curr_time = PC_Time();  // Cargamos en la variable el valor obtenido al llamar la función "PC_Time()"
  curr_date = PC_Date();  // Cargamos en la variable el valor obtenido al llamar la función "PC_Date()"
  /*textos de nombres de las rutas*/
  fill(#FFFFFF);
  textSize(100);//tamaño de las letras RUTAS
  textFont(font100);//tipo de letra
  text(Ruta1, coorXt, cooYt);
  text(Ruta2, coorXt, cooYt+270);
  text(Ruta3, coorXt, cooYt+(270*2));
  text(Ruta4, coorXt, cooYt+(270*3));
  text(Ruta5, coorXt, cooYt+(270*4));

  /*texto de las horas*/
  fill(#FFFFFF);
  textSize(50);//tamaño de las letras HORA
  text(H, coorXh, coorYh);
  text(H, coorXh, coorYh+270);
  text(H, coorXh, coorYh+(270*2));
  text(H, coorXh, coorYh+(270*3));
  text(H, coorXh, coorYh+(270*4));

  /*texto de informacion*/
  fill(#FFFFFF);
  textSize(50);//tamaño de las letras MENSAJE
  text(mensajeInformacion, coorXt-90, cooYt+(270*5)-120, coorXt+400, cooYt+(270*5)+190);

  /*texto de fecha y hora*/
  fill(#E5FCFB);
  textSize(40);//tamaño de las letras TIEMPO
  text(curr_date, 800, 180);  // Imprimimos el contenido de la variable y lo posicionamos
  text(curr_time, 810, 220);  // Imprimimos el contenido de la variable y lo posicionamos



  /*programacion validacion*/
  update(posX, posY); //esto me actualiza las posciones

  if (validacion) {
    startTimer.countDown();//tiempo hacia abajo
    Time -= 1/frameRate;//para hacer la comparacion  //probar el tiempo
    if (Time<0) {
      textoInforD="se cumplio";
    } else {
      textoInforD="no se cumplio";
    }
    
  } else {


   startTimer = new Timer(0.1);//vovler a iniciar en 5
   Time=0.1;//vovler a iniciar en 5*/
    
  }

  if (textoInforD=="se cumplio") {
    seleccionOp=true;
  } else {
    seleccionOp=false;
  }
  //fill(#EA1C1C);
  
}

void update(int x, int y) {
  if (overRect(750, 290, 185, 185)) {  // LLamamos a la funcion "overRect" enviando las coordenadas de nuestro boton
    validacion = true;  // Si la función "overRect" indica que coinciden las coordenadas del botón con las del mouse y ponemos la variable a "true"
  } else {
    validacion=false;  // Si no es así, ponemos la variable en "false"
  }
}
boolean overRect(int x, int y, int width, int height) {
  if (posX >= x && posX <= x+width &&     // Si las coordenadas son correctas envía true, sino false
    posY >= y && posY <= y+height) {
    return true;
  } else {
    return false;
  }
}
// called when an object is added to the scene
void addTuioObject(TuioObject tobj) {
  if (verbose) println("add obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle());
}

// called when an object is moved
void updateTuioObject (TuioObject tobj) {
  if (verbose) println("set obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+") "+tobj.getX()+" "+tobj.getY()+" "+tobj.getAngle()
    +" "+tobj.getMotionSpeed()+" "+tobj.getRotationSpeed()+" "+tobj.getMotionAccel()+" "+tobj.getRotationAccel());
  numeroID=tobj.getSymbolID();
  angulo=tobj.getAngle();
  println("entro el "+numeroID);//obtener el ID del que entro
  posX = round(tobj.getX()*width);//devolver posX
  posY = round(tobj.getY()*height);//devolver posY
  infoFidusial="esta";
  if(numeroID==0){
    nombreRuta="Boyaca";

  }else if(numeroID==1){
   nombreRuta="Heroes";
  }
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
  println("salio el "+numeroID); //obtener el ID del que salio
  textoInforD="no se cumplio";
  seleccionOp=false;
  infoFidusial="No esta";

}

// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called when a blob is added to the scene
void addTuioBlob(TuioBlob tblb) {
  if (verbose) println("add blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea());
  //redraw();
}

// called when a blob is moved
void updateTuioBlob (TuioBlob tblb) {
  if (verbose) println("set blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+") "+tblb.getX()+" "+tblb.getY()+" "+tblb.getAngle()+" "+tblb.getWidth()+" "+tblb.getHeight()+" "+tblb.getArea()
    +" "+tblb.getMotionSpeed()+" "+tblb.getRotationSpeed()+" "+tblb.getMotionAccel()+" "+tblb.getRotationAccel());
  //redraw()
}

// called when a blob is removed from the scene
void removeTuioBlob(TuioBlob tblb) {
  if (verbose) println("del blb "+tblb.getBlobID()+" ("+tblb.getSessionID()+")");
  //redraw()
}

// --------------------------------------------------------------
// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}


/*Función para obtener la hora del ordenador*/
String PC_Time() {
  PC_Time[2] = second();  // Valores de 0 a 59
  PC_Time[1] = minute();  // Valores de 0 a 59
  PC_Time[0] = hour();    // Valores de 0 a 23
  return join(nf(PC_Time, 2), " : ");  // Devolvemos la hora completa indicando que entre cada número se impriman ":"
}

/*Función para obtener la fecha del ordenador*/
String PC_Date() {
  DD_MM_YY[2] = year();    
  DD_MM_YY[1] = month(); 
  DD_MM_YY[0] = day(); 
  return join(nf(DD_MM_YY, 2), " / ");
}
