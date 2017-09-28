#ifndef  _APP_OBBP
#define  _APP_OBBP
#include"XJMath.h"
#include "cocos2d.h"
USING_NS_CC;
class Projection
{
public:
	Projection();
	Projection(float min, float max);
 
	~Projection();

public:
	bool overlap(Projection* proj);

public:
	float getMin() const;
	float getMax() const ;

private:
	float min ;
	float max ;
};

class OBBP : public cocos2d::Ref
{
public:
	OBBP();
	~OBBP();
  
	 
	bool intersectsRect(OBBP* obb);
	bool isCollidWithOBB(OBBP* obb);

	void setWinRect(Rect _rect) {
		m_WinRect = _rect;
	}
	void setRect(Rect _rect) {
		m_Rect = _rect;
	}
	Rect getWinRect(Rect _rect) {
		return m_WinRect ;
	}
	Rect getRect(Rect _rect) {
		return m_Rect  ;
	}
	void SetCollideInfo(Sprite* sp,int width, int height);
	void GetCollideInfo();

	Rect GetObjectBoundBox();
	 
	VECTOR2 getVertex(int index) const;
	int getX(int index) const;
	int getY(int index) const;
	
private:
	bool bDefault;
	int _safe_dist;
	Rect				m_Rect;
	Rect				m_WinRect;
	void getAxies(VECTOR2 * axie);
	 
	void setVertex(int index, float x, float y);
	void setVertex(int index, VECTOR2 v);

	Projection getProjection(VECTOR2 axie);

	VECTOR2 vertex[4] ;
	VECTOR2 axie1[4] ;
	VECTOR2 axie2[4] ;
	Sprite*  sp;
	Vec2				m_pLastPos;			// …œ¥ŒŒª÷√
	
};

#endif