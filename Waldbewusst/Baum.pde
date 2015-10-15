class Baum{
  
  //Array für die Bilder der verschiedenen Stadien
  PImage[] baumBild;
  
  //Position des Baumes
  PVector positionBaum;
  
  //zum Einstellen der Stadien des Baumes
  int stadium;
  
  //jeder Baum hat eine individuelle Nummer
  //zur Hilfe des Anzeigens der CO2-Aufnahmestellen in den Bäumen 
  int ID;
  
  //Timer zum gleichmäßigen Wachsen des Baumes
  int growingTimer;
  
  //beim erstellen eines Objektes der Klasse Baum
  //werden die ID, die Position und das Anfangsstadium 
  //individuell eigestellt
  Baum(int id, PVector pBaum, int stadi){
    
    //Bilder in Programm laden
    baumBild = new PImage[7];
    for (int i = 0; i < 7; i++) {
      baumBild[i] = loadImage("Baum" + (i+1) + ".png");
    }
    
    //Übertragung der eingegebenen Daten
    ID = id;
    positionBaum = pBaum;
    stadium = stadi;
    
    //vorerst wird der Timer auf null gesetzt
    growingTimer = 0;
    
  }
  
  void draw(){
    //der Timer wird der frameCount gleichgesetzt
    if(growingTimer == 0){
      growingTimer = frameCount;
    }
    //alle 200 frames wächst der Baum bis er Stadium 4 erreicht hat
    if(frameCount == growingTimer+200 && stadium < 4){
      stadium++;
      growingTimer = frameCount;
    }
    
    //Wenn mehr als 70 CO2-Teilchen in der Luft sind
    //wird bei den Bäumen das erste Verfallsstadium angezeigt
    if(CO2Teilchen.size() > 70){ 
      stadium = 5;
    }
    //Wenn mehr als 110 CO2-Teilchen in der Luft sind
    //wird bei den Bäumen das zweite Verfallsstadium angezeigt
    if(CO2Teilchen.size() > 110){ 
      stadium = 6;
    }
    //Wenn mehr als 140 CO2-Teilchen in der Luft sind
    //wird bei den Bäumen das letzte Verfallsstadium angezeigt
    if(CO2Teilchen.size() > 140){ 
      stadium = 7;
    }
    
    //Wenn weniger als 70 CO2-Teilchen in der Luft sind
    //"erholt" sich der Baum nach und nach
    else{
      if(stadium > 4 && stadium < 7 && frameCount == growingTimer+300){
        stadium--;
        growingTimer = frameCount;
      }
    } 
    
    
    //Für jedes Stadium wird ein anderes Bild angezeigt
    //und die Anzahl der CO2-Aufnahmestellen variiert
    if(stadium == 1){
      image(baumBild[0], positionBaum.x, positionBaum.y, 130, 210);
      
    }
    if(stadium == 2){
      image(baumBild[1], positionBaum.x, positionBaum.y, 130, 210);
      for(int hole = ID; hole < ID+1; hole++){
        CO2 display = CO2Potential.get(hole);
        display.draw();
      }
    }
    if(stadium == 3){
      image(baumBild[2], positionBaum.x, positionBaum.y, 130, 210);
      for(int hole = ID; hole < ID+2; hole++){
        CO2 display = CO2Potential.get(hole);
        display.draw();
      }
    }
    if(stadium == 4){
      image(baumBild[3], positionBaum.x, positionBaum.y, 130, 210);
      for(int hole = ID; hole < ID+4; hole++){
        CO2 display = CO2Potential.get(hole);
        display.draw();
      }
    }
    if(stadium == 5){
      image(baumBild[4], positionBaum.x, positionBaum.y, 130, 210);
      for(int hole = ID; hole < ID+3; hole++){
        CO2 display = CO2Potential.get(hole);
        display.draw();
      }
    }
    if(stadium == 6){
      image(baumBild[5], positionBaum.x, positionBaum.y, 130, 210);
      for(int hole = ID; hole < ID+1; hole++){
        CO2 display = CO2Potential.get(hole);
        display.draw();
      }
    }
    if(stadium == 7){
      image(baumBild[6], positionBaum.x, positionBaum.y, 130, 210);
    }
    
    
  }
  
}
