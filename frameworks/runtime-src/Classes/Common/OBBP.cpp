#include"OBBP.h"
#include<assert.h>
#include <math.h>
Projection::Projection(float _min, float _max)
	:min(_min),
	max(_max)
{

}

Projection::Projection()
{

}

Projection::~Projection()
{

}

float Projection::getMax() const
{
	return max ;
}

float Projection::getMin() const
{
	return min ;
}

bool Projection::overlap(Projection* proj)
{
	if(min > proj->getMax()) return false ;
	if(max < proj->getMin()) return false ;

	return true ;
}

OBBP::OBBP()
{
	_safe_dist = 0;
	bDefault = true;
	m_WinRect = Rect(0, 0, 1334, 750);
}

OBBP::~OBBP()
{
	//log("delete zzzzzzzzzzzz");
}

 



VECTOR2 OBBP::getVertex(int index) const
{
	assert(0 <= index && index <=3 && "The index must be from 0 to 3");
	return vertex[index] ;
}

int OBBP::getX(int index) const
{
	return vertex[index].x;
}

int OBBP::getY(int index) const
{
	return vertex[index].y;
}

 
void OBBP::setVertex(int index , float x, float y)
{
	assert(0 <= index && index <=3 && "The index must be from 0 to 3");
	vertex[index].x = x ;
	vertex[index].y = y ;
}

void OBBP::setVertex(int index, VECTOR2 v)
{
	assert(0 <= index && index <=3 && "The index must be from 0 to 3");
	vertex[index].x = v.x ;
	vertex[index].y = v.y ;
}

void OBBP::getAxies(VECTOR2* axie)
{
	for(int i = 0 ; i < 4 ; i ++)
	{
		VECTOR2 s ;
		Vec2Sub(s,vertex[i],vertex[(i+1)%4]);
		Vec2Normalize(s, s);
		axie[i].x = -s.y ;
		axie[i].y = s.x ;
	}
}

Projection OBBP::getProjection(VECTOR2 axie)
{
	float min = 0 ;
	Vec2Dot(min,vertex[0], axie);
	float max = min ;

	for(int i = 1 ; i < 4 ; i ++)
	{
		float temp = 0 ;
		Vec2Dot(temp, vertex[i], axie);
		if(temp > max)
			max = temp ;
		else if(temp < min)
			min = temp ;
	}// end for

	return Projection(min, max);
}
bool OBBP::intersectsRect(OBBP* obb)
{
	Rect ob2 = obb->GetObjectBoundBox();
	if (m_WinRect.intersectsRect(ob2) &&  GetObjectBoundBox().intersectsRect(ob2))
	{
		return isCollidWithOBB(obb);
	}
	return false;
}
bool OBBP::isCollidWithOBB(OBBP* obb)
{
	this->GetCollideInfo();
	obb->GetCollideInfo();
	if ( sp == nullptr) {
		return false;
	}
	//Get the seperat axie
	getAxies(axie1);
	obb->getAxies(axie2);

	//Check for overlap for all of the axies
	for(int i = 0 ; i < 4 ; i ++)
	{
		Projection p1 = getProjection(axie1[i]);
		Projection p2 = obb->getProjection(axie1[i]);

		if(!p1.overlap(&p2)){
			return false ;
		}
	}

	for(int i = 0 ; i < 4 ; i ++)
	{
		Projection p1 = getProjection(axie2[i]);
		Projection p2 = obb->getProjection(axie2[i]);

		if(!p1.overlap(&p2)){
			return false ;
		}
	}

	return true ;
}

void OBBP::SetCollideInfo(Sprite* _sp, int width, int height)
{ 
	sp = _sp;
	if (width != -1 || height != -1) {
		bDefault = false;
		m_Rect = Rect(0, 0, width, height);
	}
	_safe_dist =  sqrt(width * width + height * height) / 2;
}
Rect OBBP::GetObjectBoundBox()
{
	Vec2 pos =sp-> getPosition();
	return Rect(pos.x- _safe_dist,  pos.y- _safe_dist,  pos.x+ _safe_dist,  pos.y+ _safe_dist);
 }
 
void OBBP::GetCollideInfo()
{  
	if (bDefault) {
		m_Rect = Rect(0, 0, sp->getTextureRect().size.width, sp->getTextureRect().size.height);
	}
	Vec2 currentPos = sp->getPosition();
	if (m_pLastPos == currentPos  )
	{
		return  ;
	}
	m_pLastPos = currentPos;

	int x1 = m_Rect.origin.x;
	int y1 = m_Rect.origin.y;
	int x2 = m_Rect.origin.x + m_Rect.size.width;
	int y2 = m_Rect.origin.y + m_Rect.size.height;

	Vec2 pt = sp->convertToWorldSpace(Vec2(x1, y1));
	this->setVertex(0, pt.x, pt.y);

	pt = sp->convertToWorldSpace(Vec2(x2, y1));
	this->setVertex(1, pt.x, pt.y);

	pt = sp->convertToWorldSpace(Vec2(x2, y2));
	this->setVertex(2, pt.x, pt.y);

	pt = sp->convertToWorldSpace(Vec2(x1, y2));
	this->setVertex(3, pt.x, pt.y);

	//Vec2 pos = sp->getPosition();
	//float x = pos.x + m_Rect.origin.x;
	//float y = pos.y + m_Rect.origin.y;
	//this->setVertex(0, x, y);
	//this->setVertex(1, x + m_Rect.size.width, y);
	//this->setVertex(2, x + m_Rect.size.width, y + m_Rect.size.height);
	//this->setVertex(3, x, y + m_Rect.size.height);

	return  ;
}
