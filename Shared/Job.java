package com.unitedhuskies.mandelbrot;

public class Job {
	private int width = 0;
	private int height = 0;
	private int start_x = 0;
	private int start_y = 0;
	private int job_num = 0;
	
	Job(int width, int height, int start_x, int start_y){
		this.width = width;
		this.height = height;
		this.start_x = start_x;
		this.start_y = start_y;
		job_num++;
	}
	
	Job(int[] bounds){
		if(bounds.length == 5){
			this.width = bounds[0];
			this.height = bounds[1];
			this.start_x = bounds[2];
			this.start_y = bounds[3];
			job_num = bounds[4];
			job_num++;
		}
	}
	
	public int getWidth() {
		return this.width;
	}
	
	public int getHeight() {
		return this.height;
	}
	
	public int getX() {
		return this.start_x;
	}
	
	public int getY() {
		return this.start_y;
	}
	
	public int getJob() {
		return job_num;
	}
}
