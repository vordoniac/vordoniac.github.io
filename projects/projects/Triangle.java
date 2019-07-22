import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;

public class Triangle
{
	public static void main( String args[] )
	{
		double[][] tr = new double[][]{{-1,-4 ,0 },{-3, 0,0 },{3,0 ,0 }};
		String s = "";
		ArrayList<double[][]> il = irregToIso(tr);
		for(int i = 0; i<il.size(); i++)
		{
			s += "{";
			for(int k = 0; k<3; k++)
			{
				s += Arrays.toString(il.get(i)[k]);
			}
			s += "}\n";
		}
		System.out.println(s);
	}
	
	public static ArrayList<double[][]> irregToIso(double[][] t)
	{
		ArrayList<double[][]> iso = new ArrayList<double[][]>();
		if(isIso(t))
		{
			iso.add(t);
			return iso;	
		}
		double[] intrsct = new double[3];
		intrsct[0] = 0;
		double[] oppToBase = t[0];
		double[][] base = new double[][]{t[1],t[2]};
		double s = ((distance(t[0], t[1]) + distance(t[1], t[2]) + distance(t[2], t[0]))/2);
		double area = Math.sqrt(  s*(s-distance(t[0], t[1]))*(s-distance(t[1], t[2]))*(s-distance(t[2], t[0]))  );
		double altitude = 2*(area/distance(base[0], base[1]));
		if(!isRight(t)[3])
		{
			if(isObtuse(t)[3])
			{
				if(isObtuse(t)[0])
				{
					oppToBase = t[0];
					base = new double[][]{t[1],t[2]};
				}
				else if(isObtuse(t)[1])
				{
					oppToBase = t[1];
					base = new double[][]{t[0],t[2]};
				}
				else if(isObtuse(t)[2])
				{
					oppToBase = t[2];
					base = new double[][]{t[0],t[1]};
				}
			}
			else
			{
				oppToBase = t[largestAngle(t)];
				if(largestAngle(t) == 0)
				{
					base = new double[][]{t[1],t[2]};
				}
				else if(largestAngle(t) == 1)
				{
					base = new double[][]{t[0],t[2]};
				}
				else if(largestAngle(t) == 2)
				{
					base = new double[][]{t[0],t[1]};
				}
			}
		}
		else
		{
			if(isRight(t)[0])
			{
				iso.add(new double[][]{t[1],t[0],meanP(t[1],t[2])});
				iso.add(new double[][]{t[2],t[0],meanP(t[1],t[2])});
			}
			else if(isRight(t)[1])
			{
				iso.add(new double[][]{t[0],t[1],meanP(t[0],t[2])});
				iso.add(new double[][]{t[2],t[1],meanP(t[0],t[2])});
			}
			else if(isRight(t)[2])
			{
				iso.add(new double[][]{t[1],t[2],meanP(t[1],t[0])});
				iso.add(new double[][]{t[0],t[2],meanP(t[1],t[0])});
			}
			return iso;
		}
		//System.out.println(Arrays.toString(normal(t)));
		intrsct = roundP(pAddition(pTimesNum(normalize(roundP(rot(normal(t),normalize(toVector(base[0],base[1])),Math.toRadians(-90)))),altitude),oppToBase));
		iso.add(new double[][]{base[0],intrsct,meanP(base[0],oppToBase)});
		iso.add(new double[][]{oppToBase,intrsct,meanP(base[0],oppToBase)});
		iso.add(new double[][]{oppToBase,intrsct,meanP(base[1],oppToBase)});
		iso.add(new double[][]{intrsct,meanP(base[1],oppToBase),base[1]});
		
		return iso;
	}
	
	public static boolean[] isObtuse(double[][] t)
	{
		boolean[] obtuse = new boolean[4]; //obtuse[3] is if it obtuse or not
		if(angleBetweenVectors(toVector(t[0],t[1]),toVector(t[0],t[2])) > Math.toRadians(90))
		{
			obtuse[3] = true;
			obtuse[0] = true;
		}
		if(angleBetweenVectors(toVector(t[1],t[0]),toVector(t[1],t[2])) > Math.toRadians(90))
		{
			obtuse[3] = true;
			obtuse[1] = true;
		}
		if(angleBetweenVectors(toVector(t[2],t[0]),toVector(t[2],t[1])) > Math.toRadians(90))
		{
			obtuse[3] = true;
			obtuse[2] = true;
		}
		return obtuse;
	}
	
	public static int largestAngle(double[][] t)
	{
		double largestV = angleBetweenVectors(toVector(t[0],t[1]),toVector(t[0],t[2]));
		int largest = 0;
		if(largestV < angleBetweenVectors(toVector(t[1],t[0]),toVector(t[1],t[2])))
		{
			largestV = angleBetweenVectors(toVector(t[1],t[0]),toVector(t[1],t[2]));
			largest = 1;
		}
		if(largestV < angleBetweenVectors(toVector(t[2],t[0]),toVector(t[2],t[1])))
		{
			largestV = angleBetweenVectors(toVector(t[2],t[0]),toVector(t[2],t[1]));
			largest = 2;
		}
		return largest;
	}
	
