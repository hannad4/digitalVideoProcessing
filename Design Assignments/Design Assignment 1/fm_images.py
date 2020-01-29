import cv2
import numpy as np

PIC_WID  = 640     # Standard high-definition picture width
PIC_HGT  = 360     # Standard high-definition picture height
N_FRAMES =  10      # Three seconds, at 30 fps

MAX_RAD = np.sqrt((PIC_WID/2)**2.0 + (PIC_HGT/2)**2.0);

picture = np.zeros( (PIC_HGT,PIC_WID,3) );

for t in range(N_FRAMES):                                               # t will be frame index
    for y in range( PIC_HGT ):                                          # y is image matrix row index
        for x in range ( PIC_WID ):                                     # x is image matrix column index
            
            r = np.sqrt((x-PIC_WID/2)**2.0 + (y-PIC_HGT/2)**2.0);       # r is the radius from the center of the image, maximum value is about 1100
            r = r * 5.0 * np.pi/MAX_RAD;                                # r scaled from 0 to 2pi
            r = np.exp(r);                                              # exp(r) is linear for relatively small values of r, but grows exponentially
                                                                        # by feeding this as argument to sin(), get increasing frequency

            val = 0.5 + 0.5*np.cos(t/5 + y/10) ** 2;                    # Creating vertical lines that move horizontally 

            picture[y,x,0] = val*4;                                       # defining the RGB values
            picture[y,y,1] = 2.0/(r**0.2);                                
            picture[y,x,2]  = 1.0 - val*4;         
                                   
    fn = 'out_%03d.bmp' % t 
    po = picture * 255                                                  # CV2 expects images to be scaled to range [0,255]
    po = po.astype(np.uint8)                                            # Convert from float64 to uint8
    po = cv2.cvtColor(po, cv2.COLOR_RGB2BGR)                            # default for OpenCV is BGR
    cv2.imwrite(fn, po);                                                # write out_ddd.bmp file, default for OpenCV is BGR
