import processing.sound.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.event.KeyEvent;
Amplitude amp;
AudioIn in;
AudioIn in2;
Robot robot;

// il me faudrait sans doute juste un trigger pour faire un note UP quand le volume dépasse x
// puis un note DOWN quand le volume repasse en dessous de y
boolean noteUp = false;
boolean half = false;
int cursor = 0;
int[] sequence;
int skipbeat = 1;

void setup() {
  frameRate(60);
  size(1, 1);  
  
String[] lines = loadStrings("/Users/Samuel/Desktop/theString.csv");
String joinedLines = join(lines, " , "); 
sequence = int(split(joinedLines, ", "));
       
// ok so sequence is the path now.

    try { 
    robot = new Robot();
  } catch (AWTException e) {
    e.printStackTrace();
    exit();
  }
    
  Sound s = new Sound(this);

  s.inputDevice(3);
  // ATTENTION BUG POTENTIEL, c'est pas toujours le troisième élement de la liste
  // par exemple à la bellone (oct 19) c'était le numéro 0
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in2 = new AudioIn(this, 1);
  in.start();
  amp.input(in);
   // in.play(1);
  // playback of audio input : will larsen if you use computer's mic
}      

void draw() {
  // println(amp.analyze()); 
  if(amp.analyze()<0.3 && noteUp==true){
    if(skipbeat%4==0){
     //println("go");
    // if sound is louder than 0.3 press right key
            
    if(sequence[cursor]==1){
      robot.keyPress(KeyEvent.VK_RIGHT);
      robot.keyRelease(KeyEvent.VK_RIGHT);
     
          cursor ++;
    }else{
      robot.keyPress(KeyEvent.VK_LEFT);
      robot.keyRelease(KeyEvent.VK_LEFT);
      robot.keyPress(KeyEvent.VK_DOWN);
      robot.keyRelease(KeyEvent.VK_DOWN);
      
          cursor ++;
    }
    

    // prob not the right delay
    }
    
     println("noteDOWN!"); 
     noteUp = false;
    skipbeat ++;
  }
  
  
  if(amp.analyze()>0.3){
          noteUp = true;
    }
}

// bon reste à trouver une solution pour qu'on puisse revenir en arrière... mmeh
// tet le plus simple c'est d'écouter sur la channel des sons pour un son au pitch particulier ou quoi
// m'enfin ça serait mieux si c'était automatique

// bon et tout bien considéré il vaudrait mieux sans doute que je fasse un 
// démon (python, bash).. euh en fait c'est pas dit que ça rende les choses
// plus simples

// ou alors ouais c'est ça c'est un démon qui tourne
// et l'appli processing lui envoie des requetes (signal qui tombe dans un trap)
// et a chaque fois il envoie le path de l'objet selectioné dans le finder. hmm
