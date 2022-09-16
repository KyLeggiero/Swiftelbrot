package com.unitedhuskies.mandelbrot;

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

import javax.swing.JFrame;

public class Main extends JFrame{
	Main(String title){
		super(title);
		final Canvas c = new Canvas(1920, 1080);
        setSize(1920, 1080);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(3);
        setLayout(new BorderLayout());
        add(c, "Center");
        addComponentListener(new ComponentAdapter() 
        {  
                public void componentResized(ComponentEvent evt) {
                	c.updateOffset();
                    c.updateWidth();
                    c.updateHeight();
                }
        });
        setMinimumSize(new Dimension(800, 600));
        setVisible(true);
        
	}
	
	
	
	public static void main(String[] args) {
		 JFrame window = new Main("Mandelbrot Set");
	}
}
