package com.unitedhuskies.mandelbrot;

import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.LinkedBlockingQueue;


public class Canvas extends Component implements KeyListener
{
    double SCALE;
    double LENGTH;
    double HEIGHT;
    double SCALE_FACTOR;
    double START_XOFFSET = -840;
    double START_YOFFSET = 240;
    double XOFFSET;
    double YOFFSET;
    int ITTERATIONS;
    int JOB_ROWS = 2;
    int JOB_COLS = 8;
    int THREAD_COUNT = 8;
    boolean SHOW_CROSSHAIR = true;
    int pictureNumber = 0;
    
    Canvas(int w, int h){
    	this.LENGTH = w;
    	this.HEIGHT = h;
        this.SCALE = 0.0025;
        this.XOFFSET = -840;
        this.YOFFSET = 240; 
        this.ITTERATIONS = 500;
        this.addKeyListener(this);
        this.setFocusable(true);
        this.requestFocusInWindow();
        this.SCALE_FACTOR = .9;
    }
    
	static class Answer {
		public int x;
		public int y;
		public BufferedImage img;
	}

	@Override
    public void paint(final Graphics g) {
		
    	ConcurrentLinkedQueue<Job> jobList = new ConcurrentLinkedQueue<>();
    	LinkedBlockingQueue<Answer> pixels = new LinkedBlockingQueue<>();
    	final Graphics2D g2d = (Graphics2D)g;
    	int jobnum = 0;
    	for(int i = 0; i < JOB_ROWS; i++) {
    		for(int j = 0; j < JOB_COLS; j++) {
    			int jobWidth;
    			int jobHeight;
    			int job_x;
    			jobWidth = (int) (Math.ceil(this.LENGTH / JOB_COLS));
    			if(i == JOB_ROWS - 1) jobHeight = (int) (Math.floor(this.HEIGHT / JOB_ROWS) + this.HEIGHT % JOB_ROWS);
    			else jobHeight = (int) Math.ceil(this.HEIGHT / JOB_ROWS);
    			job_x = (int) Math.floor(j * (this.LENGTH / JOB_COLS));
    			int job_y = i * ((int) Math.ceil(this.HEIGHT / JOB_ROWS));
    			Job currentJob = new Job(new int[] {jobWidth, jobHeight, job_x, job_y, jobnum});
    			jobnum++;
    			jobList.add(currentJob);
    		}
    	}
    	
    	class JobsLeft {
    		public boolean hasJob = true;
    	}
    	JobsLeft jobsLeft = new JobsLeft();
    	
    	class ComputeMandelbrot implements Runnable{
			@Override
    		public void run(){
    
    			while(jobsLeft.hasJob) {
    				
					
					
					Job	job = jobList.poll();
					
    				if(job == null) {
    					jobsLeft.hasJob = false;
    					break;
    				}
    				int width = job.getWidth();
    				int height = job.getHeight();
    				int x = job.getX();
    				int y = job.getY();
					Answer answer = new Answer();
					answer.x = x;
					answer.y = y;
					answer.img = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
    				
    				int frameX = 0;
    		        int frameY = 0;
    		        int colorR = 255;
    		        int colorG = 0;
    		        int colorB = 0;
    		        for (int i = (int)Math.ceil(height * 0.5); i > Math.ceil((-height * 0.5)); --i) {//y
    		            for (int j = (int)Math.ceil(-(width * 0.5)); j < Math.ceil(width * 0.5); ++j) {//x
    		            	double real = (j + XOFFSET + x) * SCALE;
    		            	double coefficient = (i + YOFFSET - y) * SCALE;
    		            	double secondReal = 0;
    		            	double secondCoefficient = 0;
    		            	double tr = Math.pow(secondReal, 2) - Math.pow(secondCoefficient, 2);
    		            	secondCoefficient= (2 * secondReal * secondCoefficient) + coefficient;
    		            	secondReal = real + tr;

    		                for (int z = 0; z < ITTERATIONS; ++z) {
    		                	tr = Math.pow(secondReal, 2) - Math.pow(secondCoefficient, 2);
        		            	secondCoefficient = 2 * secondReal * secondCoefficient;
        		            	secondReal = real + tr;
        		            	secondCoefficient = secondCoefficient + coefficient;
        		            	if(Math.abs(secondReal) > 2.0 && Math.abs(secondCoefficient) > 2.0) {
        		            		int color = 0;
        		            		if(z > ITTERATIONS / 2) {
        		            			color = rangeConversion(z, 500, ITTERATIONS, 50, 80);
        		            			
        		            		}else if(z <= ITTERATIONS / 2 && z > ITTERATIONS / 3){
        		            			color = rangeConversion(z, ITTERATIONS / 3, ITTERATIONS / 2, 80, 110);
        		            		}else if(z <= ITTERATIONS / 3 && z > ITTERATIONS / 4){
        		            			color = rangeConversion(z, ITTERATIONS / 4, ITTERATIONS / 3, 110, 140);
        		            		}else if(z <= ITTERATIONS / 4 && z > ITTERATIONS / 5){
        		            			color = rangeConversion(z * 4, ITTERATIONS / 5, ITTERATIONS / 4, 140, 170);
        		            		}else if(z <= ITTERATIONS / 5 && z > ITTERATIONS / 6){
        		            			color = rangeConversion(z * 5, ITTERATIONS / 6, ITTERATIONS / 5, 170, 200);
        		            		}else if(z <= ITTERATIONS /6 && z >= 20){
        		            			color = rangeConversion(z * 6, 50, ITTERATIONS / 6, 200, 230);
        		            		}else if(z <= 50) {
        		            			color = rangeConversion(z * 6, 0, 125, 180, 255);
        		            		}
        		            		
        		            		colorR = color;
        		            		colorG = (int) (color *.55);
        		            		colorB = 0;
        		            		
        		            		break;
        		            	}
    		                    
    		                }
    		                
    		                if(Math.abs(secondReal) < 2.0 && Math.abs(secondCoefficient) < 2.0) {
    		                	colorR = 0;
    		                	colorG = 0;
    		                	colorB = 0;
    		                }
    		                
    		                answer.img.setRGB(frameX, frameY, (colorR << 16) | (colorG << 8) | colorB);
    		                ++frameX;
    		            }
    		            ++frameY;
    		            frameX = 0;
    		        }
    		        pixels.add(answer);
    			}
    			Thread.currentThread().interrupt();
    		}
    		
    	}
    	
    	ComputeMandelbrot cm1 = new ComputeMandelbrot();
    	Thread th1 = new Thread(cm1);
    	Thread th2 = new Thread(cm1);
    	Thread th3 = new Thread(cm1);
    	Thread th4 = new Thread(cm1);
    	Thread th5 = new Thread(cm1);
    	Thread th6 = new Thread(cm1);
    	Thread th7 = new Thread(cm1);
    	Thread th8 = new Thread(cm1);
    	th1.start();
    	th2.start();
    	th3.start();  
    	th4.start();
    	th5.start();
    	th6.start();
    	th7.start();
    	th8.start();
    		
    	int count = 0;
    	while(count < 16) {
    		try {
				Answer x = pixels.take();
				g2d.drawImage(x.img, null, x.x, x.y);
				
				
				count++;
			} catch (InterruptedException e) {
				e.printStackTrace();
			}
    	}
    	if(this.SHOW_CROSSHAIR) {
	    	g2d.setColor(new Color(255, 255, 255));
	    	g2d.fillRect(this.getWidth() / 2 - 1, this.getHeight() / 2 - 10, 2, 20);
	    	g2d.fillRect(this.getWidth() / 2 - 10, this.getHeight() / 2 - 1, 20, 2);
    	}
    	
    }
    
