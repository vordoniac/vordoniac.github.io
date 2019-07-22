#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

toRadians(angle)
{
	return Round(angle*0.0174532925199,6)
}

toDegrees(angle)
{
	return Round(angle*57.2957795131,6)
}

isObtuse(t)
{
	obtuse := [false,false,false,false]
	if(angleBetweenVectors(toVector(t[1],t[2]), toVector(t[1],t[3])) > toRadians(90))
	{
		obtuse[4] := true
		obtuse[1] := true
	}
	if(angleBetweenVectors(toVector(t[2],t[1]), toVector(t[2],t[3])) > toRadians(90))
	{
		obtuse[4] := true
		obtuse[2] := true
	}
	if(angleBetweenVectors(toVector(t[3],t[1]), toVector(t[3],t[2])) > toRadians(90))
	{
		obtuse[4] := true
		obtuse[3] := true
	}
	return obtuse
}

largestAngle(t)
{
	largestV := angleBetweenVectors(toVector(t[1],t[2]),toVector(t[1],t[3]))
	largest := 1
	if(angleBetweenVectors(toVector(t[2],t[1]),toVector(t[2],t[3])) > largestV)
	{
		largestV := angleBetweenVectors(toVector(t[2],t[1]),toVector(t[2],t[3]))
		largest := 2
	}
	if(angleBetweenVectors(toVector(t[3],t[1]),toVector(t[3],t[2])) > largestV)
	{
		largest := 3
	}
	return largest
}

isRight(t)
{
	right := [false,false,false,false]
	if(angleBetweenVectors(toVector(t[1],t[2]), toVector(t[1],t[3])) = toRadians(90))
	{
		right[4] := true
		right[1] := true
	}
	if(angleBetweenVectors(toVector(t[2],t[1]), toVector(t[2],t[3])) = toRadians(90))
	{
		right[4] := true
		right[2] := true
	}
	if(angleBetweenVectors(toVector(t[3],t[1]), toVector(t[3],t[2])) = toRadians(90))
	{
		right[4] := true
		right[3] := true
	}
	return right
}

angleBetweenVectors(p1,p2)
{
	
	return Round(ACos((p1[1]*p2[1]+p1[2]*p2[2]+p1[3]*p2[3])/(magnitude(p1)*magnitude(p2))),6)
}

isIso(t)
{
	if(round(magnitude(toVector(t[1],t[2])),3) = round(magnitude(toVector(t[1],t[3])),3))
	{
		return true
	}
	if(round(magnitude(toVector(t[2],t[1])),3) = round(magnitude(toVector(t[2],t[3])),3))
	{
		return true
	}
	if(round(magnitude(toVector(t[3],t[2])),3) = round(magnitude(toVector(t[3],t[1])),3))
	{
		return true
	}
	return false
}

magnitude(v)
{
	return Sqrt(v[1]*v[1] + v[2]*v[2] + v[3]*v[3])
}

toVector(p1,p2)
{
	return [p2[1]-p1[1],p2[2]-p1[2],p2[3]-p1[3]]
}

distance(p1,p2)
{
	return magnitude(toVector(p1,p2))
}

meanP(p1,p2)
{
	return [(p1[1]+p2[1])/2,(p1[2]+p2[2])/2,(p1[3]+p2[3])/2]
}

resultant(v1,v2)
{
	return [v1[1]+v2[1], v1[2]+v2[2], v1[3]+v2[3]]
}

matMultS(mat1,mat2)
{
	if(mat1[1].Length() != mat2.Length())
	{
		return null
	}
	
	matM := [[0,0,0]]
	sum := 0
	o := 1
	k := 1
	n := 1
	mat1L := mat1.Length()
	mat2LL := mat2[1].Length()
	mat2L := mat2.Length()
	
	Loop, %mat1L%
	{
		Loop, %mat2LL%
		{
			Loop, %mat2L%
			{
				sum := sum + mat1[o][n]*mat2[n][k]
				n := n + 1
			}
			n := 1
			matM[o][k] := sum
			sum := 0
			k := k + 1
		}
		k := 1
		o := o + 1
	}
	return matM
}