	public static boolean[] isRight(double[][] t)
	{
		boolean[] right = new boolean[4]; //right[3] is if it right or not
		if(angleBetweenVectors(toVector(t[0],t[1]),toVector(t[0],t[2])) == Math.toRadians(90))
		{
			right[3] = true;
			right[0] = true;
		}
		if(angleBetweenVectors(toVector(t[1],t[0]),toVector(t[1],t[2])) == Math.toRadians(90))
		{
			right[3] = true;
			right[1] = true;
		}
		if(angleBetweenVectors(toVector(t[2],t[0]),toVector(t[2],t[1])) == Math.toRadians(90))
		{
			right[3] = true;
			right[2] = true;
		}
		return right;
	}
	
	public static double angleBetweenVectors(double[] p1, double[] p2)
	{
		return Math.acos( (p1[0]*p2[0]+p1[1]*p2[1]+p1[2]*p2[2]) / (magnitude(p1))*(magnitude(p2)) );
	}
	
	public static boolean isIso(double[][] t)
	{
		if(magnitude(toVector(t[0],t[1])) == magnitude(toVector(t[0],t[2])))
		{
			return true;
		}
		if(magnitude(toVector(t[1],t[0])) == magnitude(toVector(t[1],t[2])))
		{
			return true;
		}
		if(magnitude(toVector(t[2],t[1])) == magnitude(toVector(t[2],t[0])))
		{
			return true;
		}
		return false;
	}
	
	public static double magnitude(double[] v)
	{
		return Math.sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
	}
	
	public static double[] toVector(double[] p1, double[] p2)
	{
		return new double[]{p2[0]-p1[0],p2[1]-p1[1],p2[2]-p1[2]};
	}
	
	public static double distance(double[] p1, double[] p2)
	{
		return magnitude(toVector(p1, p2));
	}
	
	public static double[] meanP(double[] p1, double[] p2)
	{
		return new double[]{(p1[0]+p2[0])/2,(p1[1]+p2[1])/2,(p1[2]+p2[2])/2};
	}
	
	public static double[] resultant(double[] v1, double[] v2)
	{
		return new double[]{v1[0]+v2[0], v1[1]+v2[1],v1[2]+v2[2]};
	}
	
	public static double[][] MatMultS(double[][] mat1, double[][] mat2) {
		
		if(mat1[0].length != mat2.length) { //Returns null if columns of first matrix != rows of second.
			return null;
		}
		
		double[][] matM = new double[mat1.length][mat2[0].length];
		double sum = 0;
		
		
		for(int o = 0; o<mat1.length; o++) { //Rows of mat1
			for(int k = 0; k<mat2[0].length; k++) { //Columns of mat2
				
				for(int n = 0; n<mat2.length; n++) {
					sum += mat1[o][n]*mat2[n][k];
				}
				matM[o][k] = sum;
				sum = 0;
			}
			
		}
		
		return matM;
	}
	
	public static double[] rot(double[] p, double[] v, double r)
	{
		
		double q0 = Math.cos(r/2),  q1 = Math.sin(r/2) * v[0],  q2 = Math.sin(r/2) * v[1],  q3 = Math.sin(r/2) * v[2];
		double[][] Q = new double[][]{{(q0*q0 + q1*q1 - q2*q2 - q3*q3), 2*(q1*q2 - q0*q3), 2*(q1*q3 + q0*q2)},
									  {2*(q2*q1 + q0*q3), (q0*q0 - q1*q1 + q2*q2 - q3*q3), 2*(q2*q3 - q0*q1)},
									  {2*(q3*q1 - q0*q2), 2*(q3*q2 + q0*q1), (q0*q0 - q1*q1 - q2*q2 + q3*q3)}};
		
		return MatMultS(new double[][]{p}, Q)[0];
	}
	
	public static double[] roundP(double[] p)
	{
		double[] newP = new double[3];
		newP[0] = Math.round(p[0]*Math.pow(10, 10))/Math.pow(10, 10);
		newP[1] = Math.round(p[1]*Math.pow(10, 10))/Math.pow(10, 10);
		newP[2] = Math.round(p[2]*Math.pow(10, 10))/Math.pow(10, 10);
		return newP;
	}
	
	public static double[] normalize(double[] v)
	{
		double m = magnitude(v);
		return new double[]{v[0]/m,v[1]/m,v[2]/m};
	}
	
	public static double[] crossProduct(double[] v1, double[] v2)
	{
		double[] p = new double[3];
		p[0] = v1[1]*v2[2]-v1[2]*v2[1];
		p[1] = v1[2]*v2[0]-v1[0]*v2[2];
		p[2] = v1[0]*v2[1]-v1[1]*v2[0];
		return p;
	}
	
	public static double[] normal(double[][] t)
	{
		return crossProduct(toVector(t[0],t[1]),toVector(t[0],t[2]));
	}
	
	public static double[] pTimesNum(double[] p, double num)
	{
		return new double[]{p[0]*num, p[1]*num, p[2]*num};
	}
	
	public static double[] pAddition(double[] p1, double[] p2)
	{
		return new double[]{p1[0]+p2[0],p1[1]+p2[1],p1[2]+p2[2]};
	}
}

