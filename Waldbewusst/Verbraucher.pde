class Verbraucher{ //Klasse für die Verbraucher eröffnen
  //Menge die ein Objekt dieser Klasse "ausstoßen" soll
  int CO2Menge;
  
  //Hilfszahl für regelmäßigen CO2 Ausstoß
  int pollutionTimer;
  
  //Position an der die CO2-Teilchen "ausgestoßen" werden
  PVector pollutionPoint;
  
  //beim erstellen eines Objektes der Klasse Verbraucher
  //werden der pollutionPoint und die CO2Menge 
  //individuell eingestellt
  Verbraucher(PVector pPoint, int menge){
    //Übertragung der eingegebenen Daten
    CO2Menge = menge;
    pollutionPoint = pPoint;
    
    //vorerst wird der Timer auf null gesetzt
    pollutionTimer = 0;
  }
  
  void draw(){
    //der Timer wird der frameCount gleichgesetzt  
    if(pollutionTimer == 0){
      pollutionTimer = frameCount;
    }
    
    //CO2-Teilchen wird im regelmäßigen Abstand, der "CO2Menge", 
    //der ArrayList CO2Teilchen hinzugefügt
    if((frameCount-pollutionTimer) % CO2Menge == 0){
      CO2Teilchen.add(new CO2(new PVector(pollutionPoint.x, pollutionPoint.y)));
    }
  }
  
}