rot(p,v,r)
{
	q0 := Cos(r/2)
	q1 := Sin(r/2) * v[1]
	q2 := Sin(r/2) * v[2]
	q3 := Sin(r/2) * v[3]
	
	Q := [[q0*q0 + q1*q1 - q2*q2 - q3*q3, 2*(q1*q2 - q0*q3), 2*(q1*q3 + q0*q2)],[2*(q2*q1 + q0*q3), q0*q0 - q1*q1 + q2*q2 - q3*q3, 2*(q2*q3 - q0*q1)],[2*(q3*q1 - q0*q2), 2*(q3*q2 + q0*q1), q0*q0 - q1*q1 - q2*q2 + q3*q3]]
	
	return matMultS([p], Q)[1]
}

rotY(p,r)
{
	return [p[1]*Cos(r)+p[3]*Sin(r),p[2],p[3]*Cos(r)-p[1]*Sin(r)]
}

rotV(p,v,r)
{
	theX := 0.5
	theY := 0.5
	theZ := 0.5
	
	theX := p[1]*(Cos(r)+v[1]*v[1]*(1-Cos(r)))+p[2]*(v[1]*v[2]*(1-Cos(r))-v[3]*Sin(r))+p[3]*(v[1]*v[3]*(1-Cos(r))+v[2]*Sin(r))
	theY := p[1]*(v[2]*v[1]*(1-Cos(r)+v[3]*Sin(r)))+p[2]*(Cos(r)+v[2]*v[2]*(1-Cos(r)))+p[3]*(v[2]*v[3]*(1-Cos(r))-v[1]*Sin(r))
	theZ := p[1]*(v[3]*v[1]*(1-Cos(r))-v[2]*Sin(r))+p[2]*(v[3]*v[2]*(1-Cos(r))+v[1]*Sin(r))+p[3]*(Cos(r)+v[3]*v[3]*(1-Cos(r)))
	return [theX,theY,theZ]
}

rotZ(p,r)
{
	return [p[1]*Cos(r)-p[2]*Sin(r),p[1]*Sin(r)+p[2]*Cos(r),p[3]]
}

roundP(p)
{
	newP := [0,0,0]
	newP[1] := Round(p[1],5)
	newP[2] := Round(p[2],5)
	newP[3] := Round(p[3],5)
	return newP
}

normalize(v)
{
	m := magnitude(v)
	return [v[1]/m,v[2]/m,v[3]/m]
}

crossProduct(v1, v2)
{
	p := [0,0,0]
	p[1] := v1[2]*v2[3]-v1[3]*v2[2]
	p[2] := v1[3]*v2[1]-v1[1]*v2[3]
	p[3] := v1[1]*v2[2]-v1[2]*v2[1]
	return p
}

normal(t)
{
	return crossProduct(toVector(t[1],t[2]),toVector(t[1],t[3]))
}

pTimesNum(p, num)
{
	return [p[1]*num, p[2]*num, p[3]*num]
}

pAddition(p1, p2)
{
	return [p1[1]+p2[1], p1[2]+p2[2], p1[3]+p2[3]]
}

getSidesIso(t)
{
	oppToBase := t[1]
	base1 := t[2]
	base2 := t[3]
	
	if(round(distance(t[2],t[1]),3) = round(distance(t[2],t[3]),3))
	{
		oppToBase := t[2]
		base1 := t[1]
		base2 := t[3]
	}
	if(round(distance(t[3],t[1]),3) = round(distance(t[3],t[2]),3))
	{
		oppToBase := t[3]
		base1 := t[1]
		base2 := t[2]
	}
	
	return [oppToBase,base1,base2]
}

getCentroid(t)
{
	return [((t[1][1] + t[2][1] + t[3][1])/3), ((t[1][2] + t[2][2] + t[3][2])/3), ((t[1][3] + t[2][3] + t[3][3])/3)]
}

