class CO2{ //Klasse für CO2-Teilchen eröffnen
  //Durchmesser
  int durchmesser; 
  
  //Position des CO2-Teilchens
  PVector positionCO2; 
  
  //Vektor, der die Endposition des CO2-Teilchens angibt
  PVector endposCO2;
  
  //Variable zur Entscheidung ob CO2 in Atmosphäre oder Wald
  int decision; 
  
  //Boolean ob CO2-Teilchen in die Atmosphäre geht oder nicht
  boolean atmosphere;
  
  //Boolean ob getestet werden muss 
  //ob CO2-Aufnahmestellen in den Bäumen noch frei sind
  boolean testing;
  
  //Integer, zur Hilfe der Tests der "freien" CO2-Aufnahmestellen in den Bäumen 
  int testNum;
  
  CO2(PVector posCO2){
    durchmesser = 30; 
    
    //Eingegebene Werte als Position festlegen
    positionCO2 = posCO2.get(); 
    
    //Endposition wird erstmal als zufälliger Punkt
    //in der Atmosphere festgelegt
    endposCO2 = new PVector(random(480, width), random(0, 110));
    
    //Zufallszahl wird generiert
    decision = (int)random(0, 60); 
    
    //Wenn die Zufallszahl unter 50, wandert das CO2-Teilchen
    //in den Wald, wenn sie höher ist in die Atmosphere
    if(decision <= 50){
      atmosphere = false;
    } 
    else{
      atmosphere = true;
    }
    
    //Integer wird zufällig generiert
    testNum = (int)random(0, positionPot.length-1);
    //testNum = 0;
    testing = true;
  }
 
  //Funktion für das Zeichnen der CO2-Aufnahmestellen in den Bäumen 
  void draw(){
    stroke(30);
    fill(60, 125, 20);
    ellipse(positionCO2.x, positionCO2.y, durchmesser, durchmesser);
  }
  
  //Funktion für die fliegenden CO2-Teilchen
  void fly(){
    //Zeichnen des CO2-Teilchens
    stroke(100);
    fill(150);
    ellipse(positionCO2.x, positionCO2.y, durchmesser, durchmesser);
    
    //println(decision);
    
    //Durch Farbtest wird geprüft, welche CO2-Aufnahmestellen in den Bäumen 
    //noch ein CO2-Teilchen "aufnehmen" können
    //Wenn ein freier Platz erkannt wird, wird seine Position als
    //Endposition des CO2-Teilchens festgelegt
    if(!atmosphere){
      if(testing){
        color testCO2 = get((int)positionPot[testNum].x, (int)positionPot[testNum].y);
        if(testCO2 == color(60, 125, 20)){
          testing = false;
          endposCO2 = new PVector(positionPot[testNum].x, positionPot[testNum].y);
        }
        else{
          testNum = (int)random(0, positionPot.length);
          //testNum++;
          if(testNum > 23){
            testNum = 0;
          }
        }
      }
      
    }
    
    //CO2-Teilchen wandert zum Endpunkt
    if(positionCO2.x < endposCO2.x){ 
      positionCO2.x = positionCO2.x+1;
    }
    if(positionCO2.x > endposCO2.x){ 
      positionCO2.x = positionCO2.x-1;
    }
    else{
      testing = false;
    }
    if(positionCO2.y > endposCO2.y){
      positionCO2.y = positionCO2.y-1;
    }
    if(positionCO2.y < endposCO2.y){
      positionCO2.y = positionCO2.y+1;
    }
    else{
      testing = false;
    }
    
    
  }
  
  
}
