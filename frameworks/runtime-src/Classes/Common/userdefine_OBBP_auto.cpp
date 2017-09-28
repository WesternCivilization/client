#include "userdefine_OBBP_auto.hpp"
#include "OBBP.h"
#include "scripting/lua-bindings/manual/tolua_fix.h"
#include "scripting/lua-bindings/manual/LuaBasicConversions.h"

int lua_userdefine_OBBP_OBBP_getVertex(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_getVertex'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "OBBP:getVertex");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_getVertex'", nullptr);
            return 0;
        }
        VECTOR2 ret = cobj->getVertex(arg0);
        #pragma warning NO CONVERSION FROM NATIVE FOR VECTOR2;
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:getVertex",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_getVertex'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_getRect(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_getRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Rect arg0;

        ok &= luaval_to_rect(tolua_S, 2, &arg0, "OBBP:getRect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_getRect'", nullptr);
            return 0;
        }
        cocos2d::Rect ret = cobj->getRect(arg0);
        rect_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:getRect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_getRect'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_GetObjectBoundBox(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_GetObjectBoundBox'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_GetObjectBoundBox'", nullptr);
            return 0;
        }
        cocos2d::Rect ret = cobj->GetObjectBoundBox();
        rect_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:GetObjectBoundBox",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_GetObjectBoundBox'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_getX(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_getX'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "OBBP:getX");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_getX'", nullptr);
            return 0;
        }
        int ret = cobj->getX(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:getX",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_getX'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_getY(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_getY'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        int arg0;

        ok &= luaval_to_int32(tolua_S, 2,(int *)&arg0, "OBBP:getY");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_getY'", nullptr);
            return 0;
        }
        int ret = cobj->getY(arg0);
        tolua_pushnumber(tolua_S,(lua_Number)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:getY",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_getY'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_SetCollideInfo(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_SetCollideInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 3) 
    {
        cocos2d::Sprite* arg0;
        int arg1;
        int arg2;

        ok &= luaval_to_object<cocos2d::Sprite>(tolua_S, 2, "cc.Sprite",&arg0, "OBBP:SetCollideInfo");

        ok &= luaval_to_int32(tolua_S, 3,(int *)&arg1, "OBBP:SetCollideInfo");

        ok &= luaval_to_int32(tolua_S, 4,(int *)&arg2, "OBBP:SetCollideInfo");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_SetCollideInfo'", nullptr);
            return 0;
        }
        cobj->SetCollideInfo(arg0, arg1, arg2);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:SetCollideInfo",argc, 3);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_SetCollideInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_intersectsRect(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_intersectsRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        OBBP* arg0;

        ok &= luaval_to_object<OBBP>(tolua_S, 2, "OBBP",&arg0, "OBBP:intersectsRect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_intersectsRect'", nullptr);
            return 0;
        }
        bool ret = cobj->intersectsRect(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:intersectsRect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_intersectsRect'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_GetCollideInfo(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_GetCollideInfo'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_GetCollideInfo'", nullptr);
            return 0;
        }
        cobj->GetCollideInfo();
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:GetCollideInfo",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_GetCollideInfo'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_getWinRect(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_getWinRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Rect arg0;

        ok &= luaval_to_rect(tolua_S, 2, &arg0, "OBBP:getWinRect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_getWinRect'", nullptr);
            return 0;
        }
        cocos2d::Rect ret = cobj->getWinRect(arg0);
        rect_to_luaval(tolua_S, ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:getWinRect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_getWinRect'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_isCollidWithOBB(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_isCollidWithOBB'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        OBBP* arg0;

        ok &= luaval_to_object<OBBP>(tolua_S, 2, "OBBP",&arg0, "OBBP:isCollidWithOBB");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_isCollidWithOBB'", nullptr);
            return 0;
        }
        bool ret = cobj->isCollidWithOBB(arg0);
        tolua_pushboolean(tolua_S,(bool)ret);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:isCollidWithOBB",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_isCollidWithOBB'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_setRect(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_setRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Rect arg0;

        ok &= luaval_to_rect(tolua_S, 2, &arg0, "OBBP:setRect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_setRect'", nullptr);
            return 0;
        }
        cobj->setRect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:setRect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_setRect'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_setWinRect(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif


#if COCOS2D_DEBUG >= 1
    if (!tolua_isusertype(tolua_S,1,"OBBP",0,&tolua_err)) goto tolua_lerror;
#endif

    cobj = (OBBP*)tolua_tousertype(tolua_S,1,0);