getIsoAltitude(t)
{
	s := ((distance(t[1], t[2]) + distance(t[2], t[3]) + distance(t[3], t[1]))/2)
	area := Sqrt(s*(s-distance(t[1], t[2]))*(s-distance(t[2], t[3]))*(s-distance(t[3], t[1])))
	return (2*(area/distance(t[2], t[3])))
}

isoToReg(t, afz, afx)
{
	/*
	Just try to ignore this comment section. I keep it here for reasons, I swear. 
	reverse := false
	if(afx = 315 || afx = 0 || afx = 45 || afx = 135 || afx = 225)
	{
		afx := afx + .001
	}
	if(afx>315)
	{
		reverse := true
	}
	if(afx>0 && afx<45)
	{
		reverse := true
	}
	
	if(afx>135 && afx<225)
	{
		reverse := true
	}
	reverse2 := false
	if(afz = 315 || afz = 0 || afz = 45 || afz = 135 || afz = 225)
	{
		afz := afz + .001
	}
	if(afz>315)
	{
		reverse2 := true
	}
	if(afz>0 && afz<45)
	{
		reverse2 := true
	}
	
	if(afz>135 && afz<225)
	{
		reverse2 := true
	}
	*/
	
	tri := [0,0,0]
	tri[1] := t[1]
	tri[2] := t[2]
	tri[3] := t[3]
	tN := [0,0,0]
	tN[1] := t[1]
	tN[2] := t[2]
	tN[3] := t[3]
	tN[1] := [tN[1][1] - getCentroid(tri)[1],tN[1][2] - getCentroid(tri)[2],tN[1][3] - getCentroid(tri)[3]]
	tN[2] := [tN[2][1] - getCentroid(tri)[1],tN[2][2] - getCentroid(tri)[2],tN[2][3] - getCentroid(tri)[3]]
	tN[3] := [tN[3][1] - getCentroid(tri)[1],tN[3][2] - getCentroid(tri)[2],tN[3][3] - getCentroid(tri)[3]]
	
	tri[1] := tN[1]
	tri[2] := tN[2]
	tri[3] := tN[3]
	
	tN[1] := rotY(tri[1], (-1)*toRadians(afx))
	tN[2] := rotY(tri[2], (-1)*toRadians(afx))
	tN[3] := rotY(tri[3], (-1)*toRadians(afx))
	
	tri[1] := tN[1]
	tri[2] := tN[2]
	tri[3] := tN[3]
	
	tN[1] := rotZ(tri[1], (-1)*toRadians(afz))
	tN[2] := rotZ(tri[2], (-1)*toRadians(afz))
	tN[3] := rotZ(tri[3], (-1)*toRadians(afz))
	
	ang := Atan2([tN[1][2],tN[1][3]])
	if(ang<0)
	{
		ang := ang + 6.28318530718
	}
	
	;ang := ang - 1.57079632679
	
	if(ang<0)
	{
		ang := ang + 6.28318530718
	}
	
	return ang
}

getT(opp, bas,n)
{
	return -(n[1]*opp[1] + n[2]*opp[2] + n[2]*opp[2] - (n[1]*bas[1] + n[2]*bas[2] + n[3]*bas[3]))/(n[1]*n[1] + n[2]*n[2] + n[3]*n[3])
}

Atan2(p)
{
	if(p[1] > 0)
	{
		return ATan(p[2]/p[1])
	}
	else if(p[1] < 0 && p[2] >= 0)
	{
		return ATan(p[2]/p[1]) + 3.14159265359
	}
	else if(p[1] < 0 && p[2] < 0)
	{
		return ATan(p[2]/p[1]) - 3.14159265359
	}
	else if(p[1] = 0 && p[2] > 0)
	{
		return 1.57079632679
	}
	else if(p[1] = 0 && p[2] < 0)
	{
		return -1.57079632679
	}
	else
	{
		;MsgBox, Hey
		return 0
	}
}

