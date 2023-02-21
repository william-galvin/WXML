import processing.pdf.*;

Table table;

void setup() {
  
  size(1000, 1000, PDF, "planets_stereo.pdf"); // save as PDF
  // size(1000, 1000);
  background(51);
  stroke(255);  
  
  drawGridStereo();
  
  String[] planets = {"mercury", "venus", "mars", "jupiter", "saturn", "uranus", "neptune", "pluto"};
  color[] colors = {color(255, 50, 60), color(244, 46, 255), color(46, 79, 255), color(46, 246, 255), color(15, 209, 26),
                    color(246, 250, 40), color(250, 156, 40), color(255, 255, 255)};

  for (int i = 0; i < planets.length; i++) {
   String planet = planets[i];
   color col = colors[i];
   
   fill(col);
   textSize(20);
   text(planet.toUpperCase(), 150, 50 + 50*(i + 1));
   
   table = loadTable(planet+"_data.csv", "header");
  
    // Useful for plotting retrograde --
    // Not done here
    float[] ec_lons = new float[table.getRowCount()];
    int index = 0;
    for (TableRow row : table.rows()) {
      float eclon = row.getFloat("eclon");
      ec_lons[index] = eclon;
          
      if (index > 1 && ec_lons[index - 1] > eclon) {
        println("retrograde!\t" + ec_lons[index - 1] +"\t" + eclon);
      }
      
      index++;
    }
  
    for (TableRow row : table.rows()) {
     float alt = row.getFloat("altitude");
     float az = row.getFloat("azimuth"); 
     
     // https://astronomy.stackexchange.com/questions/35882/how-to-make-projection-from-altitude-and-azimuth-to-screen-with-screen-coordinat
     double x = sin(az) * cos(alt);
     double y = cos(az) * cos(alt);
     double z = sin(alt);
     
     x /= (z+1);
     y /= (z+1);
     
     int _size = 125;
     x = _size * (1-x) + width / 2;
     y = _size * (1-y) + height/ 2;
     
     fill(col);
     stroke(col);
     circle((int)(x), (int)(y), .5);
    }
  }
}

void drawGridStereo() {
   textAlign(CENTER);
   
   // Draw radial grid lines
   //noFill();
   //stroke(70);
   //for (int r = 0; r < 1500; r += 175) {
   //  circle(width/2, height/2, r);
   //}
   
   // draw horizon
   float alt = 0;
   for (float az = 0; az < 360; az +=1) {
     double x = sin(az) * cos(alt);
     double y = cos(az) * cos(alt);
     double z = sin(alt);
     
     x /= (z+1);
     y /= (z+1);
     
     int _size = 125;
     x = _size * (1-x) + width / 2;
     y = _size * (1-y) + height/ 2;
     
     color col = color(150, 150, 150);   
     fill(col);
     stroke(col);
     circle((int)(x), (int)(y), 4);
   }
   textSize(20);
   text("Horizon", width / 2 + 125, height / 2 + 275);
   fill(255);

  textSize(40);
  text("Planetary Motion Viewed from Seattle", width/2, height - 150);
  
  textSize(20);
  text("One Earth Year -- plotting steroegraphic coordinate system", width/2, height - 75);
  
}