	public static double[] mFunction(double fr, double fc, double sr, double sc){
   	  		double tr = Math.pow(fr, 2) - Math.pow(fc, 2);
   	  	 	fc = 2.0 * fr * fc;
   	       return new double[] {tr + sr, fc + sc};
   	}
	
	public static int rangeConversion(int x,int previousRangeLowerBound, int previousRangeMax, int newRangeLowerBound, int newRangeUpperBound) {
		double ratio = (double)(previousRangeMax - (x + previousRangeLowerBound)) / (double) previousRangeMax;
		return (int)((newRangeUpperBound - newRangeLowerBound) * ratio + newRangeLowerBound);
	}
    
    @Override
    public void keyTyped(final KeyEvent e) {
    }
    
    @Override
    public void keyPressed(final KeyEvent e) {
        if (e.getKeyChar() == 'i') {
            this.SCALE *= this.SCALE_FACTOR;
            if (this.XOFFSET < this.START_XOFFSET) {
            	this.XOFFSET =  (this.START_XOFFSET - (Math.abs(this.XOFFSET) - Math.abs(this.START_XOFFSET)) * (1/this.SCALE_FACTOR));
            }
            if (this.XOFFSET > this.START_XOFFSET) {
            	this.XOFFSET =  (this.START_XOFFSET + Math.abs(Math.abs(this.START_XOFFSET) + this.XOFFSET) * (1/this.SCALE_FACTOR));
            }
            if (this.YOFFSET < this.START_YOFFSET) {
                this.YOFFSET =  (this.START_YOFFSET - Math.abs(this.YOFFSET - this.START_YOFFSET) * (1/this.SCALE_FACTOR));
            }
            if (this.YOFFSET > this.START_YOFFSET) {
            	this.YOFFSET =  (this.START_YOFFSET + Math.abs(this.YOFFSET - this.START_YOFFSET) * (1/this.SCALE_FACTOR));
            }
        }
        if (e.getKeyChar() == 'o') {
            this.SCALE /= this.SCALE_FACTOR;
            if (this.XOFFSET < this.START_XOFFSET) {
            	this.XOFFSET =  (this.START_XOFFSET - (Math.abs(this.XOFFSET) - Math.abs(this.START_XOFFSET)) * this.SCALE_FACTOR);
            }
            if (this.XOFFSET > this.START_XOFFSET) {
            	this.XOFFSET =  (this.START_XOFFSET + Math.abs(Math.abs(this.START_XOFFSET) + this.XOFFSET) * this.SCALE_FACTOR);
            }
            if (this.YOFFSET < this.START_YOFFSET) {
                this.YOFFSET =  (this.START_YOFFSET - Math.abs(this.YOFFSET - this.START_YOFFSET) * this.SCALE_FACTOR);
            }
            if (this.YOFFSET > this.START_YOFFSET) {
            	this.YOFFSET =  (this.START_YOFFSET + Math.abs(this.YOFFSET - this.START_YOFFSET) * this.SCALE_FACTOR);
            }
        }
        
        if(e.getKeyChar() == 'c') {
        	if(this.SHOW_CROSSHAIR) {
        		this.SHOW_CROSSHAIR = false;
        	}else {
        		this.SHOW_CROSSHAIR = true;
        	}
        }
        
        switch (e.getKeyCode()) {
            case KeyEvent.VK_LEFT: {
                this.XOFFSET -= 50;
                break;
            }
            case KeyEvent.VK_RIGHT: {
                this.XOFFSET += 50;
                break;
            }
            case KeyEvent.VK_DOWN: {
                this.YOFFSET -= 50;
                break;
            }
            case KeyEvent.VK_UP: {
                this.YOFFSET += 50;
                break;
            }
        }
    }
    
    public void updateHeight() {
    	this.HEIGHT = this.getHeight();
    }
    
    public void updateWidth() {
    	this.LENGTH = this.getWidth();
    }
    
    public void updateOffset() {
    	this.XOFFSET -= ((this.getWidth() - LENGTH) / 2.5);
    	this.START_XOFFSET -= ((this.getWidth() - LENGTH) / 2);
    	this.YOFFSET += ((this.getHeight() - HEIGHT) / 4);
    	this.START_YOFFSET += ((this.getHeight() - HEIGHT) / 4);
    }

	@Override
	public void keyReleased(KeyEvent e) {
		repaint();
	}
    
}