Atan3(p)
{
	ang := Atan2(p)
	if(ang<0)
	{
		ang := ang + 6.28318530718 
	}
	
	return ang
}

Acos2(aj, op, hy)
{
	if(op<0)
	{
		return ACos(aj/hy) + 3.14159265359
	}
	return ACos(aj/hy)
}

irregToIso(t)
{
	iso := []
	if(isIso(t))
	{
		iso.Push(t)
		return iso
	}
	s := ((distance(t[1], t[2]) + distance(t[2], t[3]) + distance(t[3], t[1]))/2)
	area := Sqrt(s*(s-distance(t[1], t[2]))*(s-distance(t[2], t[3]))*(s-distance(t[3], t[1])))
	oppToBase := t[1]
	base := [t[2],t[3]]
	
	if(true) ;You *really* shouldn't try understanding my coding decisions. The only thing you'll gain from doing so is a headache.
	{
		if(distance(t[1], t[2]) > distance(t[2], t[3]) && distance(t[1], t[2]) > distance(t[3], t[1]))
		{
			oppToBase := t[3]
			base := [t[1],t[2]]
		}
		else if(distance(t[2], t[3]) > distance(t[1], t[2]) && distance(t[2], t[3]) > distance(t[3], t[1]))
		{
			oppToBase := t[1]
			base := [t[2],t[3]]
		}
		else if(distance(t[3], t[1]) > distance(t[1], t[2]) && distance(t[3], t[1]) > distance(t[2], t[3]))
		{
			oppToBase := t[2]
			base := [t[3],t[1]]
		}
	}
	else
	{
		if(isRight(t)[1])
		{
			iso.Push([t[2],t[1],meanP(t[2],t[3])])
			iso.Push([t[3],t[1],meanP(t[2],t[3])])
		}
		else if(isRight(t)[2])
		{
			iso.Push([t[1],t[2],meanP(t[1],t[3])])
			iso.Push([t[3],t[2],meanP(t[1],t[3])])
		}
		else if(isRight(t)[3])
		{
			iso.Push([t[2],t[3],meanP(t[2],t[1])])
			iso.Push([t[1],t[3],meanP(t[2],t[1])])
		}
		return iso
	}
	altitude := 2*(area/distance(base[1], base[2]))
	intrsct := roundP(pAddition(pTimesNum(normalize(roundP(rot(normal(t),normalize(toVector(base[1],base[2])),toRadians(-90)))),altitude),oppToBase))
	tangent := rot(normal(t),normalize(toVector(base[1],base[2])), toRadians(-90))
	iso.Push([base[1],intrsct,meanP(base[1],oppToBase)])
	iso.Push([oppToBase,intrsct,meanP(base[1],oppToBase)])
	iso.Push([oppToBase,intrsct,meanP(base[2],oppToBase)])
	iso.Push([intrsct,meanP(base[2],oppToBase),base[2]])
	
	return iso
}

trisToMsg(il)
{
	
	s := ""
	
	ii := 1
	kk := 1
	jj := 1
	b := il.Length()
	Loop, %b%
	{
		s := s . "   Tri(" . ii . "): "
		Loop, 3
		{
			s := s . "["
			Loop, 3
			{
				temp := il[ii][kk][jj]
				s := s . "," . temp
				jj := jj + 1
			}
			s := s . "]"
			jj := 1
			kk := kk + 1
		}
	kk := 1
	ii := ii + 1
	}
	
	MsgBox, %s%
}

s::

tr := [[0,4,0],[-3,0,0],[3,0,0]]



translationX := 0
translationY := 0
translationZ := 0
isoAltitude := 0
scaleFactorX := 0
scaleFactorY := 0
angleFromZ := 0
angleFromX := 0
rColor := 0
gColor := 0
bColor := 0
dataCount := 1
tempS := ""
tempX := 0
tempY := 0
tempZ := 0
spaceDelay := 200
triLoopCount := 1
scl := 55.4256258422



