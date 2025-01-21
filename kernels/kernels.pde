PImage img;
PImage buffer;
boolean pressedKey;
int currentKey;
boolean hasntPressed = true;
float filter;

// Initialize kernels

float gaussianKernel[][] = {{0.0625, 0.125, 0.0625}, 
                            {0.125, 0.25, 0.125},
                            {0.0625, 0.125, 0.0625}};

float[][] verticalKernel = {{-1, 0, 1}, 
                            {-2, 0, 2},
                            {-1, 0, 1}};
                                          
float[][] horizontalKernel = {{-1/9.0, -2/9.0, -1/9.0}, 
                              {0, 0, 0},
                              {1/9.0, 2/9.0, 1/9.0}};
                            
void setup() {
  surface.setResizable(true);
  img = loadImage("basketball.jpg");
  buffer = loadImage("basketball.jpg");
  surface.setSize(img.width, img.height);
}

void keyPressed() {
  pressedKey = true;
  if (key == '0'){
    currentKey = 0;
  }
  else if (key == '1'){
    currentKey = 1;
  }
  else if (key == '2'){
    currentKey = 2;
  }
  else if (key == '3'){
    currentKey = 3;
  }
  else if (key == '4'){
    currentKey = 4;
  }
}

// CODE ATTRIBUTION
/* Code for traversing pixels and applying kernel to images is 
   derived from the following Processing page about creating a 
   Blur Kernel: https://processing.org/examples/blur.html */

void filter() {
  buffer.loadPixels();
  // Loop through every pixel in the image
  for (int y = 0; y < img.height; y++) {   
    for (int x = 0; x < img.width; x++) {  
      float sumRed = 0;   
      float sumGreen = 0;
      float sumBlue = 0;
      float redVert = 0;
      float greenVert = 0;
      float blueVert = 0;
      float redHoriz = 0;
      float greenHoriz = 0;
      float blueHoriz = 0;
      
      // Grayscale filter
      if (currentKey == 1) {
        int pos = y * img.width + x;

        // Process each color channel
        float valRed = red(img.pixels[pos]);
        float valGreen = green(img.pixels[pos]);
        float valBlue = blue(img.pixels[pos]);  
        
        float grayscale = (valRed + valGreen + valBlue) / 3;
        
        // Apply grayscale filter
        buffer.pixels[pos] = color(grayscale, grayscale, grayscale);
      }
      // Contrast filter
      else if (currentKey == 2) {
        int pos = y * img.width + x;

        // Process each color channel
        float valRed = red(img.pixels[pos]);
        float valGreen = green(img.pixels[pos]);
        float valBlue = blue(img.pixels[pos]);  
        
        if (valRed > 70) {
          valRed += 20;
        } else if (valRed < 70) {
          valRed -= 70;
        } else if (valGreen > 100) {
          valRed += 70;
        }
        else if (valGreen < 70) {
          valGreen -= 70;
        }
        else if (valBlue > 100) {
          valBlue += 70;
        }
        else if (valBlue < 70) {
          valBlue -= 70;     
        }
        
        buffer.pixels[pos] = color(constrain(valRed, 0, 255), constrain(valGreen, 0, 255), constrain(valBlue, 0, 255));
      }
      // Kernel is applied
      else 
      {
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {

          // Add constrains to y and x positions to ensure we stay in bounds
          int yPos = constrain(y + ky, 0, img.height - 1);
          int xPos = constrain(x + kx, 0, img.width - 1);
          
          int pos = (yPos)*img.width + (xPos);

          // Process each color channel
          float valRed = red(img.pixels[pos]);
          float valGreen = green(img.pixels[pos]);
          float valBlue = blue(img.pixels[pos]);

          // Gaussian Blur filter
          if (currentKey == 3) {
            sumRed += gaussianKernel[ky+1][kx+1] * valRed;
            sumGreen += gaussianKernel[ky+1][kx+1] * valGreen;
            sumBlue += gaussianKernel[ky+1][kx+1] * valBlue;         
          }
          // Edge Detection filter
          else if (currentKey == 4) {
            // Vertical sum
            redVert += verticalKernel[ky+1][kx+1] * valRed;
            greenVert += verticalKernel[ky+1][kx+1] * valGreen;
            blueVert += verticalKernel[ky+1][kx+1] * valBlue;          
            
            // Horizontal sum
            redHoriz += horizontalKernel[ky+1][kx+1] * valRed;
            greenHoriz += horizontalKernel[ky+1][kx+1] * valGreen;
            blueHoriz += horizontalKernel[ky+1][kx+1] * valBlue;       
            
            sumRed = sqrt(sq(redVert) + sq(redHoriz));
            sumGreen = sqrt(sq(greenVert) + sq(greenHoriz));
            sumBlue = sqrt(sq(blueVert) + sq(blueHoriz));            
          }
        }  
      }
      }
      // Set pixel's new output value
      if (currentKey != 1 && currentKey != 2) {
        buffer.pixels[y*buffer.width + x] = color(constrain(sumRed, 0, 255), constrain(sumGreen, 0, 255), constrain(sumBlue, 0, 255));
      } 
    }
  }
  // Update changes to buffer image
  buffer.updatePixels();
} 

void draw() {
  if (pressedKey){
    hasntPressed = false;
    pressedKey = false;
    if (currentKey == 0){
      image(img, 0, 0);
    }
    // Grayscale filter
    else if (currentKey == 1){
      filter();
      image(buffer, 0, 0);
    }
    // Contrast filter
    else if (currentKey == 2){
      filter();                        
      image(buffer, 0, 0);
    }
    // Gaussian Blur filter
    else if (currentKey == 3){
      filter();                        
      image(buffer, 0, 0);
    }
    // Edge Detection filter
    else if (currentKey == 4){
      filter();
      image(buffer, 0, 0);
    }
  } else if (hasntPressed){
      image(img, 0, 0);
  }
}
