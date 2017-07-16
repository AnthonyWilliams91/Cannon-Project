class Projectile {
  private boolean projectileFired = false;
  private PVector positionVector;
  private PVector velocityVector;
  private final PVector GRAVITY = new PVector(0, 0, -.27222222222);//DO NOT CHANGE THIS! REMEMBER SECONDS SQUARED
  private Cannon cannon;
  private Barrel barrel;
  private float radius;
  private float posX, posY, posZ;
  private float projectileInitialHeight;
  int colorR = 70;
  int colorG = 102;
  int colorB = 255;


  public Projectile(Cannon cannon) {
    this.cannon = cannon;
    this.barrel = cannon.getBarrel();
    this.radius = barrel.getRadius();
    this.projectileInitialHeight = cannon.getBase().getHeight();
  }

  public void fire() {
    positionVector = new PVector(cos(radians(cannon.getHorizontalAngle())) * Math.abs(cos(radians(barrel.getVerticalAngle()))), sin(radians(cannon.getHorizontalAngle())) * cos(radians(barrel.getVerticalAngle())), sin(radians(barrel.getVerticalAngle())));
    positionVector.normalize();
    velocityVector = new PVector(positionVector.x, positionVector.y, positionVector.z);
    velocityVector.mult((float)cannon.getVelocity_cmPerFrame());
    projectileFired = true;
  }

  public void updateProjectile() {
    if (projectileFired) {
      if (positionVector.z > -projectileInitialHeight) {
        positionVector.add(velocityVector);
        velocityVector.add(GRAVITY);
      }
      if (positionVector.z < -projectileInitialHeight) {
        accountForLandingBelowGround();
        //velocityVector.z *= -.9;
      }
    }
  }

  private void accountForLandingBelowGround() {
    velocityVector.mult(-.1); 
    while (positionVector.z < -projectileInitialHeight) {
      positionVector.add(velocityVector);
      println(positionVector.z);
    }
    positionVector.z = -projectileInitialHeight;
  }

  public void drawProjectile() {
    int currentFill = g.fillColor;
    fill(colorR, colorG, colorB);
    posX = positionVector.x;
    posY = positionVector.y;
    posZ = cannon.getBase().getHeight() + radius + positionVector.z;
    pushMatrix();
    translate(posX, posY, posZ);
    sphere(radius);
    popMatrix();
    fill(currentFill);
  }

  public void setRadius(float radius) {
    if (radius <= 0) throw new IllegalArgumentException();
    this.radius = radius;
  }

  public float getRadius() {
    return radius;
  }

  public boolean isFired() {
    return projectileFired;
  }

  public void setBarrel(Barrel barrel) {
    if (barrel == null) throw new NullPointerException();
    this.barrel =  barrel;
  }

  public float getPosX() {
    return posX;
  }

  public float getPosY() {
    return posY;
  }

  public float getPosZ() {
    return posZ;
  }

  public void setColor(int colorR, int colorG, int colorB) {
    if (colorR > 255 || colorR < 0 || colorG > 255 || colorG < 0 || colorB > 255 || colorB < 0) throw new IllegalArgumentException();
    this.colorR = colorR;
    this.colorG = colorG;
    this.colorB = colorB;
  }
}