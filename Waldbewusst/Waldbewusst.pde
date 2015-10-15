// import the TUIO library
import TUIO.*;
// declare a TuioProcessing client
TuioProcessing tuioClient;

// these are some helper variables which are used
// to create scalable graphical feedback
float cursor_size = 15;
float object_size = 60;
float table_size = 760;
float scale_factor = 1;

boolean verbose = false; // print console debug messages
boolean callback = true; // updates only after callbacks



PImage back; //Hintergrundbild
PImage backLight; //Hintergrundbild wenn Lichter an

// Sound importieren
import ddf.minim.*;
Minim minim;
AudioPlayer song;
AudioPlayer bike;
AudioPlayer car;

//Bilder für das Thermometer
PImage termoKalt;
PImage termoWarm;

//Haptische Elemente und Fabrik als Objekte der Klasse Verbraucher
Verbraucher Auto1;
Verbraucher Auto2;
Verbraucher Auto3;
Verbraucher Fabrik;

//Bäume als Objekte der Klasse Baum
Baum Baum1;
Baum Baum2;
Baum Baum3;
Baum Baum4;
Baum Baum5;
Baum Baum6;

//Boolean zur Vereinfachung des Pflanzens neuer Bäume
boolean gepflanzt1 = false;
boolean gepflanzt2 = false;

//ArrayList für alle sichtbaren CO2-Teilchen initialisieren
ArrayList<CO2> CO2Teilchen;
//Arraylist für die CO2-Aufnahmestellen in den Bäumen
ArrayList<CO2> CO2Potential;

//Position der CO2-Aufnahmestellen in den Bäumen als Array
PVector[] positionPot = new PVector[24];


//Position für die Stellen für die Auflagestellen der Verbraucher festgelegt
PVector AutoSpace1 = new PVector(300, 450);
PVector AutoSpace2 = new PVector(170, 480);
PVector AutoSpace3 = new PVector(400, 365);
PVector FabrikSpace = new PVector(289, 205);

//Boolean für kleine Quadrate, die zur Hilfe verwendet werden
boolean quad1 = false;
boolean quad2 = false;
boolean quad3 = false;

//Boolean zur Hilfe des Fabrikmechanismus
boolean fab = false;

//Integer zur Differenzierung der Marker
int fidu;

void setup(){
  size(850, 600);
  rectMode(CENTER);
  imageMode(CENTER);
  smooth();
  
  //Vogelgezwitscher im Hintergrund
  minim = new Minim(this);
  song = minim.loadFile("vogelgezwitscher.mp3");
  song.loop();
  
  // periodic updates
  if (!callback) {
    frameRate(60); //<>//
    loop();
  } else noLoop(); // or callback updates 

  scale_factor = height/table_size;

  // finally we create an instance of the TuioProcessing client
  // since we add "this" class as an argument the TuioProcessing class expects
  // an implementation of the TUIO callback methods in this class (see below)
  tuioClient  = new TuioProcessing(this);
  
  
  
  //Hintergrundbild laden
  back = loadImage("Hintergrund.png");
  backLight = loadImage("Hintergrund2.png");
  
  //Thermometerbild laden
  termoKalt = loadImage("termo1.png");
  termoWarm = loadImage("termo2.png");
  
  //Haptische Elemente als Objekte
  Auto1 = new Verbraucher(new PVector(AutoSpace1.x, AutoSpace1.y), 60);
  Auto2 = new Verbraucher(new PVector(AutoSpace2.x, AutoSpace2.y), 60);
  Auto3 = new Verbraucher(new PVector(AutoSpace3.x, AutoSpace3.y), 60);
  Fabrik = new Verbraucher(new PVector(FabrikSpace.x, FabrikSpace.y), 30);
  
  //Array mit Vektoren für Positionen der Löcher füllen
  positionPot[0] = new PVector(475, 390);
  positionPot[1] = new PVector(439, 420);
  positionPot[2] = new PVector(504, 424);
  positionPot[3] = new PVector(467, 333);
  
  positionPot[4] = new PVector(574, 385);
  positionPot[5] = new PVector(546, 412);
  positionPot[6] = new PVector(600, 423);
  positionPot[7] = new PVector(568, 345);
  
  positionPot[8] = new PVector(685, 374);
  positionPot[9] = new PVector(648, 401);
  positionPot[10] = new PVector(715, 410);
  positionPot[11] = new PVector(678, 335);
  
  positionPot[12] = new PVector(792, 409);
  positionPot[13] = new PVector(755, 436);
  positionPot[14] = new PVector(827, 442);
  positionPot[15] = new PVector(787, 352);
  
  positionPot[16] = new PVector(605, 480);
  positionPot[17] = new PVector(574, 504);
  positionPot[18] = new PVector(638, 510);
  positionPot[19] = new PVector(602, 439);
  
  positionPot[20] = new PVector(513, 485);
  positionPot[21] = new PVector(483, 509);
  positionPot[22] = new PVector(541, 508);
  positionPot[23] = new PVector(514, 446);
  
  
  //Bäume initialisieren
  Baum1 = new Baum(0, new PVector(positionPot[0].x, positionPot[0].y), 4);
  Baum2 = new Baum(4, new PVector(positionPot[4].x, positionPot[4].y), 3);
  Baum3 = new Baum(8, new PVector(positionPot[8].x, positionPot[8].y), 4);
  Baum4 = new Baum(12, new PVector(positionPot[12].x, positionPot[12].y), 4);
  Baum5 = new Baum(16, new PVector(positionPot[16].x, positionPot[16].y), 1);
  Baum6 = new Baum(20, new PVector(positionPot[20].x, positionPot[20].y), 1);
  
  
  //ArrayList für alle sichtbaren CO2-Teilchen erstellen
  CO2Teilchen = new ArrayList<CO2>();
  //ArrayList für alle CO2-Löcher erstellen
  CO2Potential = new ArrayList<CO2>();
  
  //Löcher in Bäumen in ArrayList hinzufügen
  for(int coX = 0; coX < positionPot.length; coX++){
    CO2Potential.add(new CO2(new PVector(positionPot[coX].x, positionPot[coX].y)));
  }
  
}