Loop, read, L:\OldPC\Documents\your_file_here.txt ;This where you put your file directory loctation place. The one here is just for example purposes
{
	if(dataCount = 3)
	{
		tempS := StrSplit(SubStr(A_LoopReadLine, 10, -2),", ")
		tempX := tempS[1] + 0.0
		tempY := tempS[2] + 0.0
		tempZ := tempS[3] + 0.0
		tr[1] := [tempX + 0.0,tempY + 0.0,tempZ + 0.0]
		dataCount := 4
	}
	else if(dataCount = 4)
	{
		tempS := StrSplit(SubStr(A_LoopReadLine, 10, -2),", ")
		tempX := tempS[1] + 0.0
		tempY := tempS[2] + 0.0
		tempZ := tempS[3] + 0.0
		tr[2] := [tempX + 0.0,tempY + 0.0,tempZ + 0.0]
		dataCount := 5
	}
	else if(dataCount = 5)
	{
		tempS := StrSplit(SubStr(A_LoopReadLine, 10, -2),", ")
		tempX := tempS[1] + 0.0
		tempY := tempS[2] + 0.0
		tempZ := tempS[3] + 0.0
		tr[3] := [tempX + 0.0,tempY + 0.0,tempZ + 0.0]
		isoTris := irregToIso(tr)
		tempL := isoTris.Length()
		first := true
		somthing := false
		Loop, %tempL%
		{
			if(isoTris[triLoopCount][1][1] = 1 && isoTris[triLoopCount][2][1] = 1 && isoTris[triLoopCount][3][1] = 1 )
			{
				somthing := true
			}
			sides := getSidesIso(isoTris[triLoopCount])
			translationX := getCentroid(sides)[1] * scl
			translationY := getCentroid(sides)[2] * scl
			translationZ := getCentroid(sides)[3] * scl
			isoAltitude := getIsoAltitude(sides)
			scaleFactorX := distance(sides[2],sides[3])
			scaleFactorY := round((isoAltitude*2)/(Sqrt(3)),6)
			isoNormal := normal(sides)
			angleFromX := toDegrees(round(Atan3([isoNormal[1],-isoNormal[3]]),4))
			angleFromZ := toDegrees(round(Atan3([(Sqrt(isoNormal[1]*isoNormal[1] + isoNormal[3]*isoNormal[3])),(isoNormal[2])]),6))
			
			
			angleAroundX := toDegrees(round(isoToReg(sides, angleFromZ, angleFromX),6))
			angleFromX := toDegrees(round(Atan3([isoNormal[1],-isoNormal[3]]),4))
			angleFromZ := toDegrees(round(Atan3([(Sqrt(isoNormal[1]*isoNormal[1] + isoNormal[3]*isoNormal[3])),(isoNormal[2])]),6))
			
			/*HERE IS WHERE YOU PROBABLY WANT TO DO THINGS (aka, move mouse, press buttons, autohot key stuff. I think you can even make
			a text file and write to it if you want to do that sort of thing). You the important variables are translationX, translationY, 
			translationZ, angleAroundX, angleFromZ, angleFromX, scaleFactorX, scaleFactorY, rColor, gColor, and bColor.*/
			
			
			
			
			
			
			
			/*HERE IS WHERE YOU PROBABLY WANT TO STOP DOING THINGS*/
			first := false
			triLoopCount := triLoopCount + 1
			somthing := false
		}
		triLoopCount := 1
		dataCount := 6
	}
	else if(dataCount = 1)
	{
		dataCount := 2
	}
	else if(dataCount = 2)
	{
		rColor := SubStr(A_LoopReadLine, 11, 6) + 0.0
		gColor := SubStr(A_LoopReadLine, 21, 6) + 0.0
		bColor := SubStr(A_LoopReadLine, 31, 6) + 0.0
		dataCount := 3
	}
	else if(dataCount = 6)
	{
		
		dataCount := 2
	}
}


return


w:: ;Pressing w ends the script no matter what. Serves as a "Hold on that's not what you're supposed to do!" button.
ExitApp