#if COCOS2D_DEBUG >= 1
    if (!cobj) 
    {
        tolua_error(tolua_S,"invalid 'cobj' in function 'lua_userdefine_OBBP_OBBP_setWinRect'", nullptr);
        return 0;
    }
#endif

    argc = lua_gettop(tolua_S)-1;
    if (argc == 1) 
    {
        cocos2d::Rect arg0;

        ok &= luaval_to_rect(tolua_S, 2, &arg0, "OBBP:setWinRect");
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_setWinRect'", nullptr);
            return 0;
        }
        cobj->setWinRect(arg0);
        lua_settop(tolua_S, 1);
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:setWinRect",argc, 1);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_lerror:
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_setWinRect'.",&tolua_err);
#endif

    return 0;
}
int lua_userdefine_OBBP_OBBP_constructor(lua_State* tolua_S)
{
    int argc = 0;
    OBBP* cobj = nullptr;
    bool ok  = true;

#if COCOS2D_DEBUG >= 1
    tolua_Error tolua_err;
#endif



    argc = lua_gettop(tolua_S)-1;
    if (argc == 0) 
    {
        if(!ok)
        {
            tolua_error(tolua_S,"invalid arguments in function 'lua_userdefine_OBBP_OBBP_constructor'", nullptr);
            return 0;
        }
        cobj = new OBBP();
        cobj->autorelease();
        int ID =  (int)cobj->_ID ;
        int* luaID =  &cobj->_luaID ;
        toluafix_pushusertype_ccobject(tolua_S, ID, luaID, (void*)cobj,"OBBP");
        return 1;
    }
    luaL_error(tolua_S, "%s has wrong number of arguments: %d, was expecting %d \n", "OBBP:OBBP",argc, 0);
    return 0;

#if COCOS2D_DEBUG >= 1
    tolua_error(tolua_S,"#ferror in function 'lua_userdefine_OBBP_OBBP_constructor'.",&tolua_err);
#endif

    return 0;
}

static int lua_userdefine_OBBP_OBBP_finalize(lua_State* tolua_S)
{
    printf("luabindings: finalizing LUA object (OBBP)");
    return 0;
}

int lua_register_userdefine_OBBP_OBBP(lua_State* tolua_S)
{
    tolua_usertype(tolua_S,"OBBP");
    tolua_cclass(tolua_S,"OBBP","OBBP","cc.Ref",nullptr);

    tolua_beginmodule(tolua_S,"OBBP");
        tolua_function(tolua_S,"new",lua_userdefine_OBBP_OBBP_constructor);
        tolua_function(tolua_S,"getVertex",lua_userdefine_OBBP_OBBP_getVertex);
        tolua_function(tolua_S,"getRect",lua_userdefine_OBBP_OBBP_getRect);
        tolua_function(tolua_S,"GetObjectBoundBox",lua_userdefine_OBBP_OBBP_GetObjectBoundBox);
        tolua_function(tolua_S,"getX",lua_userdefine_OBBP_OBBP_getX);
        tolua_function(tolua_S,"getY",lua_userdefine_OBBP_OBBP_getY);
        tolua_function(tolua_S,"SetCollideInfo",lua_userdefine_OBBP_OBBP_SetCollideInfo);
        tolua_function(tolua_S,"intersectsRect",lua_userdefine_OBBP_OBBP_intersectsRect);
        tolua_function(tolua_S,"GetCollideInfo",lua_userdefine_OBBP_OBBP_GetCollideInfo);
        tolua_function(tolua_S,"getWinRect",lua_userdefine_OBBP_OBBP_getWinRect);
        tolua_function(tolua_S,"isCollidWithOBB",lua_userdefine_OBBP_OBBP_isCollidWithOBB);
        tolua_function(tolua_S,"setRect",lua_userdefine_OBBP_OBBP_setRect);
        tolua_function(tolua_S,"setWinRect",lua_userdefine_OBBP_OBBP_setWinRect);
    tolua_endmodule(tolua_S);
    std::string typeName = typeid(OBBP).name();
    g_luaType[typeName] = "OBBP";
    g_typeCast["OBBP"] = "OBBP";
    return 1;
}
TOLUA_API int register_all_userdefine_OBBP(lua_State* tolua_S)
{
	tolua_open(tolua_S);
	
	tolua_module(tolua_S,nullptr,0);
	tolua_beginmodule(tolua_S,nullptr);

	lua_register_userdefine_OBBP_OBBP(tolua_S);

	tolua_endmodule(tolua_S);
	return 1;
}