//Fullscreen-Mode
boolean sketchFullScreen() {
  return true;
}


void draw(){
  //println("CO2 " + CO2Teilchen.size());
  
  //Verschiedenen Hintergrund anzeigen, je nach dem ob die 
  //Lichter in den Häusern an sein sollen oder nicht
  if(!fab){
    image(back, width/2, height/2, width, height);
  }
  else{
    image(backLight, width/2, height/2, width, height);
  }
  
  //Bäume anzeigen
  Baum3.draw();
  Baum4.draw();
  Baum2.draw();
  Baum1.draw();
  
  //Weitere Bäume erst anzeigen, wenn sie gepflanzt wurden
  if(gepflanzt1){
    Baum5.draw();
  }
  if(gepflanzt2){
    Baum6.draw();
  }
  
  float obj_size = object_size*scale_factor; 
  float cur_size = cursor_size*scale_factor; 

  ArrayList<TuioObject> tuioObjectList = tuioClient.getTuioObjectList();
  for (int i=0; i<tuioObjectList.size (); i++) {
    TuioObject tobj = tuioObjectList.get(i);
    stroke(0);
    fidu = tobj.getSymbolID();
    if(fidu == 0 || fidu == 3 || fidu == 4){
      fill(255, 0, 0);
    }
    if(fidu == 2 || fidu == 5 || fidu == 6){
      fill(0, 0, 255);
    }
    if(fidu == 1 || fidu == 7){
      fill(0, 255, 0);
    }
    pushMatrix();
    translate(tobj.getScreenX(width), tobj.getScreenY(height));
    rotate(tobj.getAngle());
    
    rect(-obj_size/2, -obj_size/2, obj_size, obj_size);
    
    popMatrix();
    //fill(255);
    //text(""+tobj.getSymbolID(), tobj.getScreenX(width), tobj.getScreenY(height));
  }
  /*
  ArrayList<TuioCursor> tuioCursorList = tuioClient.getTuioCursorList();
  for (int i=0; i<tuioCursorList.size (); i++) {
    TuioCursor tcur = tuioCursorList.get(i);
    ArrayList<TuioPoint> pointList = tcur.getPath();

    if (pointList.size()>0) {
      stroke(0, 0, 255);
      TuioPoint start_point = pointList.get(0);
      for (int j=0; j<pointList.size (); j++) {
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
  }*/
  
  
  //Zeigt alle CO2-Teilchen an, die in der ArrayList enthalten sind
  for(int ball = 0; ball < CO2Teilchen.size(); ball++){
    CO2 show = CO2Teilchen.get(ball);
    show.fly();
  }
  
  //Wenn mehr als 150 CO2-Teilchen vorhanden 
  //von vorne beginnen aus der Liste zu löschen
  if(CO2Teilchen.size() > 150){
    CO2Teilchen.remove(0);
  }
  //regelmäßig das listenerste CO2-Teilchen löschen
  if(CO2Teilchen.size() > 0 && frameCount % 400 == 0){
    CO2Teilchen.remove(0);
  }
  
  //Wenn die Booleans auf true gesetzt werden
  //wird an den Auflagestellen der Autos ein kleines rotes Quadrat angezeigt
  if(quad1){
  fill(255, 0, 0);
  rect(AutoSpace1.x, AutoSpace1.y, 20, 20);
  }
  if(quad2){
  fill(255, 0, 0);
  rect(AutoSpace2.x, AutoSpace2.y, 20, 20);
  }
  if(quad3){
  fill(255, 0, 0);
  rect(AutoSpace3.x, AutoSpace3.y, 20, 20);
  }
  
  //Farbtest an den Auflagestellen der Autos, 
  //wenn rot erkannt wird, soll die draw-Funktion des jeweiligen Autos
  //ausgeführt werden
  color test1 = get((int)AutoSpace1.x, (int)AutoSpace1.y);
  if(test1 == color(255, 0, 0)){
    Auto1.draw();
  }
  color test2 = get((int)AutoSpace2.x, (int)AutoSpace2.y);
  if(test2 == color(255, 0, 0)){
    Auto2.draw();
  }
  color test3 = get((int)AutoSpace3.x, (int)AutoSpace3.y);
  if(test3 == color(255, 0, 0)){
    Auto3.draw();
  }
  
  //Ist der Boolean auf true, 
  //soll die draw-Funktion der Fabrik ausgeführt werden
  if(fab){
    Fabrik.draw();
  }
  
  //Erzeugt einen röteren "Glow" am Bildschirmrand,
  //desto mehr CO2-Teilchen in der Luft sind
  for(int a = 0; a < 150; a++){
    noStroke();
    fill(255, 150-CO2Teilchen.size(), 0, 50+CO2Teilchen.size()-2*a);
    rect(width/2, a, width, 1);
    rect(a, height/2, 1, height);
    rect(width/2, height-a, width, 1);
    rect(width-a, height/2, 1, height);
  }
  
  //Anzeigen des Thermometers nach Anzahl der CO2-Teilchen in der Luft
  if(CO2Teilchen.size() < 100){
    image(termoKalt, 9.5*width/10, height/8, 75, 100);
  }
  else{
    image(termoWarm, 9.5*width/10, height/8, 75, 100);
  }
}




