import peasy.*;

float r = 500;

PeasyCam cam;

Point ohio = new Point(0, 0, 0);
Point florida = new Point(100, 100, 0);
Circle circle = new Circle(r, 0, PI / 2, 50);

void setup() {
  size(500, 500, P3D);

  cam = new PeasyCam(this, 100);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(2000);
}

void draw() {
  background(200);
  fill(255);
  ellipse(0, 0, 2 * r, 2 * r);
  noFill();
  sphere(r - 1);

  stroke(10);
  ohio.drawPoint();
  florida.drawPoint();
  
  circle.updateCartesian();
  circle.drawCircle();
  
  circle.distance(florida);
  circle.drawLine(florida);
  //println("Florida: " + circle.d);
  circle.distance(ohio);
  circle.drawLine(ohio);
  //println("Ohio: " + circle.d);
  circle.phi += 0.01;
}

class Point {
  float x, y, z;
  float ro, theta, phi;
  float hypotenuse, d;

  Point(float xPosition, float yPosition, float zPosition) {
    x = xPosition;
    y = yPosition;
    z = zPosition;

    hypotenuse = pow(x, 2) + pow(y, 2);
    ro = pow(hypotenuse + pow(z, 2), .5);
    theta = atan(y / x);
    phi = atan(pow(hypotenuse, .5) / z);
    d = 0;
  }

  void updateCartesian() {
    x = ro * sin(phi) * cos(theta);
    y = ro * sin(phi) * sin(theta);
    z = ro * cos(phi);
  }

  void updateSpherical() {
    hypotenuse = pow(x, 2) + pow(y, 2);
    ro = pow(hypotenuse + pow(z, 2), .5);

    if (x == 0) {
      theta = PI / 2;
    } else {
      theta = atan(y / x);
    }

    if (z == 0) {
      phi = PI / 2;
    } else {
      phi = atan(pow(hypotenuse, .5) / z);
    }
  }


  void distance(Point p) {
    d = dist(p.x, p.y, p.z, this.x, this.y, this.z);
  }

  void drawLine(Point p) {
    line(x, y, z, p.x, p.y, p.z);
  }

  void drawPoint() {
    strokeWeight(10);
    point(x, y, z);
  }
}

class Circle {
  float ro, theta, phi;
  float x, y, z;
  float d;
  float r;

  Circle(float ro1, float theta1, float phi1, float radius) {
    ro = ro1;
    theta = theta1;
    phi = phi1;
    r = radius;
    d = 0;
    
    x = ro * sin(phi) * cos(theta);
    y = ro * sin(phi) * sin(theta);
    z = ro * cos(phi);
  }
  
  void updateCartesian() {
    x = ro * sin(phi) * cos(theta);
    y = ro * sin(phi) * sin(theta);
    z = ro * cos(phi);
  }

  void distance(Point p) {
    float phi2;
    
    if (phi > 0) {
      phi2 = phi - r / ro;
    } else {
      phi2 = phi + r / ro;
    }
    
    float theta2 = atan((p.y - y) / (p.x - x));
    
    float x1 = ro * sin(phi2) * cos(theta2);
    float y1 = ro * sin(phi2) * sin(theta2);
    float z1 = ro * cos(phi2);
    
    if (((p.x < x + r && p.x > x - r) && (p.y < y + r && p.y > y - r)) || (p.z < z + r && p.z > z - r)) {
      d = dist(x, y, z, p.x, p.y, p.z);
    } else {
      d = dist(x1, y1, z1, p.x, p.y, p.z);
    }
  }

  void drawLine(Point p) {
    strokeWeight(1);
    float phi2;
    
    if (phi > 0) {
      phi2 = phi - r / ro;
    } else {
      phi2 = phi + r / ro;
    }
    
    float theta2 = atan((p.y - y) / (p.x - x));
    
    float x1 = ro * sin(phi2) * cos(theta2);
    float y1 = ro * sin(phi2) * sin(theta2);
    float z1 = ro * cos(phi2);
    if (((p.x < x + r && p.x > x - r) && (p.y < y + r && p.y > y - r)) || (p.z < z + r && p.z > z - r)) {
      line(x, y, z, p.x, p.y, p.z);
    } else {
      line(x1, y1, z1, p.x, p.y, p.z);
    }
  }
  
  void drawCircle() {
    noFill();
    strokeWeight(10);
    
    beginShape();
    
    float theta0 = theta - r / ro;
    float x1 = ro * sin(phi) * cos(theta0);
    float y1 = ro * sin(phi) * sin(theta0);
    float z1 = ro * cos(phi);
    vertex(x1, y1, z1);
    float phi0 = phi - r / ro;
    x1 = ro * sin(phi0) * cos(theta);
    y1 = ro * sin(phi0) * sin(theta);
    z1 = ro * cos(phi0);
    vertex(x1, y1, z1);
    theta0 = theta + r/ ro;
    x1 = ro * sin(phi) * cos(theta0);
    y1 = ro * sin(phi) * sin(theta0);
    z1 = ro * cos(phi);
    vertex(x1, y1, z1);
    phi0 = phi + r / ro;
    x1 = ro * sin(phi0) * cos(theta);
    y1 = ro * sin(phi0) * sin(theta);
    z1 = ro * cos(phi0);
    vertex(x1, y1, z1);
    
    endShape(CLOSE);
  }
}
