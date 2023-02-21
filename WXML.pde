import processing.pdf.*;

Table table;

void setup() {

  table = loadTable("planet_data.csv", "header");
  // size(1000, 1000, PDF, "jupiter_stereo.pdf"); // save as PDF
  size(1000, 1000);
  background(51);
  stroke(255);  
  
  drawGridStereo();
  
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

  index = 0;
  for (TableRow row : table.rows()) {
   float alt = row.getFloat("altitude");
   float az = row.getFloat("azimuth"); 
     
   /* for plotting ecliptic longtitude vs distance
   
   float d = row.getFloat("ecd") / 10.0;
   float eclon = ec_lons[index];
   double x = d * Math.sin(eclon);
   double y = d * Math.cos(eclon);
   */
   
   // https://astronomy.stackexchange.com/questions/35882/how-to-make-projection-from-altitude-and-azimuth-to-screen-with-screen-coordinat
   double x = sin(az) * cos(alt);
   double y = cos(az) * cos(alt);
   double z = sin(alt);
   
   x /= (z+1);
   y /= (z+1);
   
   int _size = 100;
   x = _size * (1-x) + width / 2 - _size;
   y = _size * (1-y) + height/ 2 - _size;
   
   color col = color(255);
   //if (index > 1 && ec_lons[index - 1] > ec_lons[index]) { // retrograde in red
   // col = color(255, 0, 0); 
   //}
   
   if (alt < 0) {
     col = color(255, 255, 0);
   }
   
   
   
   fill(col);
   stroke(col);
   circle((int)(x), (int)(y), .5);
   index++;
  }
}

void drawGridStereo() {
   textAlign(CENTER);
   noFill();
   stroke(70);
   for (int r = 0; r < 1500; r += 175) {
     circle(width/2, height/2, r);
   }
   
   // draw horizon
   float alt = 0;
   for (float az = 0; az < 360; az +=1) {
     double x = sin(az) * cos(alt);
     double y = cos(az) * cos(alt);
     double z = sin(alt);
     
     x /= (z+1);
     y /= (z+1);
     
     int _size = 100;
     x = _size * (1-x) + width / 2 - _size;
     y = _size * (1-y) + height/ 2 - _size;
     
     color col = color(255, 0, 255);   
     fill(col);
     stroke(col);
     circle((int)(x), (int)(y), 1);
   }
   textSize(20);
   text("Horizon", width / 2, height / 2 + 125);
   fill(255, 255, 0);
   text("Below the Horizon", width / 2, height / 4 - 150);
   fill(255);

  textSize(40);
  text("Jupiter Motion", width/2, height - 250);
  
  textSize(20);
  text("One Jupiter Year, approx. 12 Earth years -- plotting steroegraphic coordinate system", width/2, height - 150);
  
}

void drawGridAltAz() {
  
  stroke(70);
  for (int i = 900; i > 0; i -= 100) {
    line(0, i, width, i);
  }
  
  for (int i = 100; i < height; i += 100) {
    line(i, 0, i, height);
  }
  
  textAlign(CENTER);
  
  fill(255);
  textSize(40);
  text("Jupiter Motion", width/2, 50);
  
  textSize(20);
  text("One Jupiter Year, approx. 12 Earth years -- plotting x=azimuth, y=altitude", width/2, 100);
  
  textSize(15);
  text("Prograde", 600, 550);
  fill(255, 0, 0);
  text("Retrograde", 300, 700);
  fill(255);
    
  line(100, 0, 100, height);
  line(0, 900, width, 900);
  
  stroke(150);
  line(100, 0, 100, height);
  line(0, 900, width, 900);
  
  textSize(25);
  text("Azimuth (0 - 360 degrees)", width/2, 950);
  
  pushMatrix();
  translate(50, height/4);
  rotate(3*PI/2);
  text("Altitude (0 - 90 degrees)", 0, 0);
  popMatrix();
}

void drawGridEcLon() {
  
  fill(255);
  textSize(40);
  text("Jupiter Retrograde Motion", 250, 50);
  
  textSize(20);
  text("One Jupiter Year, approx. 12 Earth years", 300, 130);
  
  textSize(20);
  text("Ecliptic Longitude vs Distance", 350, 90);
  
  textSize(12);
  text("Earth", width/2 + 10, height/2 - 10);
  
  text("Prograde", 750, 350);
  fill(255, 0, 0);
  text("Retrograde", 625, 450);
  
  fill(150);
  stroke(color(100, 100, 100));
  line(0, height/2, width, height/2);
  line(width/2, 0, width/2, height);
  
  fill(0, 0, 255);
  circle(width/2, height/2, 20);
  
}