void keyPressed(){
  
  //Fabrik an und aus
  if(key == 'z'){
    fab = true;
  }
  if(key == 'h'){
    fab = false;
  }
  
  //Baum5 und Baum6 werden gepflanzt
  if(key == 'b'){
    gepflanzt1 = true;
  }
  if(key == 'v'){
    gepflanzt2 = true;
  }
  
  
  //Auto1 wird aktiviert und deaktiviert
  //plus Ausgabe von Hup-Geräuschen
  if(key == 'w'){
    quad1 = true;
    minim = new Minim(this);
    car = minim.loadFile("AutoHupen.mp3");
    car.play();
  }
  if(key == 's'){
    quad1 = false;
  }
  
  //Auto2 wird aktiviert und deaktiviert
  //plus Ausgabe von Hup-Geräuschen
  if(key == 'q'){
    quad2 = true;
    minim = new Minim(this);
    car = minim.loadFile("AutoHupen.mp3");
    car.play();
  }
  if(key == 'a'){
    quad2 = false;
  }
  
  //Auto3 wird aktiviert und deaktiviert
  //plus Ausgabe von Hup-Geräuschen
  if(key == 'e'){
    quad3 = true;
    minim = new Minim(this);
    car = minim.loadFile("AutoHupen.mp3");
    car.play();
  }
  if(key == 'd'){
    quad3 = false;
  }
  
  //Fahrradgeräusche werden abgespielt
  if(key == 'f'){
    minim = new Minim(this);
    bike = minim.loadFile("radfahren.mp3");
    bike.play();
  }
  
  //Bäume 1-4 können in das erste Krankheitsstadium versetzt werden
  if(key == 'j'){
    Baum1.stadium = 1;
  }
  if(key == 'k'){
    Baum2.stadium = 1;
  }
  if(key == 'l'){
    Baum3.stadium = 1;
  }
  if(key == 'ö'){
    Baum4.stadium = 1;
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
}

// called when an object is removed from the scene
void removeTuioObject(TuioObject tobj) {
  if (verbose) println("del obj "+tobj.getSymbolID()+" ("+tobj.getSessionID()+")");
}

/*
// --------------------------------------------------------------
// called when a cursor is added to the scene
void addTuioCursor(TuioCursor tcur) {
  if (verbose) println("add cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY());
  //redraw();
}

// called when a cursor is moved
void updateTuioCursor (TuioCursor tcur) {
  if (verbose) println("set cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+ ") " +tcur.getX()+" "+tcur.getY()
    +" "+tcur.getMotionSpeed()+" "+tcur.getMotionAccel());
  //redraw();
}

// called when a cursor is removed from the scene
void removeTuioCursor(TuioCursor tcur) {
  if (verbose) println("del cur "+tcur.getCursorID()+" ("+tcur.getSessionID()+")");
  //redraw()
}*/

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


// called at the end of each TUIO frame
void refresh(TuioTime frameTime) {
  if (verbose) println("frame #"+frameTime.getFrameID()+" ("+frameTime.getTotalMilliseconds()+")");
  if (callback) redraw();
}

